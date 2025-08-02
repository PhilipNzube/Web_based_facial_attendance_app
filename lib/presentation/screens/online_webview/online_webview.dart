import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/widgets/custom_back_handler.dart';
import '../../../core/widgets/custom_gap.dart';
import '../../controllers/online_webview_controller.dart';

class OnlineWebview extends StatefulWidget {
  const OnlineWebview({super.key});

  @override
  OnlineWebviewState createState() => OnlineWebviewState();
}

class OnlineWebviewState extends State<OnlineWebview> {
  DateTime? currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    final onlineWebViewController =
        Provider.of<OnlineWebViewController>(context);
    return FutureBuilder<WebViewController>(
      future: onlineWebViewController.controllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFF637725)));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final controller = snapshot.data!;
          return CustomBackHandler(
            child: Scaffold(
              body: Stack(
                children: [
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            const Spacer(),
                            if (onlineWebViewController.isRefreshing)
                              const Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.black))
                            else
                              IconButton(
                                icon: const Icon(Icons.refresh),
                                onPressed: () {
                                  onlineWebViewController.refreshData(context);
                                },
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: onlineWebViewController.isNoInternet
                            ? Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: Colors.white,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.error,
                                          size: 50, color: Colors.red),
                                      const Gap(20),
                                      const Text(
                                        'No internet connection.',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      const Gap(20),
                                      ElevatedButton(
                                        onPressed: onlineWebViewController
                                            .checkInternetConnection,
                                        child: const Text('Retry'),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : WebViewWidget(controller: controller),
                      ),
                    ],
                  ),
                  if (onlineWebViewController.isRefreshing)
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.white.withOpacity(0.5),
                      child: const Center(
                        child:
                            CircularProgressIndicator(color: Color(0xFF637725)),
                      ),
                    ),
                  if (onlineWebViewController.isError)
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.white.withOpacity(0.5),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error,
                                size: 50, color: Colors.red),
                            const Gap(20),
                            const Text(
                              'An error occurred while loading the page.',
                              style: TextStyle(fontSize: 18),
                            ),
                            const Gap(20),
                            ElevatedButton(
                              onPressed: () {
                                onlineWebViewController.refreshData(context);
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
