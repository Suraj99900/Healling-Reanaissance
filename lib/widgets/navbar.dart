import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kavita_healling_reanaissance/SharedPreferencesHelper.dart';
import 'package:kavita_healling_reanaissance/route/route.dart';
import 'package:kavita_healling_reanaissance/screen/CustomWebView.dart';
import '../screen/commonfunction.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  String? id;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final userId = await SharedPreferencesHelper.getUserId("sUserId");
    setState(() => id = userId);
  }

  @override
  Widget build(BuildContext context) {
    final dWidth = MediaQuery.of(context).size.width;
    final isWide = dWidth > 900;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: isWide ? 24 : 12,
        horizontal: isWide ? dWidth * 0.08 : 16,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(32),
              border:
                  Border.all(color: Colors.purple.withOpacity(0.1), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: isWide ? 20 : 12,
                horizontal: isWide ? 32 : 12,
              ),
              child: isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _brandLogo(isWide),
                        const Spacer(),
                        _navItems(isWide),
                        const Spacer(),
                        _authButtons(isWide),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _brandLogo(isWide),
                        const SizedBox(height: 16),
                        _navItems(isWide),
                        const SizedBox(height: 16),
                        _authButtons(isWide),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _brandLogo(bool isWide) {
    final dWidth = MediaQuery.of(context).size.width;
    final isTablet = dWidth > 600 && dWidth <= 900;
    final isMobile = dWidth <= 600;

    double avatarSize = isWide
        ? 56
        : isTablet
            ? 48
            : 38;
    double fontSize = isWide
        ? 28
        : isTablet
            ? 22
            : 16;
    double labelFontSize = isWide
        ? 22
        : isTablet
            ? 18
            : 14;
    double spacing = isWide
        ? 20
        : isTablet
            ? 14
            : 8;

    return Row(
      children: [
        Container(
          width: avatarSize,
          height: avatarSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFFD16BA5), Color(0xFF86A8E7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.12),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              "K",
              style: GoogleFonts.cairo(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
          ),
        ),
        SizedBox(width: spacing),
        Text(
          "Kvita's Healling Reanaissance",
          style: GoogleFonts.cairo(
            fontSize: labelFontSize,
            color: Colors.purple[900],
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _navItems(bool isWide) {
    final navs = [
      {"label": "Home", "onTap": () => Get.toNamed(AppRoutes.userHomeScreen)},
      {"label": "Category", "onTap": () => Get.toNamed(AppRoutes.zoom)},
      {
        "label": "About",
        "onTap": () => kIsWeb
            ? LaunchURL("https://lifehealerkavita.com/")
            : Get.to(() => CustomWebViewScreen(
                  url: "https://lifehealerkavita.com/",
                  title: "About",
                ))
      },
      if (id != null && id != '0' && id == '1')
        {
          "label": "Admin Dashboard",
          "onTap": () => Get.toNamed(AppRoutes.dashBoard)
        },
    ];

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: isWide ? 24 : 12,
      runSpacing: isWide ? 0 : 8,
      children: navs
          .map((nav) => _NavPill(
                text: nav["label"] as String,
                onTap: nav["onTap"] as VoidCallback,
                isWide: isWide,
              ))
          .toList(),
    );
  }

  Widget _authButtons(bool isWide) {
    final gradientLogin = const LinearGradient(
      colors: [Color(0xFF86A8E7), Color(0xFFD16BA5)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    final gradientRegister = const LinearGradient(
      colors: [Color(0xFF86ECA0), Color(0xFF7EE8FA)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    if (id == null || id == '0') {
      return Wrap(
        spacing: isWide ? 20 : 12,
        runSpacing: isWide ? 0 : 8,
        children: [
          _NavButton(
            text: "Login",
            gradient: gradientLogin,
            onTap: () => Get.toNamed(AppRoutes.login),
            isWide: isWide,
          ),
          _NavButton(
            text: "Register",
            gradient: gradientRegister,
            onTap: () => Get.toNamed(AppRoutes.adminLogin),
            isWide: isWide,
          ),
        ],
      );
    } else {
      return _NavButton(
        text: "Log Out",
        gradient: gradientLogin,
        onTap: () => buildButton("Log Out", AppRoutes.initial, Colors.red),
        isWide: isWide,
      );
    }
  }
}

class _NavPill extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final bool isWide;

  const _NavPill({
    required this.text,
    required this.onTap,
    required this.isWide,
  });

  @override
  State<_NavPill> createState() => _NavPillState();
}

class _NavPillState extends State<_NavPill> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            vertical: widget.isWide ? 12 : 8,
            horizontal: widget.isWide ? 28 : 16,
          ),
          decoration: BoxDecoration(
            color: _hover ? Colors.purple.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.purple.withOpacity(_hover ? 0.5 : 0.2),
              width: 1.4,
            ),
          ),
          child: Text(
            widget.text,
            style: GoogleFonts.cairo(
              fontSize: widget.isWide ? 16 : 14,
              color: Colors.purple[900],
              fontWeight: FontWeight.w600,
              letterSpacing: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatefulWidget {
  final String text;
  final LinearGradient gradient;
  final VoidCallback onTap;
  final bool isWide;

  const _NavButton({
    required this.text,
    required this.gradient,
    required this.onTap,
    required this.isWide,
  });

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            vertical: widget.isWide ? 14 : 10,
            horizontal: widget.isWide ? 32 : 20,
          ),
          decoration: BoxDecoration(
            gradient: widget.gradient,
            borderRadius: BorderRadius.circular(30),
            boxShadow: _hover
                ? [
                    BoxShadow(
                      color: widget.gradient.colors.last.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    )
                  ]
                : [],
          ),
          child: Text(
            widget.text,
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontSize: widget.isWide ? 16 : 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}
