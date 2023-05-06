import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:clone_instagram/utils/colors.dart';

import 'package:clone_instagram/widgets/text_field_input.dart';

import 'package:clone_instagram/resources/auth_methods.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
    super.dispose();
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

            Stack(
              children: [
                const CircleAvatar(
                  radius: 64,
                  backgroundImage: NetworkImage(
                    'https://cdn.pixabay.com/photo/2017/06/09/17/11/model-2387582_960_720.jpg',
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.add_a_photo),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // text field for username
            TextFieldInput(
              hintText: 'Enter your username',
              textInputType: TextInputType.name,
              textEditingController: _usernameController,
            ),
            const SizedBox(height: 24),

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

            // text field for bio
            TextFieldInput(
              hintText: 'Enter your bio',
              textInputType: TextInputType.text,
              textEditingController: _bioController,
            ),
            const SizedBox(height: 24),

            // button login
            InkWell(
              onTap: () async {
                String result = await AuthMethods().signUpUser(
                  email: _emailController.text,
                  password: _passController.text,
                  username: _usernameController.text,
                  bio: _bioController.text,
                );

                print(result);
              },
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
                child: const Text('Sign up'),
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
                  child: const Text(
                    "Sign up",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
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
