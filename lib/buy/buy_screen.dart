import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class BuyScreen extends StatelessWidget {
  const BuyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Buy' , style: GoogleFonts.permanentMarker(textStyle:  Theme.of(context).textTheme.titleLarge)),),
      body: Center(
        child: FloatingActionButton(onPressed: () { context.go('/buy/details'); },),
      ),
    );
  }
}
