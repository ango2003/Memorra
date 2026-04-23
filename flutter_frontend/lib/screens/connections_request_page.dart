import 'package:flutter/material.dart';
import '../services/connections_service.dart';
import '../models/connections_request_model.dart';
import '../widgets/background.dart';
import '../widgets/nav_bar.dart';
import '../themes/app_colors.dart';

class ConnectionsRequestPage extends StatefulWidget {
  const ConnectionsRequestPage({super.key});

  @override
  State<ConnectionsRequestPage> createState() => ConnectionsRequestPageState();
}

class ConnectionsRequestPageState extends State<ConnectionsRequestPage> {
  late final Stream<List<ConnectionRequest>> _requestsStream;

  @override
  void initState() {
    super.initState();
    _requestsStream = ConnectionsService.instance
        .getReceivedConnectionRequests(ConnectionsService.instance.userId);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final base = size.width < size.height ? size.width : size.height;

    final sizeboxSize = base * 0.05;
    final titleFontSize = base * 0.08;

    Color titleColor = isDark ? AppColors.titleDark : AppColors.titleLight;

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(""),
        ),
        body: StreamBuilder<List<ConnectionRequest>>(
          stream: _requestsStream,
          builder: (context, snapshot) {
            // Loading state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // Error state
            if (snapshot.hasError) {
              return const Center(child: Text('Failed to load requests'));
            }

            final requests = snapshot.data ?? [];

            return Column(
              children: [
                SizedBox(height: sizeboxSize),

                Text(
                  "Connection Requests",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),

                Divider(
                  color: isDark ? Colors.white : Colors.black54,
                  thickness: 5,
                  indent: 20,
                  endIndent: 20,
                ),

                SizedBox(height: sizeboxSize),

                Expanded(
                  child: requests.isEmpty
                    ? const Center(child: Text("No requests"))
                    : ListView.builder(
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        final request = requests[index];
                        return Card(
                          color: isDark
                            ? Colors.white12
                            : Colors.white.withValues(alpha: 0.7),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            title: Text(
                              request.senderId,
                              style: TextStyle(
                                color: titleColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: const Text("Connection request"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.check),
                                  onPressed: () async {
                                    try {
                                      await ConnectionsService.instance
                                          .acceptConnectionRequest(request.requestId);
                                    } catch (e) {
                                      if (!mounted) return;
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Error: $e')),
                                      );
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () async {
                                    try {
                                      await ConnectionsService.instance
                                          .declineConnectionRequest(request.requestId);
                                    } catch (e) {
                                      if (!mounted) return;
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Error: $e')),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: NavBar(currentIndex: -1),
      ),
    );
  }
}