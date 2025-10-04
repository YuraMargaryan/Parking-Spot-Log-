import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:parking_spot_log/core/shared/onboarding_service.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

@RoutePage()
class OnboardingScreen extends StatefulWidget {
  final VoidCallback? onCompleted;
  const OnboardingScreen({super.key, this.onCompleted});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  Future<void> _finishOnboarding() async {
    final success = await OnboardingService.setOnboardingCompleted();
    
    if (success && mounted && widget.onCompleted != null) {
      widget.onCompleted!();
    } else if (!success && mounted) {
      // Show error only if saving failed
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Error'),
          content: const Text('Error saving settings'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGrey6,
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                CupertinoColors.systemBackground,
                CupertinoColors.systemGrey6,
              ],
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _controller,
                  onPageChanged: (index) {
                    setState(() => isLastPage = index == 3);
                  },
                  children: [
                    buildPage(
                      title: "Welcome to Parking Spot Log 🚗",
                      subtitle:
                          "Convenient app for tracking parking spots. Never lose your parking space again!",
                      icon: CupertinoIcons.car_fill,
                    ),
                    buildPage(
                      title: "Parking Journal 📅",
                      subtitle:
                          "Store parking start and end dates, costs and conditions in one place",
                      icon: CupertinoIcons.calendar,
                    ),
                    buildPage(
                      title: "Parking Reminders 🔔",
                      subtitle:
                          "Get notifications to remind you to check your parking spot",
                      icon: CupertinoIcons.bell_fill,
                    ),
                    buildPage(
                      title: "Parking Notes 📝",
                      subtitle:
                          "Add helpful notes: \"gates open at 8\", \"pass required\"",
                      icon: CupertinoIcons.doc_text_fill,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SmoothPageIndicator(
                controller: _controller,
                count: 4,
                effect: ExpandingDotsEffect(
                  activeDotColor: CupertinoColors.systemYellow,
                  dotColor: CupertinoColors.systemGrey3,
                  dotHeight: 10,
                  dotWidth: 10,
                  expansionFactor: 4,
                  spacing: 8,
                ),
              ),
              const SizedBox(height: 24),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: isLastPage
                    ? Container(
                        key: const ValueKey("start"),
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 32),
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              CupertinoColors.systemYellow,
                              CupertinoColors.systemOrange,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: CupertinoColors.systemYellow.withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: _finishOnboarding,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.car_fill,
                                color: CupertinoColors.white,
                                size: 24,
                              ),
                              SizedBox(width: 12),
                              Text(
                                "🚀 Start with Parking",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: CupertinoColors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        key: const ValueKey("next"),
                        margin: const EdgeInsets.symmetric(horizontal: 32),
                        child: CupertinoButton(
                          onPressed: () => _controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: CupertinoColors.systemYellow.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: CupertinoColors.systemYellow.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Next",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: CupertinoColors.systemYellow,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  CupertinoIcons.chevron_right,
                                  color: CupertinoColors.systemYellow,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPage({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Beautiful icon with gradient
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  CupertinoColors.systemYellow,
                  CupertinoColors.systemOrange,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(80),
              boxShadow: [
                BoxShadow(
                  color: CupertinoColors.systemYellow.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: CupertinoColors.systemOrange.withOpacity(0.2),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 80,
              color: CupertinoColors.white,
            ),
          ),
          const SizedBox(height: 48),
          
          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: CupertinoColors.label,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          
          // Subtitle
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: CupertinoColors.secondaryLabel,
              height: 1.4,
              letterSpacing: -0.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          // Decorative element
          Container(
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  CupertinoColors.systemYellow,
                  CupertinoColors.systemOrange,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
