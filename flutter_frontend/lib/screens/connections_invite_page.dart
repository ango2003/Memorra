import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import '../services/connections_service.dart';

class ConnectionsInvitePage extends StatefulWidget{
  const ConnectionsInvitePage({super.key});

  @override
  State<ConnectionsInvitePage> createState() => ConnectionsInvitePageState();
}

class ConnectionsInvitePageState extends State<ConnectionsInvitePage> {
  @override
  void initState() {
    super.initState();
    generateInvite();
  }
  
  String? inviteUrl;
  bool isLoading = false;

  Future<void> generateInvite() async {
  setState(() => isLoading = true);

  try {
    final token = await ConnectionsService.instance.createInvite(Duration(hours: 24));
    final url = 'memorra://invite?token=$token';
    setState(() { 
      inviteUrl = url; 
      isLoading = false;
    });
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate invite')),
      );
    setState(() => isLoading = false);
    }
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text("Connection Invites")),
    body: 
      Center(
        child: isLoading
    ? const CircularProgressIndicator()
    : inviteUrl != null
      ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
          children: [
            QrImageView(
              data: inviteUrl!,
              size: 200,
            ),
            const SizedBox(height: 20),
            Text(inviteUrl!),
            const SizedBox(height: 20),
              ElevatedButton(
                onPressed: generateInvite,
                child: const Text("Generate New Invite"),
              ),
            const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: inviteUrl!));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invite URL copied to clipboard')),
                  );
                },
                child: const Text("Copy Invite URL"),
              ),
            ],
          )
        : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Failed to generate invite."),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: generateInvite,
                child: const Text("Retry"),
              ),
            ],
          ),
      ),
    );
  }
}
