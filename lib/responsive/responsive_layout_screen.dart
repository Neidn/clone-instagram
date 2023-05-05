import 'package:flutter/material.dart';

import 'package:clone_instagram/utils/dimensions.dart';

class ResponsiveLayout extends StatelessWidget {
  Widget webScreenLayout;
  Widget mobileScreenLayout;

  ResponsiveLayout({
    super.key,
    required this.webScreenLayout,
    required this.mobileScreenLayout,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // WebScreen
        if (constraints.maxWidth > webScreenSize) {
          return webScreenLayout;
        }
        // MobileScreen
        return mobileScreenLayout;
      },
    );
  }
}
