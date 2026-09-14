import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/constants/app_colors.dart';
import 'core/utils/video_web_registrar.dart';
import 'features/portfolio/screens/portfolio_screen.dart';

void main() async {
  ensureVideoPlayerInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Env file not found, using fallback configuration");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fatin Istiak Polok | Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.vsCodeStatusBar,
          brightness: Brightness.dark,
          surface: AppColors.vsCodeEditor,
        ),
        textTheme: GoogleFonts.firaCodeTextTheme(ThemeData.dark().textTheme),
        scaffoldBackgroundColor: AppColors.vsCodeEditor,
      ),
      home: const PortfolioScreen(),
    );
  }
}
