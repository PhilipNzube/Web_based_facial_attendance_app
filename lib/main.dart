import 'package:facial_attendance/data/models/student_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart'; // ✅ for web
import 'package:flutter/foundation.dart';

import 'core/themes/app_theme.dart';
import 'presentation/controllers/attendance_controller.dart';
import 'presentation/controllers/home_controller.dart';
import 'presentation/controllers/manage_students_controller.dart';
import 'presentation/controllers/notification_controller.dart';
import 'presentation/controllers/online_webview_controller.dart';
import 'presentation/controllers/register_student_controller.dart';
import 'presentation/controllers/theme_controller.dart';
import 'presentation/controllers/navigation_controller.dart';
import 'presentation/screens/Auth/login/login_page.dart';
import 'presentation/screens/main_app/main_app.dart';
import 'data/database/general_db/db_helper.dart';
import 'presentation/controllers/auth_controller.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(StudentAdapter());

  print("Starting secure storage...");
  const storage = FlutterSecureStorage();
  final accessToken = await storage.read(key: 'passcodeNotActive');
  print("Secure storage read complete");

  print("Loading SharedPreferences...");
  final prefs = await SharedPreferences.getInstance();
  bool? isDarkMode = prefs.getBool('isDarkMode') ?? false;
  print("Prefs read complete");

  print("Opening database...");
  await Hive.openBox<Student>('students');
  print("Database open complete");

  final bool isLoggedIn = accessToken != null;
  print("Is logged in: $isLoggedIn");

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeController()),
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider(create: (_) => NavigationController()),
        ChangeNotifierProvider(create: (_) => NotificationController()),
        ChangeNotifierProvider(
          create: (context) {
            final syncingSchoolsProvider =
                Provider.of<NavigationController>(context, listen: false);
            return RegisterStudentController(context,
                syncingSchools: syncingSchoolsProvider.setSyncingSchools);
          },
        ),
        ChangeNotifierProvider(create: (_) => ManageStudentController()),
        ChangeNotifierProvider(create: (_) => OnlineWebViewController()),
        ChangeNotifierProvider(create: (_) => AttendanceController()),
      ],
      child: Consumer<ThemeController>(
        builder: (context, themeController, child) {
          return GlobalLoaderOverlay(
            child: MaterialApp(
              navigatorKey: navigatorKey,
              navigatorObservers: [routeObserver],
              title: 'Facial Attendance',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode:
                  themeController.isDarkMode ? ThemeMode.dark : ThemeMode.light,
              // home: isLoggedIn ? const MainApp() : LoginPage(),
              home: const MainApp(),
            ),
          );
        },
      ),
    );
  }
}
