import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitsync/features/auth/controller/auth_controller.dart';
import 'package:habitsync/features/profile/controller/profile_controller.dart';
import 'package:habitsync/features/profile/widgets/action_button.dart';
import 'package:habitsync/features/profile/widgets/friends_tab.dart';
import 'package:habitsync/features/profile/widgets/habit_card_tab.dart';
import 'package:habitsync/features/profile/widgets/stats_card.dart';
import 'package:habitsync/features/profile/widgets/user_qr_widget.dart';
import 'package:habitsync/features/settings/screen/settings_screen.dart';
import 'package:habitsync/services/profile_cache_service.dart';
import 'package:habitsync/features/auth/domain/user_model.dart';
import 'package:habitsync/services/image_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:habitsync/features/habits/controller/habit_controller.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final VoidCallback? onAddHabitTap;
  final VoidCallback? onAddFriendTap;
  const ProfileScreen({super.key, this.onAddHabitTap, this.onAddFriendTap});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  User? _user;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await _refreshProfile();
      await _fetchHabits();
    });
  }

  Future<void> _fetchHabits() async {
    if (_user != null) {
      await ref
          .read(habitControllerProvider.notifier)
          .getHabitsByOwner(_user!.id);
    }
  }

  Future<void> _refreshProfile() async {
    ref.read(authControllerProvider.notifier).refreshProfile().then((_) {
      _loadProfile();
    });
  }

  Future<void> _loadProfile() async {
    final user = await ProfileCacheService.getCachedUserProfile();
    setState(() {
      _user = user;
    });
  }

  Future<void> _imagePicker() async {
    if (_user == null) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Change Profile Picture',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _handleImagePickAndUpdate(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _handleImagePickAndUpdate(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleImagePickAndUpdate(ImageSource source) async {
    final imageService = ImageService();
    final imageUrl = await imageService.pickAndUploadImage(source);
    print('Image URL: $imageUrl');
    if (imageUrl != null && _user != null) {
      final updatedUser = _user!.copyWith(avatar: imageUrl);
      print('Updating user with: ${updatedUser.toJson()}');
      try {
        await ref
            .read(profileControllerProvider.notifier)
            .updateProfile(updatedUser);
        print('Profile update successful');
        await ProfileCacheService.cacheUserProfile(updatedUser);
        setState(() {
          _user = updatedUser;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated!')),
        );
      } catch (e, st) {
        print('Error updating profile: $e\n$st');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile update failed!')),
        );
      }
    } else {
      print('Image upload failed or user is null');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image upload failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;
    final subTextColor = theme.textTheme.bodyMedium?.color ?? Colors.white70;
    final cardColor = theme.cardColor;

    final habitsAsync = ref.watch(habitControllerProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              const SizedBox(height: 8),
              // Settings icon at the top right of the body
              Padding(
                padding: const EdgeInsets.only(top: 8, right: 16),
                child: Row(
                  children: [
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.settings, color: textColor),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SettingsScreen()));
                      },
                    ),
                  ],
                ),
              ),
              // Avatar
              InkWell(
                onTap: () => _imagePicker(),
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      backgroundColor: Colors.transparent,
                      child: CircleAvatar(
                        radius: 150,
                        backgroundImage: CachedNetworkImageProvider(
                          _user?.avatar.isNotEmpty == true
                              ? _user!.avatar
                              : 'https://i.pravatar.cc/150?img=3',
                        ),
                      ),
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 48,
                  backgroundImage: CachedNetworkImageProvider(
                    _user?.avatar.isNotEmpty == true
                        ? _user!.avatar
                        : 'https://i.pravatar.cc/150?img=3',
                  ),
                  backgroundColor: cardColor,
                ),
              ),
              const SizedBox(height: 12),
              // Name
              Text(
                _user?.name ?? 'Habit Sync User',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              // Username
              Text(
                '@${_user?.username ?? 'habit_sync_user'}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: subTextColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              // Badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _user?.bio ?? 'Habit Master',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: textColor,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Streak & Check-ins
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StatCard(
                    icon: Icons.local_fire_department,
                    label: 'Current Streak',
                    value: _user?.streak.toString() ?? '0',
                    color1: Colors.blueAccent,
                    color2: Colors.purpleAccent,
                  ),
                  const SizedBox(width: 16),
                  const StatCard(
                    icon: Icons.check_circle,
                    label: 'Weekly Check-ins',
                    value: '85%',
                    color1: Colors.pinkAccent,
                    color2: Colors.purpleAccent,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Action Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Will keep it commented for now
                      // ActionButton(
                      //     label: 'Share Profile',
                      //     icon: Icons.share,
                      //     onTap: () {}),
                      // const SizedBox(width: 8),
                      ActionButton(
                          label: 'Sync Habits', icon: Icons.sync, onTap: () {}),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Tabs
              TabBar(
                indicatorColor: theme.colorScheme.secondary,
                labelColor: textColor,
                unselectedLabelColor: subTextColor,
                tabs: const [
                  Tab(text: 'My Habits'),
                  Tab(text: 'Friends'),
                  // Tab(text: 'Achievements'),
                ],
              ),
              SizedBox(
                height: 400, // Adjust as needed
                child: TabBarView(
                  children: [
                    habitsAsync.when(
                      data: (habits) => HabitsTab(
                        habits: habits,
                        onAddHabit: widget.onAddHabitTap,
                      ),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, st) => Center(child: Text('Error: $e')),
                    ),
                    FriendsTab(
                      onAddFriend: widget.onAddFriendTap,
                    ),
                    // const AchievementsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('My QR Code'),
                content: SizedBox(
                  width: 220, // Set a fixed size for the QR code
                  height: 220,
                  child: UserQrCodeWidget(username: _user?.username ?? ''),
                ),
              ),
            );
          },
          child: const Icon(Icons.qr_code),
        ),
      ),
    );
  }
}
