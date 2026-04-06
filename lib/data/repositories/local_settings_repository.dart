import 'package:hive/hive.dart';

class LocalSettingsRepository {
  LocalSettingsRepository(this._box);

  static const boxName = 'settings_box';
  static const _selectedPacksKey = 'selected_pack_ids';
  static const _languageCodeKey = 'language_code';
  static const _roundDurationKey = 'round_duration_seconds';
  static const _recentPlayersKey = 'recent_players';

  final Box _box;

  List<String> getSelectedPackIds({List<String> fallback = const <String>['food']}) {
    final raw = _box.get(_selectedPacksKey);
    if (raw is List && raw.isNotEmpty) {
      return raw.map((e) => e.toString()).toList(growable: false);
    }
    return fallback;
  }

  String getLanguageCode({String fallback = 'both'}) {
    return (_box.get(_languageCodeKey) as String?) ?? fallback;
  }

  int getRoundDurationSeconds({int fallback = 90}) {
    return (_box.get(_roundDurationKey) as int?) ?? fallback;
  }

  List<String> getRecentPlayers() {
    final raw = _box.get(_recentPlayersKey);
    if (raw is List) {
      return raw.map((e) => e.toString()).toList(growable: false);
    }
    return const <String>[];
  }

  Future<void> saveSelectedPackIds(List<String> packIds) {
    return _box.put(_selectedPacksKey, packIds);
  }

  Future<void> saveLanguageCode(String languageCode) {
    return _box.put(_languageCodeKey, languageCode);
  }

  Future<void> saveRoundDurationSeconds(int seconds) {
    return _box.put(_roundDurationKey, seconds);
  }

  Future<void> saveRecentPlayers(List<String> players) {
    return _box.put(_recentPlayersKey, players);
  }
}
