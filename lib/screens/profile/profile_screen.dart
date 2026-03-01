import 'package:dripzy/blocs/auth/auth_bloc.dart';
import 'package:dripzy/blocs/auth/auth_event.dart';
import 'package:dripzy/core/router/routes.dart';
import 'package:dripzy/models/user/user_model.dart';
import 'package:dripzy/providers/auth_provider.dart';
import 'package:dripzy/widgets/dialogs/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final user = context.read<AuthProvider>().user!;

    return Scaffold(
      backgroundColor: color.background,
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: color.primary,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        children: [
          _header(context, user),
          const SizedBox(height: 34),
          _section(context),
        ],
      ),
    );
  }

  // ---------------- HEADER ----------------

  Widget _header(BuildContext context, User user) {
    final color = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color.primary.withOpacity(0.35)),
          ),
          child: ClipOval(
            child: SizedBox(
              width: 90,
              height: 90,
              child: Image.network(
                user.profilePic,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) => Container(
                      color: color.surface,
                      alignment: Alignment.center,
                      child: Text(
                        user.username[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w600,
                          color: color.onSurface,
                        ),
                      ),
                    ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          user.username,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: color.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          user.email,
          style: TextStyle(
            fontSize: 13,
            color: color.onBackground.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  // ---------------- SECTION LIST ----------------

  Widget _section(BuildContext context) {
    return Column(
      children: [
        _tile(context, Icons.favorite_border, "Wishlist", () {
          context.push(AppRoutes.wishlist);
        }),
        _tile(context, Icons.inventory_2_outlined, "Orders", () {}),
        _tile(context, Icons.location_on_outlined, "Addresses", () {
          context.push(AppRoutes.address);
        }),
        // _tile(context, Icons.support_agent_outlined, "Help & Support", () {}),
        const SizedBox(height: 8),
        _tile(context, Icons.logout, "Logout", () {
          showLogoutDialog(
            context,
            onLogoutClick: () {
              context.read<AuthBloc>().add(LogoutRequested());
            },
            onCancelClick: () => context.pop(),
          );
        }, danger: true),
      ],
    );
  }

  // ---------------- TILE ----------------

  Widget _tile(
    BuildContext context,
    IconData icon,
    String text,
    VoidCallback onTap, {
    bool danger = false,
  }) {
    final color = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: color.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: color.outlineVariant.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: danger ? color.error : color.primary,
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: danger ? color.error : color.onBackground,
                    ),
                  ),
                ),

                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: color.onBackground.withOpacity(0.35),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
