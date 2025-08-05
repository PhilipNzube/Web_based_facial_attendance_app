import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/custom_background.dart';
import '../../../core/widgets/custom_gap.dart';
import '../../../core/widgets/logout_dialog.dart';
import '../../../core/widgets/stat_card.dart';
import '../../controllers/home_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Provider.of<HomeController>(context);

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Text(
              'Home',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 22.0,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: homeController.refreshData,
            ),
            Gap(
              4,
              isHorizontal: true,
            ),
            GestureDetector(
              onTap: () => showLogoutDialog(context, homeController.logout),
              child: Row(
                children: [
                  const IconButton(
                    icon: const Icon(Icons.exit_to_app),
                    onPressed: null,
                  ),
                  Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          const Background(), // Use the background widget
          RefreshIndicator(
            onRefresh: homeController.refreshData,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Gap(10),
                  ...homeController.studentStats.entries.map(
                    (entry) =>
                        StatCard(title: entry.key, futureValue: entry.value),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
