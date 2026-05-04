import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/nav_bar.dart';
import '../widgets/background.dart';
import '../widgets/filler_tile.dart';
import '../themes/app_colors.dart';
import '../models/connections_model.dart';
import '../models/user_model.dart';
import '../services/connections_service.dart';
import '../services/user_service.dart';

class ConnectionsPage extends StatelessWidget {
  const ConnectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final base = width < height ? width : height;

    final sizeboxSize = base * 0.05;
    final titleFontSize = base * 0.08;
    final hPadding = width * 0.01;
    final wPadding = height * 0.01;

    Color titleColor = isDark ? AppColors.titleDark : AppColors.titleLight;
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: sizeboxSize),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: wPadding),
              child: Text(
                "Connections",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
            ),

            Divider(
              color: isDark ? Colors.white : Colors.black54,
              thickness: 5,
              indent: 20,
              endIndent: 20,
            ),

            SizedBox(height: sizeboxSize),

            // Action tiles
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: FillerTile(
                          title: "Connection Requests",
                          onTap: () => Navigator.pushNamed(context, '/requestpage'),
                          inMiddle: false,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: sizeboxSize),
                  Row(
                    children: [
                      Expanded(
                        child: FillerTile(
                          title: "Connection Invites",
                          onTap: () => Navigator.pushNamed(context, '/invitepage'),
                          inMiddle: false,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: sizeboxSize),
                ],
              ),
            ),

            // Section label
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "My Connections",
                style: TextStyle(
                  fontSize: base * 0.05,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
            ),

            SizedBox(height: sizeboxSize * 0.5),

            // Connections list
            Expanded(
              child: StreamBuilder<List<Connection>>(
                stream: ConnectionsService.instance.getUserConnections(currentUserId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text('Failed to load connections'));
                  }

                  final connections = snapshot.data ?? [];

                  if (connections.isEmpty) {
                    return Center(
                      child: Text(
                        'No connections yet',
                        style: TextStyle(color: titleColor),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: connections.length,
                    itemBuilder: (context, index) {
                      final connection = connections[index];
                      final otherUserId = connection.participants
                          .firstWhere((id) => id != currentUserId,
                              orElse: () => '');

                      return _ConnectionTile(
                        key: ValueKey(connection.id),
                        connection: connection,
                        otherUserId: otherUserId,
                        currentUserId: currentUserId,
                        base: base,
                        isDark: isDark,
                        titleColor: titleColor,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: NavBar(currentIndex: 3),
      ),
    );
  }
}

class _ConnectionTile extends StatefulWidget {
  final Connection connection;
  final String otherUserId;
  final String currentUserId;
  final double base;
  final bool isDark;
  final Color titleColor;

  const _ConnectionTile({
    super.key,
    required this.connection,
    required this.otherUserId,
    required this.currentUserId,
    required this.base,
    required this.isDark,
    required this.titleColor,
  });

  @override
  State<_ConnectionTile> createState() => _ConnectionTileState();
}

class _ConnectionTileState extends State<_ConnectionTile> {
  AppUser? _user;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await UserService.instance.fetchUser(widget.otherUserId);
    if (mounted) {
      setState(() {
        _user = user;
        _loading = false;
      });
    }
  }

  Future<void> _removeConnection() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Connection'),
        content: Text(
          'Remove ${_user?.name ?? 'this user'} from your connections?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    await ConnectionsService.instance.removeConnection(widget.connection.id);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _loading
          ? null
          : () => Navigator.pushNamed(
                context,
                '/connectionprofile',
                arguments: widget.otherUserId,
              ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.homeTile,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: widget.base * 0.07,
              backgroundColor: widget.isDark
                  ? Colors.white24
                  : Colors.black12,
              backgroundImage: _user?.profilePictureUrl != null
                  ? NetworkImage(_user!.profilePictureUrl!)
                  : null,
              child: _loading
                  ? const CircularProgressIndicator(strokeWidth: 2)
                  : _user?.profilePictureUrl == null
                      ? Icon(
                          Icons.person,
                          size: widget.base * 0.07,
                          color: widget.isDark ? Colors.white54 : Colors.black45,
                        )
                      : null,
            ),

            const SizedBox(width: 16),

            // Name
            Expanded(
              child: Text(
                _loading
                    ? 'Loading...'
                    : _user?.name ?? 'Unknown User',
                style: TextStyle(
                  fontSize: widget.base * 0.05,
                  fontWeight: FontWeight.w600,
                  color: widget.titleColor,
                ),
              ),
            ),

            // Remove button
            IconButton(
              icon: const Icon(Icons.person_remove, color: Colors.red),
              onPressed: _removeConnection,
            ),
          ],
        ),
      ),
    );
  }
}