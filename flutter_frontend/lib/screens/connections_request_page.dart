import 'package:flutter/material.dart';
import '../services/connections_service.dart';
import '../models/connections_request_model.dart';

class ConnectionsRequestPage extends StatefulWidget{
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
      final fetchRequests = await ConnectionsService.instance.getReceivedConnectionRequests(ConnectionsService.instance.userId);
      setState(() {
        requests = fetchRequests;
      });
    } catch (e) {
      throw('Failed to load requests: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text("Connection Requests")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Connection Requests")),
      body: requests.isEmpty
          ? const Center(child: Text('No requests'))
          : ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return ListTile(
                  title: Text(request.senderId),
                  subtitle: const Text('Connection request'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () async {
                          await ConnectionsService.instance.acceptConnectionRequest(request.requestId);
                          await loadRequests(); // refresh list
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () async {
                          await ConnectionsService.instance.declineConnectionRequest(request.requestId);
                          await loadRequests(); // refresh list
                        },
                      )
                    ]
                  )
                );
              }
            )
    );
  }
}