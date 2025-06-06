import 'package:flutter/material.dart';
import 'package:habitsync/core/color/colors.dart';
import 'package:habitsync/features/main/main_screen.dart';
import 'package:habitsync/services/app_preferences.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnBoardingPageData> _pages = [
    const _OnBoardingPageData(
      icon: Icons.calendar_month,
      title: 'Build Consistency',
      description: 'Easily track daily habits and monitor your progress.',
    ),
    const _OnBoardingPageData(
      icon: Icons.check_circle_outline,
      title: 'Stay Motivated',
      description: 'Achieve your goals with reminders and rewards.',
    ),
    const _OnBoardingPageData(
      icon: Icons.bar_chart,
      title: 'Track Progress',
      description: 'Visualize your achievements with detailed analytics.',
    ),
  ];

  void _completeOnboarding() async {
    await AppPreferences.setOnboardingComplete(true);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()));
  }

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _onPrevious() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void _onSkip() {
    _completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? AppColors.darkBackgroundGradient
              : AppColors.lightBackgroundGradient,
        ),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final page = _pages[index];
                return _OnBoardingPage(
                  icon: page.icon,
                  title: page.title,
                  description: page.description,
                );
              },
            ),
            Positioned(
              top: 24,
              right: 24,
              child: GestureDetector(
                onTap: _onSkip,
                child: Text(
                  'Skip',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 48,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  _PageIndicator(
                    currentPage: _currentPage,
                    pageCount: _pages.length,
                  ),
                  const SizedBox(height: 32),
                  _NavigationControls(
                    onNext: _onNext,
                    onPrevious: _onPrevious,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnBoardingPageData {
  final IconData icon;
  final String title;
  final String description;

  const _OnBoardingPageData({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class _OnBoardingPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _OnBoardingPage({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(48),
          child: Icon(
            icon,
            size: 120,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 48),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withOpacity(0.18)),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  const _PageIndicator({
    required this.currentPage,
    required this.pageCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: currentPage == index
                ? Colors.purpleAccent
                : Colors.white.withOpacity(0.4),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _NavigationControls extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const _NavigationControls({
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.white,
          onPressed: onPrevious,
          iconSize: 32,
          splashRadius: 24,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                minimumSize: const Size.fromHeight(56),
              ),
              onPressed: onNext,
              child: const Text(
                'Next',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios_rounded),
          color: Colors.white,
          onPressed: onNext,
          iconSize: 32,
          splashRadius: 24,
        ),
      ],
    );
  }
}
