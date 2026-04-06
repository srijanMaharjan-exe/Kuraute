import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/i18n/bi_text.dart';
import '../state/game_controller.dart';

class InstructionsScreen extends ConsumerWidget {
  const InstructionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(gameControllerProvider).language;

    return Scaffold(
      appBar: AppBar(title: const Text('How to Play')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _StepText(
            text: biText(
              en: '1. Add 3-10 players.',
              ne: '१. ३ देखि १० खेलाडी थप्नुहोस्।',
              language: language,
            ),
          ),
          _StepText(
            text: biText(
              en: '2. One random player becomes the Kuraute.',
              ne: '२. एक खेलाडी आकस्मिक रूपमा कुराउटे हुन्छ।',
              language: language,
            ),
          ),
          _StepText(
            text: biText(
              en: '3. Crew sees the secret word; Kuraute sees only a hint.',
              ne: '३. क्रु ले गुप्त शब्द देख्छ; कुराउटेले संकेत मात्र देख्छ।',
              language: language,
            ),
          ),
          _StepText(
            text: biText(
              en: '4. Discuss, then vote who is Kuraute.',
              ne: '४. छलफल गरी को कुराउटे हो भोट गर्नुहोस्।',
              language: language,
            ),
          ),
          _StepText(
            text: biText(
              en: '5. See the result and the final reveal.',
              ne: '५. नतिजा र अन्तिम खुलासा हेर्नुहोस्।',
              language: language,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepText extends StatelessWidget {
  const _StepText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
