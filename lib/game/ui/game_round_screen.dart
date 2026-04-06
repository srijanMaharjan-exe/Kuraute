import 'dart:async';
import 'dart:math' as math;

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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);
    final ratio = state.remainingSeconds / state.roundDurationSeconds;
    final total = state.remainingSeconds;
    final mm = (total ~/ 60).toString().padLeft(2, '0');
    final ss = (total % 60).toString().padLeft(2, '0');

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
                      value: ratio,
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
                        '$mm:$ss',
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
          ),
          const SizedBox(height: 16),
          GridView.builder(
            itemCount: math.min(state.players.length, 4),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final name = state.players[index];
              final highlighted = index == (state.kurauteIndex ?? 0);
              return Container(
                decoration: BoxDecoration(
                  color: highlighted ? const Color(0x26A6A9FF) : const Color(0xFFFBFAED),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundColor: highlighted ? const Color(0xFFA6A9FF) : const Color(0xFFFFD709),
                      child: Icon(
                        Icons.face,
                        color: highlighted ? const Color(0xFF2A2B8D) : const Color(0xFF5B4B00),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      name,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    if (highlighted)
                      Text(
                        'SUSPICIOUS?',
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF565ABB),
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0x99E9E9DA),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb, color: Color(0xFFCA0033)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Pro Tip: watch for players who hesitate while explaining clues.',
                    style: GoogleFonts.manrope(
                      color: const Color(0xFF64655C),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
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
