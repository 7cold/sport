import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sport/root.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  await Supabase.initialize(
    url: 'https://skyokfxlfsmmktogvbrc.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNreW9rZnhsZnNtbWt0b2d2YnJjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzU4NjMxMjIsImV4cCI6MjA1MTQzOTEyMn0.G8xwHxqVKo0VqASMlg7vXlxhJAZ2KiQtYU4QTZIKzn8',
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: GetMaterialApp(
        title: "Sport",
        opaqueRoute: true,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: const Locale('pt', 'BR'),
        supportedLocales: const [Locale('pt', 'BR')],
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        darkTheme: ThemeData(
          useMaterial3: true,
          dividerColor: Colors.transparent,
          brightness: Brightness.dark,
          colorSchemeSeed: Colors.blue,
        ),
        theme: ThemeData(
          textTheme: GoogleFonts.nunitoSansTextTheme(),
          dividerColor: Colors.transparent,
          brightness: Brightness.light,
          colorSchemeSeed: Colors.blue,
          useMaterial3: true,
        ),
        home: const Root(),
      ),
    );
  }
}
