import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../screens/onboarding/driver_splash_screen.dart';
import '../../screens/onboarding/driver_login_screen.dart';
import '../../screens/onboarding/driver_register_screen.dart';
import '../../screens/onboarding/driver_otp_screen.dart';
import '../../screens/onboarding/driver_profile_setup_screen.dart';
import '../../screens/porter_shell.dart';
import '../../screens/dashboard/porter_dashboard_screen.dart';
import '../../screens/orders/orders_list_screen.dart';
import '../../screens/orders/order_details_screen.dart';
import '../../screens/earnings/earnings_screen.dart';
import '../../screens/profile/profile_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const DriverSplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const DriverLoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const DriverRegisterScreen(),
    ),
    GoRoute(
      path: '/verify-otp',
      builder: (context, state) {
        final phone = state.uri.queryParameters['phone'] ?? '';
        final isRegister = state.uri.queryParameters['isRegister'] == 'true';
        return DriverOtpScreen(phone: phone, isRegister: isRegister);
      },
    ),
    GoRoute(
      path: '/profile-details',
      builder: (context, state) => const DriverProfileSetupScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return PorterShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const PorterDashboardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/orders',
              builder: (context, state) => const OrdersListScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/earnings',
              builder: (context, state) => const EarningsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/order/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final orderId = state.pathParameters['id'] ?? '';
        return OrderDetailsScreen(orderId: orderId);
      },
    ),
  ],
);
