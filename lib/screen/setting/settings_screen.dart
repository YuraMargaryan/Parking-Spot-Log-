import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> 
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      navigationBar: CupertinoNavigationBar(
        middle: const Text(
          '🚗 Parking Settings',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        backgroundColor: CupertinoColors.systemBackground,
        border: const Border(
          bottom: BorderSide(
            color: CupertinoColors.separator,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildParkingHeader(),
                  const SizedBox(height: 24),
              
                  _buildSettingsSection(
                    title: '🚦 Legal Information',
                    children: [
                      _buildAnimatedSettingsTile(
                        context: context,
                        icon: CupertinoIcons.shield_fill,
                        title: 'Privacy Policy',
                        subtitle: 'Protection of your parking spot data',
                        delay: 0,
                        onTap: () => _launchURL('https://Parking_Spot_Log.com/privacy'),
                      ),
                      const SizedBox(height: 12),
                      _buildAnimatedSettingsTile(
                        context: context,
                        icon: CupertinoIcons.doc_text_fill,
                        title: 'Terms of Use',
                        subtitle: 'Rules for using the parking app',
                        delay: 100,
                        onTap: () => _launchURL('https://Parking_Spot_Log/terms'),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  _buildSettingsSection(
                    title: '🛠️ Support',
                    children: [
                      _buildAnimatedSettingsTile(
                        context: context,
                        icon: CupertinoIcons.star_fill,
                        title: 'Rate App',
                        subtitle: 'Help others find convenient parking',
                        delay: 200,
                        onTap: () => _rateApp(),
                      ),
                      const SizedBox(height: 12),
                      _buildAnimatedSettingsTile(
                        context: context,
                        icon: CupertinoIcons.chat_bubble_fill,
                        title: 'Contact Support',
                        subtitle: 'Help with parking spots and navigation',
                        delay: 300,
                        onTap: () => _openSupport(),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  _buildSettingsSection(
                    title: '🚙 About App',
                    children: [
                      _buildAnimatedSettingsTile(
                        context: context,
                        icon: CupertinoIcons.info_circle_fill,
                        title: 'App Version',
                        subtitle: 'Parking Spot Log v1.0.0',
                        delay: 400,
                        onTap: () {},
                      ),
                      const SizedBox(height: 12),
                      _buildAnimatedSettingsTile(
                        context: context,
                        icon: CupertinoIcons.location_fill,
                        title: 'About Program',
                        subtitle: 'Convenient app for tracking parking spots',
                        delay: 500,
                        onTap: () => _showAboutDialog(),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildParkingHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            CupertinoColors.systemYellow.withOpacity(0.8),
            CupertinoColors.systemYellow.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: CupertinoColors.systemYellow.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemYellow.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      CupertinoColors.systemYellow,
                      CupertinoColors.systemOrange,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: CupertinoColors.systemYellow.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  CupertinoIcons.car_fill,
                  color: CupertinoColors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🚗 Parking Spot Log',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: CupertinoColors.label,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Convenient app for tracking parking spots',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: CupertinoColors.secondaryLabel,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: CupertinoColors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: CupertinoColors.systemYellow.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.location_fill,
                  color: CupertinoColors.systemYellow,
                  size: 16,
                ),
                SizedBox(width: 8),
                Text(
                  'Never lose your parking spot!',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.label,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: CupertinoColors.label,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

 

  Widget _buildAnimatedSettingsTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required int delay,
    required VoidCallback onTap,
  }) {
    return AnimatedBuilder(
      animation: _fadeController,
      builder: (context, child) {
        return _buildSettingsTile(
          context: context,
          icon: icon,
          title: title,
          subtitle: subtitle,
          onTap: onTap,
        );
      },
    );
  }

  Widget _buildSettingsTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: CupertinoColors.systemYellow.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemYellow.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 3),
          ),
          BoxShadow(
            color: CupertinoColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      CupertinoColors.systemYellow,
                      CupertinoColors.systemOrange,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: CupertinoColors.systemYellow.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: CupertinoColors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: CupertinoColors.label,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: CupertinoColors.secondaryLabel,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemYellow.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: CupertinoColors.systemYellow.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  CupertinoIcons.chevron_right,
                  color: CupertinoColors.systemYellow,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _rateApp() async {
    if (await InAppReview.instance.isAvailable()) {
      InAppReview.instance.requestReview();
    }
  }
  
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  Future<void> _openSupport() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@parking-spot-log.com',
      query: 'subject=Parking Spot Log Support&body=Hi, I need help with...',
    );
    
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      debugPrint('Could not launch email client');
    }
  }

  void _showAboutDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('🚗 About App'),
        content: const Column(
          children: [
            SizedBox(height: 16),
            Text('Parking Spot Log v1.0.0'),
            SizedBox(height: 8),
            Text('Convenient app for tracking parking spots.'),
            SizedBox(height: 8),
            Text('Never lose your parking spot!'),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}






