import 'package:flutter/material.dart';

/// Simple responsive layout helper.
/// Provides static methods to determine screen size categories.
class ResponsiveLayout {
  static const int mobileBreakpoint = 600;
  static const int tabletBreakpoint = 1024;

  /// Returns true if the screen width is less than [mobileBreakpoint].
  static bool isMobile(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width < mobileBreakpoint;
  }

  /// Returns true if the width is between [mobileBreakpoint] and [tabletBreakpoint].
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  /// Returns true if the width is greater than or equal to [tabletBreakpoint].
  static bool isDesktop(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= tabletBreakpoint;
  }
}
