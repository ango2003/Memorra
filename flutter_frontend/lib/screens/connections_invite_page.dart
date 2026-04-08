import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import '../services/invite_service.dart';
import '../widgets/background.dart';
import '../widgets/nav_bar.dart';
import '../themes/app_colors.dart';

class ConnectionsInvitePage extends StatefulWidget {
  const ConnectionsInvitePage({super.key});

  @override
  State<ConnectionsInvitePage> createState() => ConnectionsInvitePageState();
}

class ConnectionsInvitePageState extends State<ConnectionsInvitePage> {
  String? inviteUrl;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    generateInvite();
  }

  Future<void> generateInvite() async {
    setState(() => isLoading = true);

    try {
      final url = await InviteService.instance.createInviteURL();
      setState(() {
        inviteUrl = url;
        isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to generate invite')),
        );
      }
      setState(() => isLoading = false);
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: sizeboxSize),

              Text(
                "Connection Invite",
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

              Center(
                child: isLoading
                  ? const CircularProgressIndicator()
                  : inviteUrl != null
                    ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        QrImageView(
                          data: inviteUrl!,
                          size: 200,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          inviteUrl!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: base * 0.045,
                            color: titleColor,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: generateInvite,
                          child: const Text("Generate New Invite"),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: inviteUrl!)
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Invite URL copied to clipboard')
                                ),
                              );
                            },
                            child: const Text("Copy Invite URL"),
                          ),
                        ],
                      )
                      : Column(
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
            ],
          ),
        ),
        bottomNavigationBar: NavBar(currentIndex: -1),
      ),
    );
  }
}
