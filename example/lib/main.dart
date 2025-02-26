import 'package:flutter/material.dart';
import 'package:hoverable_navigation_rail/hoverable_navigation_rail.dart';
import 'package:hoverable_navigation_rail/hoverable_navigation_rail_destination.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;
  List<Widget> navigationDestinationWidgets = [
    Center(child: Text("home page")),
    Center(child: Text("help page")),
    Center(child: Text("not hoverable page")),
  ];
  OverlayEntry? _overlayEntry;
  late OverlayState overlayState;

  @override
  Widget build(BuildContext context) {
    overlayState = Overlay.of(context);

    return Scaffold(
      body: Row(
        children: [
          HoverableNavigationRail(
            labelType: NavigationRailLabelType.all,
            selectedIndex: selectedIndex,
            onDestinationSelected: (int newIndex) {
              setState(() {
                selectedIndex = newIndex;
              });
            },
            destinations: [
              HoverableNavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text("home"),
                onHoverStateChange: (boolVar) {
                  if (boolVar) {
                    showOverlay("Home is hovered");
                    return;
                  }
                  _removeOverlay();
                },
              ),
              HoverableNavigationRailDestination(
                icon: Icon(Icons.help),
                label: Text("help"),
                onHoverStateChange: (boolVar) {
                  if (boolVar) {
                    showOverlay("help is hovered");
                    return;
                  }
                  _removeOverlay();
                },
              ),
            ],
          ),
          Expanded(child: navigationDestinationWidgets[selectedIndex]),
        ],
      ),
    );
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void showOverlay(String textToDisplay) {
    _removeOverlay(); // Remove any existing overlay first

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: 100,
          child: Material(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(50),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(child: Text(textToDisplay)),
            ),
          ),
        );
      },
    );

    overlayState.insert(_overlayEntry!);
  }
}
