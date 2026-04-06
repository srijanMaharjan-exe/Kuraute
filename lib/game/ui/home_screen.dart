import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/i18n/bi_text.dart';
import '../state/game_controller.dart';
import '../state/game_state.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  IconData _iconForPack(String id) {
    switch (id) {
      case 'food':
        return Icons.restaurant;
      case 'places':
        return Icons.landscape;
      case 'legends':
        return Icons.auto_awesome;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);
    final packs = ref.watch(availableWordPacksProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: null,
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('KURAUTE'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.language),
          ),
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            Positioned(
              top: 30,
              left: -60,
              child: Container(
                width: 180,
                height: 180,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0x10CA0033),
                ),
              ),
            ),
            Positioned(
              bottom: 180,
              right: -80,
              child: Container(
                width: 220,
                height: 220,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0x0D776300),
                ),
              ),
            ),
            ListView(
              padding: const EdgeInsets.fromLTRB(22, 8, 22, 28),
              children: [
                const SizedBox(height: 8),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD709),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'NEPAL-MODERN GAME',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.3,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'KURAUTE',
                  textAlign: TextAlign.center,
                  style: textTheme.displayLarge?.copyWith(
                    color: const Color(0xFFCA0033),
                    fontSize: 44,
                    height: 0.9,
                  ),
                ),
                Text(
                  'कुराउटे',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.mukta(
                    fontSize: 38,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF64655C),
                    height: 0.9,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '"Who\'s the gossip?"',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                    fontSize: 19,
                    fontStyle: FontStyle.italic,
                    color: const Color(0xFF64655C),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 34),
                Text(
                  'SELECT LANGUAGE',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                    color: const Color(0xFF64655C),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _LangPill(
                      label: 'English',
                      selected: state.language == AppLanguage.english,
                      onTap: () => controller.setLanguage(AppLanguage.english),
                    ),
                    _LangPill(
                      label: 'Nepali',
                      selected: state.language == AppLanguage.nepali,
                      onTap: () => controller.setLanguage(AppLanguage.nepali),
                    ),
                  ],
                ),
                const SizedBox(height: 26),
                Container(
                  padding: const EdgeInsets.fromLTRB(14, 18, 14, 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBFAED),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'ROUND TIMER',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.1,
                              color: const Color(0xFF64655C),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${state.roundDurationSeconds}s',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w800,
                              fontSize: 36,
                              color: const Color(0xFFCA0033),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _CircleIconButton(
                            icon: Icons.remove,
                            onTap: () => controller.setRoundDuration(state.roundDurationSeconds - 10),
                          ),
                          Expanded(
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                thumbColor: const Color(0xFFCA0033),
                                activeTrackColor: const Color(0xFFCA0033),
                                inactiveTrackColor: const Color(0xFFE9E9DA),
                              ),
                              child: Slider(
                                value: state.roundDurationSeconds.toDouble(),
                                min: 30,
                                max: 300,
                                divisions: 27,
                                onChanged: (value) => controller.setRoundDuration(value.round()),
                              ),
                            ),
                          ),
                          _CircleIconButton(
                            icon: Icons.add,
                            onTap: () => controller.setRoundDuration(state.roundDurationSeconds + 10),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            Text('30 SEC', style: GoogleFonts.manrope(fontWeight: FontWeight.w700, color: const Color(0xFF818177))),
                            const Spacer(),
                            Text('300 SEC', style: GoogleFonts.manrope(fontWeight: FontWeight.w700, color: const Color(0xFF818177))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),
                Text(
                  'SELECT CATEGORIES',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                    color: const Color(0xFF64655C),
                  ),
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  itemCount: packs.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.25,
                  ),
                  itemBuilder: (context, index) {
                    final pack = packs[index];
                    final selected = state.selectedPackIds.contains(pack.id);
                    return InkWell(
                      borderRadius: BorderRadius.circular(28),
                      onTap: () => controller.setSelectedPack(pack.id),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        decoration: BoxDecoration(
                          color: selected ? const Color(0xFFCA0033) : const Color(0xFFFBFAED),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: selected
                              ? const [
                                  BoxShadow(
                                    color: Color(0x23600013),
                                    blurRadius: 24,
                                    offset: Offset(0, 9),
                                  ),
                                ]
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _iconForPack(pack.id),
                              size: 29,
                              color: selected ? Colors.white : const Color(0xFF64655C),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              pack.nameEn,
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w800,
                                color: selected ? Colors.white : const Color(0xFF373830),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 28),
                SizedBox(
                  height: 64,
                  child: ElevatedButton(
                    onPressed: () => context.go('/setup'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          biText(
                            en: 'START GAME',
                            ne: 'खेल सुरु गर्नुहोस्',
                            language: state.language,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.play_arrow_rounded, size: 30),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 58,
                  child: OutlinedButton(
                    onPressed: () => context.go('/instructions'),
                    child: Text(
                      biText(
                        en: 'INSTRUCTIONS',
                        ne: 'निर्देशन',
                        language: state.language,
                      ),
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

class _LangPill extends StatelessWidget {
  const _LangPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? Colors.white : const Color(0xFFFBFAED),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: selected ? Border.all(color: const Color(0xFFCA0033), width: 2) : null,
          ),
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: selected ? const Color(0xFFCA0033) : const Color(0xFF373830),
            ),
          ),
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Ink(
        width: 52,
        height: 52,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFE9E9DA),
        ),
        child: Icon(icon, color: const Color(0xFFCA0033)),
      ),
    );
  }
}
