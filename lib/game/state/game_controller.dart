import 'dart:math';
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/local_settings_repository.dart';
import '../../data/models/word_pack.dart';
import '../../data/repositories/local_word_pack_repository.dart';
import 'game_state.dart';

final localWordPackRepositoryProvider = Provider<LocalWordPackRepository>((ref) {
  throw UnimplementedError(
    'Override localWordPackRepositoryProvider in main() after Hive init.',
  );
});

final gameControllerProvider = StateNotifierProvider<GameController, GameState>(
  (ref) => GameController(
    ref.watch(localWordPackRepositoryProvider),
    ref.watch(localSettingsRepositoryProvider),
  ),
);

final localSettingsRepositoryProvider = Provider<LocalSettingsRepository>((ref) {
  throw UnimplementedError(
    'Override localSettingsRepositoryProvider in main() after Hive init.',
  );
});

final availableWordPacksProvider = Provider<List<WordPack>>((ref) {
  return ref.watch(localWordPackRepositoryProvider).getAllPacks();
});

class GameController extends StateNotifier<GameState> {
  GameController(this._wordRepo, this._settingsRepo)
      : super(
          GameState(
            selectedPackIds: _settingsRepo.getSelectedPackIds(),
            language: _languageFromCode(_settingsRepo.getLanguageCode()),
            roundDurationSeconds: _settingsRepo.getRoundDurationSeconds(),
            remainingSeconds: _settingsRepo.getRoundDurationSeconds(),
            players: _settingsRepo.getRecentPlayers(),
          ),
        );

  final LocalWordPackRepository _wordRepo;
  final LocalSettingsRepository _settingsRepo;
  final _random = Random();

  static AppLanguage _languageFromCode(String code) {
    switch (code) {
      case 'english':
        return AppLanguage.english;
      case 'nepali':
        return AppLanguage.nepali;
      default:
        return AppLanguage.english;
    }
  }

  static String _languageToCode(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return 'english';
      case AppLanguage.nepali:
        return 'nepali';
    }
  }

  void setLanguage(AppLanguage language) {
    state = state.copyWith(language: language);
    unawaited(_settingsRepo.saveLanguageCode(_languageToCode(language)));
  }

  void setSelectedPack(String packId) {
    final next = <String>{...state.selectedPackIds};
    if (next.contains(packId)) {
      next.remove(packId);
    } else {
      next.add(packId);
    }

    if (next.isEmpty) {
      next.add('food');
    }

    final selected = next.toList(growable: false);
    state = state.copyWith(selectedPackIds: selected);
    unawaited(_settingsRepo.saveSelectedPackIds(selected));
  }

  void setRoundDuration(int seconds) {
    final safeSeconds = seconds.clamp(30, 300);
    state = state.copyWith(
      roundDurationSeconds: safeSeconds,
      remainingSeconds: safeSeconds,
    );
    unawaited(_settingsRepo.saveRoundDurationSeconds(safeSeconds));
  }

  void setPlayers(List<String> players) {
    final trimmed = players
        .map((name) => name.trim())
        .where((name) => name.isNotEmpty)
        .toList(growable: false);

    state = state.copyWith(players: trimmed);
    unawaited(_settingsRepo.saveRecentPlayers(trimmed));
  }

  Future<void> startGame() async {
    if (state.players.length < 3 || state.players.length > 10) {
      throw StateError('Players must be between 3 and 10.');
    }

    final secret = _wordRepo.pickRandomWordFromPacks(packIds: state.selectedPackIds);
    final kurauteIndex = _random.nextInt(state.players.length);

    state = state.copyWith(
      secretWord: secret,
      kurauteIndex: kurauteIndex,
      currentRevealIndex: 0,
      revealPhase: RevealPhase.passPhone,
      gamePhase: GamePhase.reveal,
      remainingSeconds: state.roundDurationSeconds,
    );
  }

  void beginHoldReveal() {
    if (state.isRevealComplete) return;
    state = state.copyWith(revealPhase: RevealPhase.holdToReveal);
  }

  void showIdentityWhileHolding() {
    if (state.isRevealComplete) return;
    state = state.copyWith(revealPhase: RevealPhase.revealed);
  }

  void hideIdentityOnRelease() {
    if (state.isRevealComplete) return;
    state = state.copyWith(revealPhase: RevealPhase.passPhone);
  }

  void moveToNextPlayer() {
    if (state.isRevealComplete) return;

    state = state.copyWith(
      currentRevealIndex: state.currentRevealIndex + 1,
      revealPhase: RevealPhase.passPhone,
    );

    if (state.currentRevealIndex >= state.players.length) {
      state = state.copyWith(gamePhase: GamePhase.discussion);
    }
  }

  void beginDiscussionPhase() {
    state = state.copyWith(
      gamePhase: GamePhase.discussion,
      remainingSeconds: state.roundDurationSeconds,
    );
  }

  void tickRoundTimer() {
    if (state.gamePhase != GamePhase.discussion) return;
    final next = state.remainingSeconds - 1;
    final updated = next < 0 ? 0 : next;
    state = state.copyWith(remainingSeconds: updated);
    if (updated == 0) {
      finalizeRound();
    }
  }

  void finalizeRound() {
    state = state.copyWith(gamePhase: GamePhase.result);
  }

  void resetToSetup() {
    state = state.copyWith(
      secretWord: null,
      kurauteIndex: null,
      currentRevealIndex: 0,
      revealPhase: RevealPhase.passPhone,
      gamePhase: GamePhase.setup,
      remainingSeconds: state.roundDurationSeconds,
    );
  }
}
