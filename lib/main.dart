import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto/data/services/service_api.dart';
import 'package:resto/providers/favorite_provider.dart';
import 'package:resto/providers/restaurant_provider.dart';
import './providers/theme_provider.dart';
import './providers/reminder_provider.dart';
import './data/services/notification_service.dart';
import './ui/restaurant_list_page.dart';
import 'common/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeProvider = ThemeProvider();
  final reminderProvider = ReminderProvider();
  final notificationService = NotificationService();

  await themeProvider.loadTheme();
  await reminderProvider.loadReminder();
  await notificationService.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeProvider),
        ChangeNotifierProvider(create: (_) => reminderProvider),
        ChangeNotifierProvider(
            create: (_) => RestaurantProvider(service: RestaurantService())),
        ChangeNotifierProvider(
          create: (_) => FavoriteProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Restaurant List',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          home: RestaurantListPage(),
        );
      },
    );
  }
}
