import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../state/game_controller.dart';
import '../state/game_state.dart';

class IdentityRevealScreen extends ConsumerWidget {
  const IdentityRevealScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);
    final turn = state.currentTurnView();

    if (turn == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('No reveal data. Start a game first.'),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      );
    }

    final isRevealVisible = turn.phase == RevealPhase.revealed;
    final progress = (state.currentRevealIndex + 1) / state.players.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('KURAUTE'),
        leading: IconButton(
          onPressed: () => context.go('/setup'),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.language)),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFEFDF1), Color(0xFFFAF9EE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(22, 18, 22, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'IDENTITY PASS PHASE',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                letterSpacing: 1,
                color: const Color(0xFF64655C),
              ),
            ),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Pass to',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 46,
                  height: 0.9,
                ),
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                turn.playerName,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 50,
                  height: 0.9,
                  color: const Color(0xFFCA0033),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: GestureDetector(
                onLongPressStart: (_) {
                  controller.beginHoldReveal();
                  controller.showIdentityWhileHolding();
                },
                onLongPressEnd: (_) {
                  controller.hideIdentityOnRelease();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isRevealVisible
                        ? const Color(0xFFFFD709)
                        : const Color(0xFFE9E9DA),
                    borderRadius: BorderRadius.circular(34),
                    border: Border.all(
                      color: isRevealVisible ? const Color(0x80776300) : Colors.transparent,
                      width: 3,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14600013),
                        blurRadius: 32,
                        offset: Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      child: _RevealCard(
                        key: ValueKey('${turn.playerName}-$isRevealVisible'),
                        turn: turn,
                        visible: isRevealVisible,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                controller.moveToNextPlayer();
                final latest = ref.read(gameControllerProvider);
                if (latest.isRevealComplete) {
                  controller.beginDiscussionPhase();
                  context.go('/round');
                }
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(62)),
              child: Text(
                state.currentRevealIndex >= state.players.length - 1
                    ? 'START DISCUSSION  →'
                    : 'Next Player',
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'PROGRESS',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    color: const Color(0xFF64655C),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      valueColor: const AlwaysStoppedAnimation(Color(0xFFCA0033)),
                      backgroundColor: const Color(0x66CA0033),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RevealCard extends StatelessWidget {
  const _RevealCard({super.key, required this.turn, required this.visible});

  final PlayerTurnView turn;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 128,
            height: 128,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFEFDF1),
            ),
            child: const Icon(Icons.fingerprint, size: 64, color: Color(0xFFCA0033)),
          ),
          const SizedBox(height: 18),
          Text(
            'HOLD TO REVEAL',
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w800,
              fontSize: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ensure no one else is looking.\nReveal your secret identity now.',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              color: const Color(0xFF64655C),
              fontSize: 16,
              height: 1.3,
            ),
          ),
        ],
      );
    }

    if (turn.role == PlayerRole.kuraute) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 128,
            height: 128,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFFFF757B), Color(0xFFCA0033)],
              ),
            ),
            child: const Icon(Icons.visibility, size: 58, color: Colors.white),
          ),
          const SizedBox(height: 18),
          Text(
            'YOU ARE THE KURAUTE',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w900,
              fontSize: 28,
              color: const Color(0xFF4E000E),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0x22CA0033),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Hint: ${turn.guptacharHint}',
              style: GoogleFonts.manrope(
                fontSize: 16,
                color: const Color(0xFFCA0033),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.visibility, size: 58, color: Color(0xFF776300)),
        const SizedBox(height: 16),
        Text(
          'SECRET WORD',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            color: const Color(0xFF64655C),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          turn.secretWord,
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w900,
            fontSize: 36,
            color: const Color(0xFF202118),
            height: 0.95,
          ),
        ),
      ],
    );
  }
}
