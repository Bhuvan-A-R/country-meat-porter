import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../widgets/country_meat_logo.dart';

class DriverSplashScreen extends StatefulWidget {
  const DriverSplashScreen({super.key});

  @override
  State<DriverSplashScreen> createState() => _DriverSplashScreenState();
}

class _DriverSplashScreenState extends State<DriverSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  int _loadingStep = 0;
  final List<String> _loadingMessages = [
    'Initializing Secure Hub Connection...',
    'Securing Cold-Chain GPS Tracking...',
    'Parsing Assigned Porter Deliveries...',
    'Partner Portal Ready. Entering...',
  ];

  Timer? _stepTimer;
  Timer? _languageTimer;
  Timer? _navigationTimer;
  String _appVersion = 'Loading version...';
  int _partnerLanguageStep = 0;

  static const _partnerLanguageLabels = [
    'DELIVERY PARTNER',
    'वितरण भागीदार',
    'ವಿತರಣಾ ಪಾಲುದಾರ',
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _loadAppVersion();

    _languageTimer = Timer.periodic(const Duration(milliseconds: 1250), (
      timer,
    ) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(
        () => _partnerLanguageStep =
            (_partnerLanguageStep + 1) % _partnerLanguageLabels.length,
      );
    });

    // Sequence through loading messages during the five-second splash.
    _stepTimer = Timer.periodic(const Duration(milliseconds: 1250), (timer) {
      if (mounted) {
        setState(() {
          if (_loadingStep < _loadingMessages.length - 1) {
            _loadingStep++;
          } else {
            timer.cancel();
          }
        });
      }
    });

    _navigationTimer = Timer(const Duration(seconds: 8), () {
      if (mounted) {
        context.go('/login');
      }
    });
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(
        () =>
            _appVersion = 'v${packageInfo.version}+${packageInfo.buildNumber}',
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _stepTimer?.cancel();
    _languageTimer?.cancel();
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color darkWine = Color(0xFF3A0007);
    const Color brandCrimson = Color(0xFF9E0D1B);
    const Color brightRed = Color(0xFFD32F2F);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [darkWine, brandCrimson, brightRed],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Subtle background decorative pattern/grid representation
              Positioned.fill(
                child: Opacity(
                  opacity: 0.05,
                  child: GridPaper(
                    color: Colors.white,
                    divisions: 1,
                    subdivisions: 1,
                    interval: 30,
                  ),
                ),
              ),

              // Central Branding & Loading Card
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Glowing/Pulsing Logo Frame
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Opacity(
                            opacity: _fadeAnimation.value,
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 30,
                              spreadRadius: 2,
                              offset: const Offset(0, 10),
                            ),
                            BoxShadow(
                              color: brightRed.withValues(alpha: 0.5),
                              blurRadius: 50,
                              spreadRadius: -5,
                            ),
                          ],
                        ),
                        child: const CountryMeatLogo(
                          isRed: true,
                          fontSize: 32,
                          height: 70,
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Portal Sub-label
                    Container(
                      width: 350,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white24, width: 1.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'PORTER PARTNER APP •',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(width: 5),
                          SizedBox(
                            width: 145,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 550),
                              transitionBuilder: (child, animation) {
                                final slideAnimation =
                                    Tween<Offset>(
                                      begin: const Offset(0, 1),
                                      end: Offset.zero,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeOutCubic,
                                      ),
                                    );
                                return ClipRect(
                                  child: SlideTransition(
                                    position: slideAnimation,
                                    child: FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                _partnerLanguageLabels[_partnerLanguageStep],
                                key: ValueKey<int>(_partnerLanguageStep),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                softWrap: false,
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Modern Linear Loader
                    SizedBox(
                      width: 180,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: null,
                          minHeight: 5,
                          backgroundColor: Colors.white12,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Active Step Text
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: Text(
                        _loadingMessages[_loadingStep],
                        key: ValueKey<int>(_loadingStep),
                        style: GoogleFonts.inter(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Brand Footnote
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.ac_unit_rounded,
                          color: Colors.white60,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '100% COLD-CHAIN SECURED MEAT',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: Colors.white60,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _appVersion,
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        color: Colors.white38,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
