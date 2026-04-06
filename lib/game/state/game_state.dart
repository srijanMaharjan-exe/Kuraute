import '../../data/models/word_entry.dart';

enum PlayerRole { crew, kuraute }

enum RevealPhase { passPhone, holdToReveal, revealed }

enum GamePhase { setup, reveal, discussion, result }

enum AppLanguage { english, nepali }

class PlayerTurnView {
  const PlayerTurnView({
    required this.playerName,
    required this.role,
    required this.secretWord,
    required this.guptacharHint,
    required this.phase,
  });

  final String playerName;
  final PlayerRole role;
  final String secretWord;
  final String guptacharHint;
  final RevealPhase phase;
}

class GameState {
  const GameState({
    this.players = const <String>[],
    this.selectedPackIds = const <String>['food'],
    this.language = AppLanguage.english,
    this.secretWord,
    this.kurauteIndex,
    this.currentRevealIndex = 0,
    this.revealPhase = RevealPhase.passPhone,
    this.gamePhase = GamePhase.setup,
    this.roundDurationSeconds = 90,
    this.remainingSeconds = 90,
  });

  final List<String> players;
  final List<String> selectedPackIds;
  final AppLanguage language;
  final WordEntry? secretWord;
  final int? kurauteIndex;
  final int currentRevealIndex;
  final RevealPhase revealPhase;
  final GamePhase gamePhase;
  final int roundDurationSeconds;
  final int remainingSeconds;

  bool get isConfigured =>
      players.length >= 3 &&
      players.length <= 10 &&
      secretWord != null &&
      kurauteIndex != null;

  bool get isRevealComplete => isConfigured && currentRevealIndex >= players.length;

  GameState copyWith({
    List<String>? players,
    List<String>? selectedPackIds,
    AppLanguage? language,
    WordEntry? secretWord,
    int? kurauteIndex,
    int? currentRevealIndex,
    RevealPhase? revealPhase,
    GamePhase? gamePhase,
    int? roundDurationSeconds,
    int? remainingSeconds,
  }) {
    return GameState(
      players: players ?? this.players,
      selectedPackIds: selectedPackIds ?? this.selectedPackIds,
      language: language ?? this.language,
      secretWord: secretWord ?? this.secretWord,
      kurauteIndex: kurauteIndex ?? this.kurauteIndex,
      currentRevealIndex: currentRevealIndex ?? this.currentRevealIndex,
      revealPhase: revealPhase ?? this.revealPhase,
      gamePhase: gamePhase ?? this.gamePhase,
      roundDurationSeconds: roundDurationSeconds ?? this.roundDurationSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
    );
  }

  PlayerTurnView? currentTurnView() {
    if (!isConfigured || isRevealComplete) return null;

    final name = players[currentRevealIndex];
    final isKuraute = currentRevealIndex == kurauteIndex;
    return PlayerTurnView(
      playerName: name,
      role: isKuraute ? PlayerRole.kuraute : PlayerRole.crew,
      secretWord: secretWord!.word,
      guptacharHint: secretWord!.guptacharHint,
      phase: revealPhase,
    );
  }

  String? get kurauteName {
    if (kurauteIndex == null || kurauteIndex! < 0 || kurauteIndex! >= players.length) {
      return null;
    }
    return players[kurauteIndex!];
  }
}
