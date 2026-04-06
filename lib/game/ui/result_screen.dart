import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/i18n/bi_text.dart';
import '../state/game_controller.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);
    final kurauteName = state.kurauteName;
    final secretWord = state.secretWord?.word;

    return Scaffold(
      appBar: AppBar(
        title: const Text('KURAUTE'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.language)),
        ],
      ),
      backgroundColor: const Color(0xFF1B010A),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(22, 14, 22, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFCA0033), Color(0xFF0D0F08)],
              ),
              borderRadius: BorderRadius.circular(34),
            ),
            child: Column(
              children: [
                const Icon(Icons.star, color: Color(0xFFFFD709), size: 40),
                const SizedBox(height: 10),
                Text(
                  biText(
                    en: 'THE IDENTITY REVEALED',
                    ne: 'पहिचान खुल्यो',
                    language: state.language,
                  ),
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFFFFD709),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.1,
                  ),
                ),
                Text(
                  biText(
                    en: 'Who Was The Kuraute?',
                    ne: 'कुराउटे को थियो?',
                    language: state.language,
                  ),
                  style: GoogleFonts.mukta(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 0.96,
                  ),
                ),
                const SizedBox(height: 14),
                CircleAvatar(
                  radius: 54,
                  backgroundColor: const Color(0xFF776300),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color(0xFFB3002C),
                    child: Icon(
                      Icons.person,
                      size: 54,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF776300),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    (kurauteName ?? 'Unknown').toUpperCase(),
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  biText(
                    en: 'The Kuraute was',
                    ne: 'कुराउटे थियो',
                    language: state.language,
                  ),
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 30,
                    height: 0.9,
                  ),
                ),
                Text(
                  kurauteName ?? 'Unknown',
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFFFFD709),
                    fontWeight: FontWeight.w900,
                    fontSize: 38,
                    height: 0.9,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  biText(
                    en: 'Finally, the Kuraute was caught!',
                    ne: 'अन्ततः कुराउटे पक्राउ पर्यो !',
                    language: state.language,
                  ),
                  style: GoogleFonts.mukta(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0x1AFFFFFF),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0x33FFFFFF)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        biText(
                          en: 'SECRET WORD',
                          ne: 'गोप्य शब्द',
                          language: state.language,
                        ),
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        secretWord ?? 'Unknown',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFFFFD709),
                          fontWeight: FontWeight.w900,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: const Color(0x660D0F08),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.how_to_vote, color: Color(0xFFFFD709)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      biText(
                        en: 'Did you catch them? Vote now in person with your group.',
                        ne: 'कुराउटेलाई समाउनुभयो? अब समूहमा आफैं भोट गर्नुहोस्।',
                        language: state.language,
                      ),
                      style: GoogleFonts.manrope(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              controller.resetToSetup();
              context.go('/');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD709),
              foregroundColor: const Color(0xFF5B4B00),
              minimumSize: const Size.fromHeight(62),
            ),
            child: Text(
              biText(
                en: 'PLAY AGAIN',
                ne: 'फेरि खेल्नुहोस्',
                language: state.language,
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => context.go('/'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
              side: const BorderSide(color: Color(0x40FFFFFF)),
              foregroundColor: Colors.white,
            ),
            child: const Text('BACK TO LOBBY'),
          ),
        ],
      ),
    );
  }
}
