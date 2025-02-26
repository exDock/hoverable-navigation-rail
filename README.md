# Hoverable Navigation Rail

A Flutter package that extends the standard `NavigationRail` widget to provide hover state detection for individual destinations. This allows you to easily add interactive hover effects to your navigation rail items.

## Features

* **Hover State Detection:** Enables you to detect when the mouse cursor hovers over individual `NavigationRailDestination` items.
* **Custom Hover Callbacks:** Provides an `Function(bool isHovered) onHoverStateChange` callback for each destination, allowing you to execute custom logic when the hover state changes.
* **Seamless Integration:** Designed to work smoothly with the standard `NavigationRail` widget, preserving all its existing functionality.
* **Easy to Use:** Simple API for adding hover functionality to your navigation rails.

## Getting started

1.  **Add the dependency:**

    ```yaml
    dependencies:
      hoverable_navigation_rail: ^latest_version
    ```

    Replace `latest_version` with the latest version of the package.

2.  **Import the package:**

    ```dart
    import 'package:hoverable_navigation_rail/hoverable_navigation_rail.dart';
    ```

## Usage

Replace standard `NavigationRailDestination` with `HoverableNavigationRailDestination` and use `HoverableNavigationRail` instead of `NavigationRail`.

```dart
import 'package:flutter/material.dart';
import 'package:hoverable_navigation_rail/hoverable_navigation_rail.dart';

class MyNavigationRail extends StatefulWidget {
  const MyNavigationRail({super.key});

  @override
  State<MyNavigationRail> createState() => _MyNavigationRailState();
}

class _MyNavigationRailState extends State<MyNavigationRail> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          HoverableNavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            destinations: [
              HoverableNavigationRailDestination(
                icon: const Icon(Icons.home),
                label: 'Home',
                onHoverStateChange: (isHovered) {
                  print('Home hovered: $isHovered');
                  // Add your hover logic here
                },
              ),
              HoverableNavigationRailDestination(
                icon: const Icon(Icons.settings),
                label: 'Settings',
                onHoverStateChange: (isHovered) {
                  print('Settings hovered: $isHovered');
                  // Add your hover logic here
                },
              ),
              HoverableNavigationRailDestination(
                icon: const Icon(Icons.person),
                label: 'Profile',
                onHoverStateChange: (isHovered) {
                  print('Profile hovered: $isHovered');
                  // Add your hover logic here
                },
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: Text('Selected index: $_selectedIndex'),
            ),
          ),
        ],
      ),
    );
  }
}
```
