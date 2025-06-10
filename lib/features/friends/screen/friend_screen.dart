import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:habitsync/core/color/colors.dart';
import 'package:habitsync/features/friends/widgets/friend_list_section.dart';
import 'package:habitsync/features/friends/widgets/friend_request_section.dart';
import 'package:habitsync/features/friends/widgets/search_friend_section.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({Key? key}) : super(key: key);

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  int _sectionIndex = 0; // 0: Friends, 1: Search, 2: Requests

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFriends = _sectionIndex == 0;
    final isSearch = _sectionIndex == 1;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        titleSpacing: 24,
        title: Text(
          isFriends
              ? 'Friends'
              : isSearch
                  ? 'Search Friends'
                  : 'Friend Requests',
          style: TextStyle(
            fontSize: isFriends ? 32 : 24,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
        actions: isFriends
            ? [
                IconButton(
                  icon: Icon(Icons.search, color: theme.iconTheme.color),
                  onPressed: () => setState(() => _sectionIndex = 1),
                  tooltip: 'Search Friends',
                ),
                Stack(
                  children: [
                    IconButton(
                      icon: Icon(Icons.person, color: theme.iconTheme.color),
                      onPressed: () => setState(() => _sectionIndex = 2),
                      tooltip: 'Friend Requests',
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: const Text(
                          '3',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
              ]
            : [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
                  onPressed: () => setState(() => _sectionIndex = 0),
                  tooltip: 'Back',
                ),
              ],
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _sectionIndex == 0
              ? const FriendsListSection()
              : _sectionIndex == 1
                  ? const SearchFriendsSection()
                  : const FriendRequestsSection(),
        ),
      ),
    );
  }
}
