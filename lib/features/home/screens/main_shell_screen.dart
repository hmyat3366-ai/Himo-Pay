import 'package:flutter/material.dart';
import '../../../core/widgets/himo_bottom_nav.dart';
import '../../../core/localization/locale_manager.dart';
import '../../home/screens/home_screen.dart';
import '../../wallet/screens/wallet_screen.dart';
import '../../qr/screens/my_qr_screen.dart';
import '../../rewards/screens/rewards_screen.dart';
import '../../profile/screens/profile_screen.dart';

class MainShellScreen extends StatefulWidget {
  final int initialTab;
  final VoidCallback? onToggleTheme;
  final bool isDark;

  const MainShellScreen({
    super.key,
    this.initialTab = 0,
    this.onToggleTheme,
    this.isDark = false,
  });

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: LocaleManager.currentLocale,
      builder: (context, localeCode, _) {
        final screens = [
          HomeScreen(key: ValueKey('home_tab_$localeCode')),
          WalletScreen(key: ValueKey('wallet_tab_$localeCode')),
          MyQrScreen(key: ValueKey('qr_tab_$localeCode')),
          RewardsScreen(key: ValueKey('rewards_tab_$localeCode')),
          ProfileScreen(
            key: ValueKey('profile_tab_$localeCode'),
            onToggleTheme: widget.onToggleTheme,
            isDark: widget.isDark,
          ),
        ];

        return Scaffold(
          body: Stack(
            children: [
              IndexedStack(
                index: _currentIndex,
                children: screens,
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: HimoBottomNav(
                  key: ValueKey('bottom_nav_$localeCode'),
                  currentIndex: _currentIndex,
                  onTap: (index) {
                    if (index == 2) {
                      Navigator.of(context).pushNamed('/scan-qr');
                    } else {
                      setState(() => _currentIndex = index);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

