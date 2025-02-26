import 'package:flutter/material.dart';

class HoverableNavigationRailDestination extends NavigationRailDestination {
  // Store the onHovered callback in a static map keyed by UniqueKey
  static final Map<Key, Function(bool)> _hoverCallbacks = {};

  HoverableNavigationRailDestination({
    required super.icon,
    required super.label,
    super.selectedIcon,
    super.padding,
    Function(bool isHovered)? onHovered,
    Key? key,
  }) {
    // Generate a unique key if none was provided
    final effectiveKey = key ?? UniqueKey();

    // Store the callback if provided
    if (onHovered != null) {
      _hoverCallbacks[effectiveKey] = onHovered;
    }
  }

  // Method to check if a destination has a hover callback
  static bool hasHoverCallback(Key key) {
    return _hoverCallbacks.containsKey(key);
  }

  // Method to trigger the hover callback
  static void triggerHover(Key key, bool isHovered) {
    if (_hoverCallbacks.containsKey(key)) {
      _hoverCallbacks[key]!(isHovered);
    }
  }

  // Clean up method to remove callbacks when no longer needed
  static void removeCallback(Key key) {
    _hoverCallbacks.remove(key);
  }
}
