import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:clone_instagram/resources/auth_methods.dart';

import 'package:clone_instagram/utils/colors.dart';
import 'package:clone_instagram/utils/utiles.dart';

import 'package:clone_instagram/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  // Loading
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
  }

  void signInUser(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    String result = await AuthMethods().signInUser(
      email: _emailController.text,
      password: _passController.text,
    );

    if (result == 'Success') {
    } else {
      showSnackBar(context, result);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(flex: 2, child: Container()),
            // svg image
            SvgPicture.asset(
              'assets/images/ic_instagram.svg',
              height: 64,
              colorFilter: const ColorFilter.mode(
                primaryColor,
                BlendMode.srcIn,
              ),
            ),

            const SizedBox(height: 64),

            // text field for email
            TextFieldInput(
              hintText: 'Enter your email',
              textInputType: TextInputType.emailAddress,
              textEditingController: _emailController,
            ),
            const SizedBox(height: 24),

            // text field for password
            TextFieldInput(
              hintText: 'Enter your password',
              textInputType: TextInputType.visiblePassword,
              textEditingController: _passController,
              isPass: true,
            ),

            const SizedBox(height: 24),

            // button login
            InkWell(
              onTap: () => signInUser(context),
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  color: blueColor,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: primaryColor)
                    : const Text('Log in'),
              ),
            ),

            const SizedBox(height: 12),
            Flexible(flex: 2, child: Container()),

            // Transition to register screen
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    right: 8,
                  ),
                  child: const Text("Don't have an account?"),
                ),
                GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    child: const Text(
                      "Sign up",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
