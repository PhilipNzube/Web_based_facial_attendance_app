import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presentation/controllers/navigation_controller.dart';
import '../../presentation/controllers/notification_controller.dart';

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final navController = Provider.of<NavigationController>(context);
    final notificationController = Provider.of<NotificationController>(context);

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            spreadRadius: 5,
            blurRadius: 10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        child: BottomNavigationBar(
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          items: [
            _buildNavItem(
                Icons.home, "Home", notificationController.hasNotification(0)),
            _buildNavItem(Icons.person_add, "Register",
                notificationController.hasNotification(1)),
            _buildNavItem(Icons.people, "Students",
                notificationController.hasNotification(2)),
            _buildNavItem(Icons.table_chart, "Attendance",
                notificationController.hasNotification(3)),
          ],
          currentIndex: navController.selectedIndex,
          selectedItemColor: const Color(0xFF637725),
          unselectedItemColor: Colors.grey,
          onTap: navController.changeTab,
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
      IconData icon, String label, bool hasNotification) {
    return BottomNavigationBarItem(
      icon: Stack(
        alignment: Alignment.center,
        children: [
          Icon(icon),
          if (hasNotification)
            Positioned(
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                width: 8,
                height: 8,
              ),
            ),
        ],
      ),
      label: label,
    );
  }
}
