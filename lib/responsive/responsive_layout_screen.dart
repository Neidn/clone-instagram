import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:clone_instagram/providers/user_provider.dart';

import 'package:clone_instagram/utils/dimensions.dart';

class ResponsiveLayout extends StatefulWidget {
  Widget webScreenLayout;
  Widget mobileScreenLayout;

  ResponsiveLayout({
    super.key,
    required this.webScreenLayout,
    required this.mobileScreenLayout,
  });

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  void addData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // WebScreen
        if (constraints.maxWidth > webScreenSize) {
          return widget.webScreenLayout;
        }
        // MobileScreen
        return widget.mobileScreenLayout;
      },
    );
  }
}
