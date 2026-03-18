import 'package:flutter/material.dart';
import '../services/connections_service.dart';

// ChatGPT TEST PAGE FOR CONNECTIONS SERVICE - NOT FOR PRODUCTION USE
class ConnectionsTestPage extends StatefulWidget {
  const ConnectionsTestPage({super.key});

  @override
  State<ConnectionsTestPage> createState() => _ConnectionsTestPageState();
}

class _ConnectionsTestPageState extends State<ConnectionsTestPage> {

  final TextEditingController inviteController = TextEditingController();
  final TextEditingController requestController = TextEditingController();

  String generatedToken = "";

  final service = ConnectionsService.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Connections Test")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// CREATE INVITE
            const Text("Create Invite"),

            ElevatedButton(
              onPressed: () async {
                final token = await service.createInvite(const Duration(hours: 1));
                setState(() {
                  generatedToken = token;
                });
              },
              child: const Text("Generate Invite"),
            ),

            Text("Token: $generatedToken"),

            const SizedBox(height: 20),

            /// REDEEM INVITE
            TextField(
              controller: inviteController,
              decoration: const InputDecoration(
                labelText: "Enter Invite Token",
              ),
            ),

            ElevatedButton(
              onPressed: () async {
                await service.redeemInvite(inviteController.text);
              },
              child: const Text("Redeem Invite"),
            ),

            const Divider(),

            /// SEND REQUEST
            const Text("Send Connection Request"),

            TextField(
              controller: requestController,
              decoration: const InputDecoration(
                labelText: "Receiver UID",
              ),
            ),

            ElevatedButton(
              onPressed: () async {
                await service.sendConnectionRequest(requestController.text);
              },
              child: const Text("Send Request"),
            ),

            const Divider(),

            /// CONNECTION LIST
            const Text("Connections"),

            StreamBuilder(
              stream: service.getUserConnections(service.userId),
              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                final connections = snapshot.data!;

                return Column(
                  children: connections.map((connection) {
                    return ListTile(
                      title: Text(connection.participants.join(", ")),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          service.removeConnection(connection.id);
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}