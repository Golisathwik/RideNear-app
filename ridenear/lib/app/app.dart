import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../providers/app_provider.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/explore/screens/main_layout.dart';

class RideNearApp extends StatelessWidget {
  const RideNearApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: Consumer<AppProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            title: 'RideNear',
            theme: AppTheme.lightTheme,
            debugShowCheckedModeBanner: false,
            home: provider.isAuthenticated ? const MainLayout() : const LoginScreen(),
          );
        },
      ),
    );
  }
}
