import 'package:flutter/material.dart';
import '../../../core/services/connectivity_service.dart';
import '../../../core/widgets/custom_back_handler.dart';
import '../../../core/widgets/custom_bottom_nav.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../controllers/navigation_controller.dart';
import '../home/home_page.dart';
import '../manage_students/manage_students.dart';
import '../online_webview/online_webview.dart';
import '../attendance/attendance.dart';
import '../register_student/register_student.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';

class MainApp extends StatefulWidget {
  const MainApp({
    super.key,
  });

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with TickerProviderStateMixin {
  final List<bool> _hasNotification = [false, false, false, false];
  DateTime? currentBackPressTime;
  bool isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ConnectivityService _connectivityService = ConnectivityService();

  @override
  void initState() {
    super.initState();
    _connectivityService.startMonitoring((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        CustomSnackbar.show(context, "No Internet Connection", isError: true);
      }
    });
  }

  @override
  void dispose() {
    _connectivityService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navController = Provider.of<NavigationController>(context);

    return CustomBackHandler(
      child: Scaffold(
        extendBody: true,
        body: SafeArea(
          child: IndexedStack(
            index: navController.selectedIndex,
            children: [
              const HomePage(),
              RegisterStudent(syncingSchools: navController.setSyncingSchools),
              const ManageStudents(),
              AttendancePage(),
              //const OnlineWebview(),
            ],
          ),
        ),
        bottomNavigationBar: const CustomBottomNav(),
      ),
    );
  }
}
