import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import 'package:clone_instagram/utils/colors.dart';
import 'package:clone_instagram/utils/utils.dart';

import 'package:clone_instagram/widgets/text_field_input.dart';

import 'package:clone_instagram/resources/auth_methods.dart';

import 'package:clone_instagram/responsive/mobile_screen_layout.dart';
import 'package:clone_instagram/responsive/responsive_layout_screen.dart';
import 'package:clone_instagram/responsive/web_screen_layout.dart';
import 'package:clone_instagram/screens/login_screen.dart';

class SignupScreen extends StatefulWidget {
  static const String routeName = '/signup';

  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  // Profile image
  Uint8List? _image;

  // Loading
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void selectImage() async {
    Uint8List uint8list = await pickImage(ImageSource.gallery);
    setState(() {
      _image = uint8list;
    });
  }

  void signUpUser(BuildContext context) {
    setState(() {
      _isLoading = true;
    });

    AuthMethods()
        .signUpUser(
      email: _emailController.text,
      password: _passController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      profileImage: _image,
    )
        .then((result) {
      if (result == 'Success') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreenLayout(),
            ),
          ),
        );
      } else {
        showSnackBar(context, result);
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

  void navigateToLoginScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
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
                _image != null
                    ? CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(_image!),
                      )
                    : const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
                        ),
                      ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: () => selectImage(),
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
              onTap: () => signUpUser(context),
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
                    ? const CircularProgressIndicator(
                        color: primaryColor,
                      )
                    : const Text(
                        'Sign up',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                  child: const Text("Already have an account?"),
                ),
                GestureDetector(
                  onTap: () => navigateToLoginScreen(context),
                  child: const Text(
                    "Login",
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
