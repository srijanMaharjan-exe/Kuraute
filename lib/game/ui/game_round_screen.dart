import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/i18n/bi_text.dart';
import '../state/game_controller.dart';
import '../state/game_state.dart';

class GameRoundScreen extends ConsumerStatefulWidget {
  const GameRoundScreen({super.key});

  @override
  ConsumerState<GameRoundScreen> createState() => _GameRoundScreenState();
}

class _GameRoundScreenState extends ConsumerState<GameRoundScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final timerEnabled = ref.read(gameControllerProvider).discussionTimerEnabled;
    if (timerEnabled) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        final notifier = ref.read(gameControllerProvider.notifier);
        notifier.tickRoundTimer();
        final state = ref.read(gameControllerProvider);
        if (state.gamePhase == GamePhase.result || state.remainingSeconds == 0) {
          _timer?.cancel();
          if (mounted) {
            context.go('/result');
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);

    if (state.players.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No game in progress.')),
      );
    }

    if (state.gamePhase == GamePhase.result) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.go('/result');
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('KURAUTE'),
        leading: IconButton(
          onPressed: () => context.go('/reveal'),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.language)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(22, 12, 22, 20),
        children: [
          Text(
            'Discuss!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: 44,
              height: 0.9,
            ),
          ),
          Text(
            'छलफल गर्नुहोस्! कुराउटे को हो?',
            textAlign: TextAlign.center,
            style: GoogleFonts.mukta(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFCA0033),
            ),
          ),
          Text(
            'Who is the Kuraute?',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 18,
              color: const Color(0xFF64655C),
            ),
          ),
          const SizedBox(height: 18),
          if (state.discussionTimerEnabled)
            Center(
              child: SizedBox(
                width: 250,
                height: 250,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 232,
                      height: 232,
                      child: CircularProgressIndicator(
                        value: state.remainingSeconds / state.roundDurationSeconds,
                        strokeWidth: 16,
                        color: const Color(0xFF776300),
                        backgroundColor: const Color(0xFFE9E9DA),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${(state.remainingSeconds ~/ 60).toString().padLeft(2, '0')}:${(state.remainingSeconds % 60).toString().padLeft(2, '0')}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 56,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF373830),
                            letterSpacing: -1,
                          ),
                        ),
                        Text(
                          'TIME LEFT',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF776300),
                            letterSpacing: 1,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFFBFAED),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0x22CA0033)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.forum_rounded, size: 44, color: Color(0xFFCA0033)),
                  const SizedBox(height: 10),
                  Text(
                    'DISCUSSION MODE',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF373830),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    biText(
                      en: 'No timer is running. Keep discussing until the group is ready to reveal.',
                      ne: 'टाइमर बन्द छ। समूह तयार भएपछि मात्र नतिजा देखाउनुहोस्।',
                      language: state.language,
                    ),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      color: const Color(0xFF64655C),
                      fontWeight: FontWeight.w700,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              controller.finalizeRound();
              context.go('/result');
            },
            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(62)),
            child: Text(
              biText(
                en: 'End Discussion and Reveal',
                ne: 'छलफल समाप्त गरी नतिजा देखाउनुहोस्',
                language: state.language,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
