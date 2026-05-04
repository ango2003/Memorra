import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import '../widgets/background.dart';
import '../widgets/nav_bar.dart';
import '../themes/app_colors.dart';

class ConnectionProfilePage extends StatefulWidget {
  final String userId;
  const ConnectionProfilePage({super.key, required this.userId});

  @override
  State<ConnectionProfilePage> createState() => _ConnectionProfilePageState();
}

class _ConnectionProfilePageState extends State<ConnectionProfilePage> {
  AppUser? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await UserService.instance.fetchUser(widget.userId);
    if (mounted) {
      setState(() {
        _user = user;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final base = size.width < size.height ? size.width : size.height;

    final sizeboxSize = base * 0.05;
    final titleFontSize = base * 0.08;
    final Color titleColor = isDark ? AppColors.titleDark : AppColors.titleLight;
    final Color cardColor = isDark ? Colors.white12 : Colors.white.withValues(alpha: 0.7);

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _user == null
                ? Center(
                    child: Text(
                      'User not found',
                      style: TextStyle(color: titleColor),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: sizeboxSize),

                        // Avatar
                        Center(
                          child: CircleAvatar(
                            radius: base * 0.15,
                            backgroundColor: isDark ? Colors.white24 : Colors.black12,
                            backgroundImage: _user!.profilePictureUrl != null
                                ? NetworkImage(_user!.profilePictureUrl!)
                                : null,
                            child: _user!.profilePictureUrl == null
                                ? Icon(
                                    Icons.person,
                                    size: base * 0.15,
                                    color: isDark ? Colors.white54 : Colors.black45,
                                  )
                                : null,
                          ),
                        ),

                        SizedBox(height: sizeboxSize),

                        // Name
                        Text(
                          _user!.name ?? 'Unknown User',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                            color: titleColor,
                          ),
                        ),

                        SizedBox(height: sizeboxSize),

                        Divider(
                          color: isDark ? Colors.white : Colors.black54,
                          thickness: 5,
                          indent: 20,
                          endIndent: 20,
                        ),

                        SizedBox(height: sizeboxSize),

                        // Interests section
                        Text(
                          'Interests',
                          style: TextStyle(
                            fontSize: base * 0.055,
                            fontWeight: FontWeight.bold,
                            color: titleColor,
                          ),
                        ),

                        SizedBox(height: sizeboxSize * 0.5),

                        _user!.interests.isEmpty
                            ? Text(
                                'No interests added yet',
                                style: TextStyle(
                                  color: titleColor.withValues(alpha: 0.6),
                                  fontSize: base * 0.04,
                                ),
                              )
                            : Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: _user!.interests.map((interest) {
                                  return Chip(
                                    label: Text(interest),
                                    backgroundColor: cardColor,
                                    labelStyle: TextStyle(
                                      color: titleColor,
                                      fontSize: base * 0.038,
                                    ),
                                  );
                                }).toList(),
                              ),

                        SizedBox(height: sizeboxSize),

                        Divider(
                          color: isDark ? Colors.white24 : Colors.black12,
                          thickness: 1,
                          indent: 20,
                          endIndent: 20,
                        ),

                        SizedBox(height: sizeboxSize),

                        // Wishlist section
                        Text(
                          'Wishlist',
                          style: TextStyle(
                            fontSize: base * 0.055,
                            fontWeight: FontWeight.bold,
                            color: titleColor,
                          ),
                        ),

                        SizedBox(height: sizeboxSize * 0.5),

                        _user!.wishlist.isEmpty
                            ? Text(
                                'No wishlist items yet',
                                style: TextStyle(
                                  color: titleColor.withValues(alpha: 0.6),
                                  fontSize: base * 0.04,
                                ),
                              )
                            : _buildWishlistByCategory(
                                _user!.wishlist,
                                cardColor,
                                titleColor,
                                base,
                                isDark,
                              ),

                        SizedBox(height: sizeboxSize * 3),
                      ],
                    ),
                  ),
        bottomNavigationBar: NavBar(currentIndex: -1),
      ),
    );
  }

  Widget _buildWishlistByCategory(
    List<WishlistItem> items,
    Color cardColor,
    Color titleColor,
    double base,
    bool isDark,
  ) {
    // Group items by category
    final Map<String, List<WishlistItem>> grouped = {};
    for (final item in items) {
      grouped.putIfAbsent(item.category, () => []).add(item);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: grouped.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category header
            Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 4),
              child: Text(
                entry.key,
                style: TextStyle(
                  fontSize: base * 0.045,
                  fontWeight: FontWeight.w600,
                  color: titleColor.withValues(alpha: 0.8),
                ),
              ),
            ),

            // Items in category
            ...entry.value.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.card_giftcard,
                      size: base * 0.05,
                      color: isDark ? Colors.white54 : Colors.black45,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.name,
                        style: TextStyle(
                          fontSize: base * 0.042,
                          color: titleColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),

            SizedBox(height: base * 0.03),
          ],
        );
      }).toList(),
    );
  }
}