import 'package:buddy_swap/app_config.dart';
import 'package:buddy_swap/auth/auth_functions/auth_functions.dart';
import 'package:buddy_swap/auth/auth_functions/dev_auth_functions.dart';
import 'package:buddy_swap/auth/auth_functions/prod_auth_functions.dart';
import 'package:buddy_swap/auth/auth_provider.dart';
import 'package:buddy_swap/bank/bank_details_provider.dart';
import 'package:buddy_swap/buy/buy_provider.dart';
import 'package:buddy_swap/sell/sell_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth/login/login_screen.dart';
import 'go_router/go_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AppConfig config = AppConfig.of(context)!;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthProvider((config.environment == Environment.prod) ? ProdAuthFunctions() : DevAuthFunctions())),
        ChangeNotifierProxyProvider<AuthProvider, BuyProvider>(create: (_) => BuyProvider(), update: (ctx, auth, previousBuyProvider) => BuyProvider(auth, previousBuyProvider)),
        ChangeNotifierProxyProvider<AuthProvider, SellProvider>(create: (_) => SellProvider(), update: (ctx, auth, previousSellProvider) => SellProvider(auth, previousSellProvider)),
        ChangeNotifierProxyProvider<AuthProvider, BankDetailsProvider>(create: (_) => BankDetailsProvider(), update: (ctx, auth, previousBankDetailsProvider) => BankDetailsProvider(auth, previousBankDetailsProvider)),
      ],
      child: MaterialApp.router(
        title: 'Flutter Demo',
        theme:  config.theme,
        darkTheme: config.darkTheme,
        themeMode: config.themeMode,
        routerConfig: router,//MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}