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
  List<ConnectionRequest> requests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRequests();
  }

  Future<void> loadRequests() async {
    setState(() => isLoading = true);
    try {
      final fetchRequests = await ConnectionsService.instance
          .getReceivedConnectionRequests(
              ConnectionsService.instance.userId);
      setState(() {
        requests = fetchRequests;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load requests")),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
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
        body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
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
                                  await ConnectionsService.instance
                                    .acceptConnectionRequest(
                                      request.requestId
                                    );
                                  await loadRequests();
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () async {
                                  await ConnectionsService.instance
                                    .declineConnectionRequest(
                                      request.requestId);
                                  await loadRequests();
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
          ),
        bottomNavigationBar: NavBar(currentIndex: -1),
      ),
    );
  }
}
