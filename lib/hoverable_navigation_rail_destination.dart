import 'package:flutter/material.dart';

class HoverableNavigationRailDestination extends NavigationRailDestination {
  HoverableNavigationRailDestination({
    required super.icon,
    required super.label,
    super.selectedIcon,
    super.padding,
    this.onHoverStateChange,
    Key? key,
  });

  final Function(bool isHovered)? onHoverStateChange;
  final UniqueKey _uniqueId = UniqueKey();

  UniqueKey get uniqueId => _uniqueId;
}
