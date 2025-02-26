import 'package:flutter/material.dart';

import 'hoverable_navigation_rail_destination.dart';

// Custom NavigationRail that handles hover detection for HoverableNavigationRailDestinations
class HoverableNavigationRail extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;
  final List<NavigationRailDestination> destinations;
  final Widget? leading;
  final Widget? trailing;
  final bool extended;
  final bool useIndicator;
  final double? indicatorColor;
  final double? minWidth;
  final double? minExtendedWidth;
  final Color? backgroundColor;
  final Color? selectedIconTheme;
  final Color? selectedLabelTextStyle;
  final Color? unselectedIconTheme;
  final Color? unselectedLabelTextStyle;
  final NavigationRailLabelType? labelType;
  final double? groupAlignment;
  final double? elevation;

  const HoverableNavigationRail({
    super.key,
    required this.selectedIndex,
    this.onDestinationSelected,
    required this.destinations,
    this.leading,
    this.trailing,
    this.extended = false,
    this.useIndicator = false,
    this.indicatorColor,
    this.minWidth,
    this.minExtendedWidth,
    this.backgroundColor,
    this.selectedIconTheme,
    this.selectedLabelTextStyle,
    this.unselectedIconTheme,
    this.unselectedLabelTextStyle,
    this.labelType,
    this.groupAlignment,
    this.elevation,
  });

  @override
  State<HoverableNavigationRail> createState() =>
      _HoverableNavigationRailState();
}

class _HoverableNavigationRailState extends State<HoverableNavigationRail> {
  final List<Key> _destinationKeys = [];

  @override
  void initState() {
    super.initState();
    _initializeKeys();
  }

  @override
  void didUpdateWidget(HoverableNavigationRail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.destinations.length != widget.destinations.length) {
      _initializeKeys();
    }
  }

  void _initializeKeys() {
    _destinationKeys.clear();
    for (int i = 0; i < widget.destinations.length; i++) {
      _destinationKeys.add(GlobalKey());
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: widget.selectedIndex,
      onDestinationSelected: widget.onDestinationSelected,
      extended: widget.extended,
      useIndicator: widget.useIndicator,
      minWidth: widget.minWidth,
      minExtendedWidth: widget.minExtendedWidth,
      backgroundColor: widget.backgroundColor,
      labelType: widget.labelType,
      groupAlignment: widget.groupAlignment,
      elevation: widget.elevation,
      leading: widget.leading,
      trailing: widget.trailing,
      destinations: _buildHoverableDestinations(),
    );
  }

  List<NavigationRailDestination> _buildHoverableDestinations() {
    return List.generate(widget.destinations.length, (index) {
      final destination = widget.destinations[index];
      final key = _destinationKeys[index];

      // For HoverableNavigationRailDestination, we need to observe mouse events
      if (destination is HoverableNavigationRailDestination) {
        return NavigationRailDestination(
          icon: _HoverDetector(
            key: key,
            child: destination.icon,
            onHoverChanged: (isHovered) {
              HoverableNavigationRailDestination.triggerHover(key, isHovered);
            },
          ),
          selectedIcon:
              destination.selectedIcon != null
                  ? _HoverDetector(
                    key: key,
                    child: destination.selectedIcon,
                    onHoverChanged: (isHovered) {
                      HoverableNavigationRailDestination.triggerHover(
                        key,
                        isHovered,
                      );
                    },
                  )
                  : null,
          label: _HoverDetector(
            key: key,
            child: destination.label,
            onHoverChanged: (isHovered) {
              HoverableNavigationRailDestination.triggerHover(key, isHovered);
            },
          ),
          padding: destination.padding,
        );
      }

      // For regular NavigationRailDestination, just pass it through
      return destination;
    });
  }

  @override
  void dispose() {
    // Clean up hover callbacks
    for (final key in _destinationKeys) {
      HoverableNavigationRailDestination.removeCallback(key);
    }
    super.dispose();
  }
}

// Helper widget to detect hover events
class _HoverDetector extends StatelessWidget {
  final Widget child;
  final Function(bool) onHoverChanged;

  const _HoverDetector({
    required this.child,
    required this.onHoverChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => onHoverChanged(true),
      onExit: (_) => onHoverChanged(false),
      child: child,
    );
  }
}

// Example usage
class NavigationRailExample extends StatefulWidget {
  const NavigationRailExample({super.key});

  @override
  State<NavigationRailExample> createState() => _NavigationRailExampleState();
}

class _NavigationRailExampleState extends State<NavigationRailExample> {
  int _selectedIndex = 0;
  String _hoverStatus = "Not hovered";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          HoverableNavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            destinations: <NavigationRailDestination>[
              // Regular NavigationRailDestination
              const NavigationRailDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: Text('Home'),
              ),

              // Custom HoverableNavigationRailDestination
              HoverableNavigationRailDestination(
                key: ValueKey('settings'),
                icon: const Icon(Icons.settings_outlined),
                selectedIcon: const Icon(Icons.settings),
                label: const Text('Settings'),
                onHovered: (isHovered) {
                  setState(() {
                    _hoverStatus =
                        isHovered ? "Settings hovered" : "Settings not hovered";
                  });
                },
              ),

              HoverableNavigationRailDestination(
                key: ValueKey('profile'),
                icon: const Icon(Icons.person_outlined),
                selectedIcon: const Icon(Icons.person),
                label: const Text('Profile'),
                onHovered: (isHovered) {
                  setState(() {
                    _hoverStatus =
                        isHovered ? "Profile hovered" : "Profile not hovered";
                  });
                },
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          Expanded(
            child: Center(
              child: Text('Selected: $_selectedIndex, $_hoverStatus'),
            ),
          ),
        ],
      ),
    );
  }
}
