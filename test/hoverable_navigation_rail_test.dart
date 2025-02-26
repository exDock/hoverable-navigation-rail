import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hoverable_navigation_rail/hoverable_navigation_rail.dart';
import 'package:hoverable_navigation_rail/hoverable_navigation_rail_destination.dart';

void main() {
  group('HoverableNavigationRail Tests', () {
    testWidgets('can be extended and shows labels', (
      WidgetTester tester,
    ) async {
      int selectedIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HoverableNavigationRail(
              selectedIndex: selectedIndex,
              extended: true,
              destinations: [
                HoverableNavigationRailDestination(
                  icon: const Icon(Icons.home),
                  label: const Text('Home'),
                ),
                HoverableNavigationRailDestination(
                  icon: const Icon(Icons.settings),
                  label: const Text('Settings'),
                ),
              ],
            ),
          ),
        ),
      );

      // In extended mode, labels should be visible
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('hover callback is triggered when hovering destinations', (
      WidgetTester tester,
    ) async {
      int selectedIndex = 0;
      bool? isHoveredState;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                HoverableNavigationRail(
                  selectedIndex: selectedIndex,
                  destinations: [
                    HoverableNavigationRailDestination(
                      icon: const Icon(Icons.home),
                      label: const Text('Home'),
                      onHoverStateChange: (isHovered) {
                        isHoveredState = isHovered;
                      },
                    ),
                    HoverableNavigationRailDestination(
                      icon: const Icon(Icons.settings),
                      label: const Text('Settings'),
                    ),
                  ],
                ),
                const Expanded(
                  child: SizedBox(),
                ), // Add this to ensure proper layout
              ],
            ),
          ),
        ),
      );

      // Force a frame to ensure layout is complete
      await tester.pumpAndSettle();

      // Find the home icon to get its position
      final homeIcon = find.byIcon(Icons.home);
      expect(homeIcon, findsOneWidget);

      final iconPosition = tester.getCenter(homeIcon);

      // Create a hover event on the first destination
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);

      // Move to the home icon center
      await gesture.moveTo(iconPosition);
      await tester.pumpAndSettle();

      // Verify hover callback was triggered with true
      expect(isHoveredState, true);

      // Move away from the navigation rail
      await gesture.moveTo(const Offset(500, 500));
      await tester.pumpAndSettle();

      // Verify hover callback was triggered with false
      expect(isHoveredState, false);
    });

    testWidgets('works with leading and trailing widgets', (
      WidgetTester tester,
    ) async {
      int selectedIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HoverableNavigationRail(
              selectedIndex: selectedIndex,
              leading: const Icon(Icons.menu),
              trailing: const Icon(Icons.exit_to_app),
              destinations: [
                HoverableNavigationRailDestination(
                  icon: const Icon(Icons.home),
                  label: const Text('Home'),
                ),
                HoverableNavigationRailDestination(
                  icon: const Icon(Icons.settings),
                  label: const Text('Settings'),
                ),
              ],
            ),
          ),
        ),
      );

      // Verify leading and trailing widgets are rendered
      expect(find.byIcon(Icons.menu), findsOneWidget);
      expect(find.byIcon(Icons.exit_to_app), findsOneWidget);
    });
  });
}
