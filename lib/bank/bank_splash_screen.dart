import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class BankSplashScreen extends StatelessWidget {
  const BankSplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Column(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.all(deviceSize.width * 0.02),
            // color: Colors.pink,
            decoration: const BoxDecoration(
              image: DecorationImage(
                opacity: 0.5,
                image: Svg(kUndrawSavings),
              ),
            ),
          ),
        ),
        Expanded(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text("Please provide valid bank details before selling", style: GoogleFonts.permanentMarker(
              textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).textTheme.titleLarge?.color?.withOpacity(0.5)))),
        )),
      ],
    );
  }
}
