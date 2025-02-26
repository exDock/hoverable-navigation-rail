import 'package:flutter/material.dart';

import 'hoverable_navigation_rail_destination.dart';

class HoverableNavigationRail extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;
  final List<NavigationRailDestination> destinations;
  final Widget? leading;
  final Widget? trailing;
  final bool extended;
  final bool useIndicator;
  final double? minWidth;
  final double? minExtendedWidth;
  final Color? backgroundColor;
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
    this.minWidth,
    this.minExtendedWidth,
    this.backgroundColor,
    this.labelType,
    this.groupAlignment,
    this.elevation,
  });

  @override
  State<HoverableNavigationRail> createState() =>
      _HoverableNavigationRailState();
}

class _HoverableNavigationRailState extends State<HoverableNavigationRail> {
  final Map<int, bool> _hoveredStates = {};

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Standard NavigationRail
        NavigationRail(
          selectedIndex: widget.selectedIndex,
          onDestinationSelected: widget.onDestinationSelected,
          destinations: widget.destinations,
          leading: widget.leading,
          trailing: widget.trailing,
          extended: widget.extended,
          useIndicator: widget.useIndicator,
          minWidth: widget.minWidth,
          minExtendedWidth: widget.minExtendedWidth,
          backgroundColor: widget.backgroundColor,
          labelType: widget.labelType,
          groupAlignment: widget.groupAlignment,
          elevation: widget.elevation,
        ),

        // Overlay invisible hover detectors
        Positioned.fill(
          child: IgnorePointer(
            ignoring: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Get the actual rendered rail width
                final railWidth =
                    widget.extended
                        ? (widget.minExtendedWidth ?? 256.0)
                        : (widget.minWidth ?? 72.0);

                return SizedBox(
                  width: railWidth,
                  child: _buildHoverDetectors(),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHoverDetectors() {
    // Calculate approximate height for each destination
    // This is an estimation as actual heights may vary
    final destinationHeight = 72.0;
    final leadingHeight = widget.leading != null ? 56.0 : 0.0;
    final startY = leadingHeight;

    return Stack(
      children: List.generate(widget.destinations.length, (index) {
        final destination = widget.destinations[index];
        final isHoverable = destination is HoverableNavigationRailDestination;

        // Only create hover detectors for HoverableNavigationRailDestination
        if (!isHoverable) return const SizedBox.shrink();

        final hoverableDestination = destination;

        return Positioned(
          left: 0,
          top: startY + (index * destinationHeight),
          right: 0,
          height: destinationHeight,
          child: MouseRegion(
            onEnter: (_) => _handleHover(index, true, hoverableDestination),
            onExit: (_) => _handleHover(index, false, hoverableDestination),
            // Use transparent container to detect hover over the entire area
            child: Container(color: Colors.transparent),
          ),
        );
      }),
    );
  }

  void _handleHover(
    int index,
    bool isHovered,
    HoverableNavigationRailDestination destination,
  ) {
    if (_hoveredStates[index] == isHovered) return;

    setState(() {
      _hoveredStates[index] = isHovered;
    });

    if (destination.onHoverStateChange != null) {
      destination.onHoverStateChange!(isHovered);
    }
  }
}
