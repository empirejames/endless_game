import 'package:endless_game/app_lifecycle/app_lifecycle.dart';
import 'package:endless_game/player_progress/player_progress.dart';
import 'package:endless_game/style/palette.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:provider/provider.dart';

import 'audio/audio_controller.dart';
import 'game_screen.dart';
import 'levels.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.setPortrait();
  await Flame.device.fullScreen();

  final GameLevel level = gameLevels[0];
  runApp(
    AppLifecycleObserver(
      child: MultiProvider(
        providers: [
          Provider(create: (context) => Palette()),
          ChangeNotifierProvider(create: (context) => PlayerProgress()),
          ProxyProvider<AppLifecycleStateNotifier, AudioController>(
            lazy: false,
            create: (context) => AudioController(),
            update: (context, lifecycleNotifier, audio) {
              audio!.attachDependencies(lifecycleNotifier);
              return audio;
            },
            dispose: (context, audio) => audio.dispose(),
          ),
        ],
        child: Builder(builder: (context) {
          final palette = context.watch<Palette>();
          return MaterialApp(
            theme: flutterNesTheme().copyWith(
              colorScheme: ColorScheme.fromSeed(
                seedColor: palette.seed.color,
                background: palette.backgroundMain.color,
              ),
              textTheme: GoogleFonts.pressStart2pTextTheme().apply(
                bodyColor: palette.text.color,
                displayColor: palette.text.color,
              ),
            ),
            initialRoute: '/',
            routes: {
              '/': (_) => GameScreen(level: level),
            },
          );
        }),
      ),
    ),
  );
}
