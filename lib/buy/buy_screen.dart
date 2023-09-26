
import 'package:buddy_swap/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class BuyScreen extends StatefulWidget {
  const BuyScreen({Key? key}) : super(key: key);

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buy',
            style: GoogleFonts.permanentMarker(
                textStyle: Theme.of(context).textTheme.titleLarge)),
      ),
      body: Center(
        child: FloatingActionButton(
          onPressed: () {
            context.go('/buy/details');
          },
          child: Text(kEnv.contractAddress.wbtc.toString() ?? ""),
        ),
      ),
    );
  }
}
