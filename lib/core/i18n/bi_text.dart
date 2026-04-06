import '../../game/state/game_state.dart';

String biText({
  required String en,
  required String ne,
  required AppLanguage language,
}) {
  switch (language) {
    case AppLanguage.english:
      return en;
    case AppLanguage.nepali:
      return ne;
  }
}
