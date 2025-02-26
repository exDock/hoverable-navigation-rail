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

  @override
  Widget build(BuildContext context) {
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
                key: UniqueKey(),
                icon: Icon(Icons.home),
                label: Text("home"),
                onHovered: (boolVar) {
                  if (boolVar) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Home is hovered"),
                        duration: Duration(milliseconds: 300),
                      ),
                    );
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Home is not hovered, but onHovered was triggered",
                      ),
                      duration: Duration(milliseconds: 300),
                    ),
                  );
                },
              ),
              HoverableNavigationRailDestination(
                key: UniqueKey(),
                icon: Icon(Icons.help),
                label: Text("help"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.hourglass_bottom_rounded),
                label: Text("Not hoverable"),
              ),
            ],
          ),
          Expanded(child: navigationDestinationWidgets[selectedIndex]),
        ],
      ),
    );
  }
}
