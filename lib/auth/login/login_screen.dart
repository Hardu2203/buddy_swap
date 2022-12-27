import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:buddy_swap/app_config.dart';
import 'package:buddy_swap/auth/login/dev_users_dropdown.dart';
import 'package:buddy_swap/user/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late UserModel? _loggedInUser;

  List<Widget> devUserSelect(Size deviceSize) {
    return [
      SizedBox(height: deviceSize.height * .03,),
      DevUsersDropdown(selectUser ),
      SizedBox(height: deviceSize.height * .03,),
    ];
  }

  selectUser(UserModel selectedUser) {
    _loggedInUser = selectedUser;
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).backgroundColor,
                  Theme.of(context).colorScheme.primaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ListView(
                  children: <Widget>[
                    // Container(
                    //   alignment: Alignment.center,
                    //   padding: const EdgeInsets.all(10),
                    //   child: Text(
                    //     'BuddySwap',
                    //     style: Theme.of(context).textTheme.displayLarge,
                    //   ),
                    // ),
                    SizedBox(
                      height: deviceSize.height * 0.2,
                    ),
                    Center(
                      child: GradientText(
                        'BuddySwap',
                        style: GoogleFonts.permanentMarker(textStyle: Theme.of(context).textTheme.displayLarge),
                        gradient: LinearGradient(colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.tertiary,
                        ]),
                      ),
                    ),
                    SizedBox(
                      height: deviceSize.height * 0.01,
                    ),
                    SizedBox(
                      // width: 250.0,
                      child: DefaultTextStyle(
                        // textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontFamily: "Agne",
                        ),
                        child: AnimatedTextKit(
                          animatedTexts: [
                            TyperAnimatedText('Peer to peer crypto buy and sell orders',
                                speed: const Duration(milliseconds: 180),
                                textAlign: TextAlign.center,
                                curve: Curves.easeInOut),
                          ],
                          isRepeatingAnimation: false,
                        ),
                      ),
                    ),
                    if (AppConfig.of(context)?.environment == Environment.dev)
                      ...devUserSelect(deviceSize),
                    SizedBox(
                      height: deviceSize.height * 0.05,
                    ),
                    Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ActionChip(
                          avatar: Image.asset(
                            'assets/images/metamask-logo-png-transparent.png',
                            height: 24,
                          ),
                          label: const Text('Connect Wallet'),
                          onPressed: () {
                            Provider.of<AuthProvider>(context, listen: false).login(_loggedInUser);
                          },
                        )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    super.key,
    required this.gradient,
    this.style,
  });

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}
