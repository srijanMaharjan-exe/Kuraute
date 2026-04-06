import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'game/ui/game_round_screen.dart';
import 'game/ui/home_screen.dart';
import 'game/ui/identity_reveal_screen.dart';
import 'game/ui/instructions_screen.dart';
import 'game/ui/player_setup_screen.dart';
import 'game/ui/result_screen.dart';

class KurauteApp extends StatelessWidget {
  const KurauteApp({super.key});

  static const _primary = Color(0xFFCA0033);
  static const _secondary = Color(0xFF776300);
  static const _surface = Color(0xFFFEFDF1);
  static const _surfaceLow = Color(0xFFFBFAED);
  static const _surfaceHigh = Color(0xFFE9E9DA);
  static const _tertiary = Color(0xFF565ABB);

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/instructions',
          builder: (context, state) => const InstructionsScreen(),
        ),
        GoRoute(
          path: '/setup',
          builder: (context, state) => const PlayerSetupScreen(),
        ),
        GoRoute(
          path: '/reveal',
          builder: (context, state) => const IdentityRevealScreen(),
        ),
        GoRoute(
          path: '/round',
          builder: (context, state) => const GameRoundScreen(),
        ),
        GoRoute(
          path: '/result',
          builder: (context, state) => const ResultScreen(),
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Kuraute',
      theme: ThemeData(
        scaffoldBackgroundColor: _surface,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        colorScheme: const ColorScheme.light(
          primary: _primary,
          secondary: _secondary,
          tertiary: _tertiary,
          surface: _surface,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Color(0xFF373830),
        ),
        textTheme: GoogleFonts.manropeTextTheme().copyWith(
          displayLarge: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            letterSpacing: -1.2,
            color: const Color(0xFF373830),
          ),
          headlineSmall: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
            color: const Color(0xFF373830),
          ),
          titleLarge: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF373830),
          ),
          titleMedium: GoogleFonts.manrope(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF64655C),
          ),
          bodyMedium: GoogleFonts.manrope(
            color: const Color(0xFF373830),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: _surface,
          foregroundColor: _primary,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.plusJakartaSans(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: _primary,
            letterSpacing: -0.2,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            textStyle: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
            shadowColor: const Color(0x14600013),
            elevation: 6,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: _primary,
            side: const BorderSide(color: Color(0x40CA0033)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
            textStyle: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
        chipTheme: ChipThemeData(
          selectedColor: _primary,
          backgroundColor: _surfaceLow,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          labelStyle: GoogleFonts.manrope(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF373830),
          ),
        ),
        cardTheme: CardThemeData(
          color: _surfaceHigh,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
