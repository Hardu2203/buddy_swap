import 'package:buddy_swap/auth/auth_provider.dart';
import 'package:buddy_swap/buy/buy_details_screen.dart';
import 'package:buddy_swap/buy/buy_screen.dart';
import 'package:buddy_swap/sell/create_sell_order_screen.dart';
import 'package:buddy_swap/sell/sell_details_screen.dart';
import 'package:buddy_swap/sell/sell_screen.dart';
import 'package:buddy_swap/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../auth/login/login_screen.dart';
import '../home/home_screen.dart';
import 'bottom_navigator/scaffold_with_navbar.dart';

const ValueKey<String> bottonNavBar = ValueKey<String>('Bottom Nav');
const ValueKey<String> buyDetails = ValueKey<String>('Buy Details');
const ValueKey<String> sellDetails = ValueKey<String>('Sell Details');

// GoRouter configuration
final router = GoRouter(
  initialLocation: "/buy",
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    ShellRoute(
        // path: '/home',
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return ScaffoldWithNavBar(child: child);
        },
        routes: <RouteBase>[
          GoRoute(
            path: '/buy',
            pageBuilder: (BuildContext context, GoRouterState state) =>
                FadeTransitionPage(key: bottonNavBar, child: const BuyScreen()),
            routes: <RouteBase>[
              // The details screen to display stacked on the inner Navigator.
              // This will cover screen A but not the application shell.
              GoRoute(
                path: 'details',
                pageBuilder: (BuildContext context, GoRouterState state) =>
                    FadeTransitionPage(
                        key: buyDetails, child: const BuyDetailsScreen()),
              ),
            ],
          ),
          GoRoute(
            path: '/sell',
            pageBuilder: (BuildContext context, GoRouterState state) =>
                FadeTransitionPage(key: sellDetails, child: const SellScreen()),
            routes: <RouteBase>[
              /// Same as "/a/details", but displayed on the root Navigator by
              /// specifying [parentNavigatorKey]. This will cover both screen B
              /// and the application shell.
              GoRoute(
                path: 'create',
                pageBuilder: (BuildContext context, GoRouterState state) =>
                    FadeTransitionPage(
                        key: bottonNavBar,
                        child: const CreateSellOrderScreen()),
              ),
              GoRoute(
                path: ':orderId',
                pageBuilder: (BuildContext context, GoRouterState state) =>
                    FadeTransitionPage(
                        key: bottonNavBar,
                        child: SellDetailsScreen(
                          index: int.parse(state.params["orderId"]!),
                        )),
              ),
            ],
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (BuildContext context, GoRouterState state) =>
                FadeTransitionPage(key: sellDetails, child: const SettingsScreen()),
          ),
        ]),
  ],
  redirect: (BuildContext context, GoRouterState state) {
    if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
      return null;
    } else {
      return '/login';
    }
  },
);

/// A page that fades in an out.
class FadeTransitionPage extends CustomTransitionPage<void> {
  /// Creates a [FadeTransitionPage].
  FadeTransitionPage({
    required LocalKey key,
    required Widget child,
  }) : super(
            key: key,
            transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) =>
                FadeTransition(
                  opacity: animation.drive(_curveTween),
                  child: child,
                ),
            child: child);

  static final CurveTween _curveTween = CurveTween(curve: Curves.easeIn);
}
