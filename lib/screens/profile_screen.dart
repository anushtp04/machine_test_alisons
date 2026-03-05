import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_test_alisons/blocs/auth/auth_bloc.dart';
import 'package:machine_test_alisons/blocs/auth/auth_event.dart';
import 'package:machine_test_alisons/blocs/profile/profile_bloc.dart';
import 'package:machine_test_alisons/blocs/profile/profile_event.dart';
import 'package:machine_test_alisons/blocs/profile/profile_state.dart';
import 'package:machine_test_alisons/utils/constants/app_colors.dart';
import 'package:machine_test_alisons/utils/constants/app_typography.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadProfile());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text(
          'Profile',
          style: AppTypography.textXl.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          String name = 'Guest';
          String email = '';

          if (state is ProfileLoaded) {
            name = state.name;
            email = state.email;
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 20),
              // Avatar
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  name,
                  style: AppTypography.text2xl.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  email,
                  style: AppTypography.textSm.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Menu items
              _buildMenuItem(Icons.shopping_bag_outlined, 'My Orders'),
              _buildMenuItem(Icons.favorite_border, 'Wishlist'),
              _buildMenuItem(Icons.location_on_outlined, 'Delivery Address'),
              _buildMenuItem(Icons.payment, 'Payment Methods'),
              _buildMenuItem(Icons.settings_outlined, 'Settings'),
              _buildMenuItem(Icons.help_outline, 'Help & Support'),

              const SizedBox(height: 24),

              // Logout button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.read<AuthBloc>().add(LogoutRequested());
                  },
                  icon: const Icon(Icons.logout, color: AppColors.error),
                  label: Text(
                    'Logout',
                    style: AppTypography.textMd.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.error),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(
          title,
          style: AppTypography.textMd.copyWith(color: AppColors.textPrimary),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.textSecondary,
        ),
        onTap: () {},
      ),
    );
  }
}
