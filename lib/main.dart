import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:home_widget/home_widget.dart';
import 'providers/app_provider.dart';
import 'screens/dashboard_screen.dart';

// Called when the widget's "Mark Paid" button is tapped
@pragma('vm:entry-point')
Future<void> backgroundCallback(Uri? uri) async {
  if (uri?.host == 'markPaid') {
    final provider = AppProvider();
    await provider.loadData();
    await provider.markPaid();
  } else if (uri?.host == 'nextGroup') {
    final provider = AppProvider();
    await provider.loadData();
    await provider.nextGroup();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HomeWidget.registerBackgroundCallback(backgroundCallback);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()..loadData()),
      ],
      child: const WaterTrackerApp(),
    ),
  );
}

class WaterTrackerApp extends StatelessWidget {
  const WaterTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Water Tracker',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF101415),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00F2FF),
          onPrimary: Color(0xFF00363A),
          primaryContainer: Color(0xFF006A71),
          secondary: Color(0xFFADC6FF),
          onSecondary: Color(0xFF002E69),
          secondaryContainer: Color(0xFF4B8EFF),
          surface: Color(0xFF101415),
          onSurface: Color(0xFFE0E3E5),
          error: Color(0xFFFFB4AB),
          onError: Color(0xFF690005),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        fontFamily: 'Roboto', // Fallback sans-serif
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF101415),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00F2FF),
          onPrimary: Color(0xFF00363A),
          primaryContainer: Color(0xFF006A71),
          secondary: Color(0xFFADC6FF),
          onSecondary: Color(0xFF002E69),
          secondaryContainer: Color(0xFF4B8EFF),
          surface: Color(0xFF101415),
          onSurface: Color(0xFFE0E3E5),
          error: Color(0xFFFFB4AB),
          onError: Color(0xFF690005),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        fontFamily: 'Roboto', // Fallback sans-serif
      ),
      themeMode: ThemeMode.dark, // Force dark mode for Glass UI
      home: const DashboardScreen(),
    );
  }
}
