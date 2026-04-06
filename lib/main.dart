import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'data/repositories/local_settings_repository.dart';
import 'data/repositories/local_word_pack_repository.dart';
import 'game/state/game_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  final box = await Hive.openBox<Map>(LocalWordPackRepository.boxName);
  final settingsBox = await Hive.openBox(LocalSettingsRepository.boxName);
  final wordRepo = LocalWordPackRepository(box);
  final settingsRepo = LocalSettingsRepository(settingsBox);
  await wordRepo.seedDefaultsIfEmpty();

  runApp(
    ProviderScope(
      overrides: [
        localWordPackRepositoryProvider.overrideWithValue(wordRepo),
        localSettingsRepositoryProvider.overrideWithValue(settingsRepo),
      ],
      child: const KurauteApp(),
    ),
  );
}
