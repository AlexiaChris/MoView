import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/auth_page.dart';
import 'pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MoViewApp());
}

class MoViewApp extends StatelessWidget {
  const MoViewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoView',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFA600FF),
          surface: Colors.black,
          background: Colors.black,
        ),
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'Alata', 
      ),
      home: const HomePage(),
    );
  }
}
