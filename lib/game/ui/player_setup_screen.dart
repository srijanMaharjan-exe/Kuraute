import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/i18n/bi_text.dart';
import '../state/game_controller.dart';

class PlayerSetupScreen extends ConsumerStatefulWidget {
  const PlayerSetupScreen({super.key});

  @override
  ConsumerState<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends ConsumerState<PlayerSetupScreen> {
  late final List<TextEditingController> _controllers;
  final _countController = TextEditingController();
  int _playerCount = 5;

  @override
  void initState() {
    super.initState();
    final savedPlayers = ref.read(gameControllerProvider).players;
    final seed = savedPlayers.isEmpty
        ? List.generate(5, (i) => 'Player ${i + 1}')
        : savedPlayers;

    final count = (seed.length < 5 ? 5 : seed.length).clamp(3, 10);
    _playerCount = count.clamp(3, 10);
    _countController.text = _playerCount.toString();
    _controllers = List.generate(10, (i) {
      final text = i < seed.length ? seed[i] : 'Player ${i + 1}';
      return TextEditingController(text: text);
    });
  }

  void _syncCount(int next) {
    setState(() {
      _playerCount = next.clamp(3, 10);
      _countController.text = _playerCount.toString();
    });
  }

  List<String> _activeNames() {
    return _controllers
        .take(_playerCount)
        .map((e) => e.text.trim())
        .toList(growable: false);
  }

  bool _isDuplicateAt(int index, List<String> names) {
    final name = names[index];
    if (name.isEmpty) return false;
    return names.where((n) => n.toLowerCase() == name.toLowerCase()).length > 1;
  }

  @override
  void dispose() {
    _countController.dispose();
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);
    final names = _activeNames();
    final hasAnyEmpty = names.any((name) => name.isEmpty);
    final hasDuplicate = List.generate(names.length, (i) => _isDuplicateAt(i, names)).any((e) => e);

    return Scaffold(
      appBar: AppBar(
        title: const Text('KURAUTE'),
        leading: IconButton(
          onPressed: () => context.go('/'),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.language)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(22, 14, 22, 26),
        children: [
          Text(
            'Assemble Your Crew',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: 40,
              height: 0.95,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            biText(
              en: 'Prepare for the loop. Add your friends to start the reveal.',
              ne: 'पहिचान चरण सुरु गर्न साथीहरू थप्नुहोस्।',
              language: state.language,
            ),
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 16,
              color: const Color(0xFF64655C),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
            decoration: BoxDecoration(
              color: const Color(0xFFFBFAED),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              children: [
                Text(
                  'PARTY SIZE',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: const Color(0xFF64655C),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _StepperButton(
                      icon: Icons.remove,
                      onTap: () => _syncCount(_playerCount - 1),
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        SizedBox(
                          width: 92,
                          child: TextField(
                            controller: _countController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 40,
                              fontWeight: FontWeight.w800,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            onSubmitted: (value) {
                              final parsed = int.tryParse(value);
                              if (parsed != null) {
                                _syncCount(parsed);
                              } else {
                                _countController.text = _playerCount.toString();
                              }
                            },
                          ),
                        ),
                        Text(
                          'PLAYERS',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF776300),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    _StepperButton(
                      icon: Icons.add,
                      isPrimary: true,
                      onTap: () => _syncCount(_playerCount + 1),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  children: List.generate(10, (i) {
                    final active = i < _playerCount;
                    return Container(
                      width: active ? 26 : 9,
                      height: 8,
                      decoration: BoxDecoration(
                        color: active ? const Color(0xFFCA0033) : const Color(0xFFBABAaf),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Text(
                'PLAYER ROSTER',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                  color: const Color(0xFF64655C),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0x15565ABB),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '$_playerCount / 10 MAX',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF565ABB),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...List.generate(_playerCount, (index) {
            final duplicate = _isDuplicateAt(index, names);
            final empty = names[index].isEmpty;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: duplicate
                      ? const Color(0x14F95630)
                      : (empty ? const Color(0x10FF757B) : const Color(0xFFE9E9DA)),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: duplicate
                        ? const Color(0x55BE2D06)
                        : (empty ? const Color(0x55CA0033) : Colors.transparent),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 23,
                      backgroundColor: duplicate
                          ? const Color(0xFFF95630)
                          : (empty ? const Color(0xFFCA0033) : const Color(0x30CA0033)),
                      child: Text(
                        '${index + 1}',
                        style: GoogleFonts.plusJakartaSans(
                          color: duplicate || empty ? Colors.white : const Color(0xFFCA0033),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _controllers[index],
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter Name...',
                          hintStyle: GoogleFonts.manrope(
                            color: const Color(0xFF818177),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF202118),
                          height: 1,
                        ),
                      ),
                    ),
                    Icon(
                      duplicate
                          ? Icons.warning_rounded
                          : (empty ? Icons.circle_outlined : Icons.check_circle_rounded),
                      color: duplicate
                          ? const Color(0xFFBE2D06)
                          : (empty ? const Color(0xFF818177) : const Color(0xFF776300)),
                    ),
                  ],
                ),
              ),
            );
          }),
          if (_playerCount < 3)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0x14F95630),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                'At least 3 players are required.',
                style: GoogleFonts.manrope(
                  color: const Color(0xFF520C00),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: hasAnyEmpty || hasDuplicate
                ? null
                : () async {
              final players = _controllers
                  .take(_playerCount)
                  .map((e) => e.text)
                  .where((e) => e.trim().isNotEmpty)
                  .toList(growable: false);

              controller.setPlayers(players);

              try {
                await controller.startGame();
                if (context.mounted) {
                  context.go('/reveal');
                }
              } on StateError catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.message)),
                );
              }
            },
            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(62)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  biText(
                    en: 'BEGIN REVEAL LOOP',
                    ne: 'पहिचान चरण सुरु गर्नुहोस्',
                    language: state.language,
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.double_arrow_rounded),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Game rules will be assigned in the next step',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w700,
              color: const Color(0x99818177),
              fontSize: 11,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.onTap,
    this.isPrimary = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Ink(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isPrimary ? const Color(0xFFCA0033) : const Color(0xFFE9E9DA),
        ),
        child: Center(
          child: Text(
            icon == Icons.add ? '+' : '−',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: isPrimary ? Colors.white : const Color(0xFFCA0033),
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}
