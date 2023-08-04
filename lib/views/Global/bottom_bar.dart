import 'package:flutter/material.dart';

import '../One-Way/one_way.dart';
import '../One-Way/round_trip.dart';

class Bottom extends StatefulWidget {
  const Bottom({super.key});

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  int indexx = 0;
  final pages = [
    const Center(child: SelectTravelType()),
    const Center(child: History()),
    const Center(child: Manage()),
    const Center(child: Profile()),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[indexx],
      bottomNavigationBar: NavigationBar(
        height: 60,
        backgroundColor: Colors.blue,
        indicatorColor: Colors.white,
        selectedIndex: indexx,
        onDestinationSelected: (value) {
          setState(() {
            indexx = value;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(icon: Icon(Icons.history), label: 'History'),
          NavigationDestination(
              icon: Icon(Icons.manage_history), label: 'Manage'),
          NavigationDestination(
              icon: Icon(Icons.verified_user), label: "Profile")
        ],
      ),
    );
  }
}

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Text('This is History Class'),
      ),
    );
  }
}

class Manage extends StatefulWidget {
  const Manage({super.key});

  @override
  State<Manage> createState() => _ManageState();
}

class _ManageState extends State<Manage> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Text('This is Manage Class'),
      ),
    );
  }
}

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Text('This is Profile Class'),
      ),
    );
  }
}

class SelectTravelType extends StatefulWidget {
  const SelectTravelType({super.key});

  @override
  State<SelectTravelType> createState() => _SelectTravelTypeState();
}

class _SelectTravelTypeState extends State<SelectTravelType> {
  List<String> selectType = ["One Way", "Round Trip"];
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Colors.white,
          // appBar: AppBar(title: Text("Switch")),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(blurRadius: 2, offset: Offset(0, 0))
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0)),
                    child: TabBar(
                      indicator: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(25)),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      tabs: const [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [Tab(text: "One way"), Icon(Icons.flight)],
                        ),
                        Tab(
                          text: "Round trip",
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      child: TabBarView(children: [
                    OneWay(),
                    const Center(
                      child: RoundTrip(),
                    )
                  ]))
                ],
              ),
            ),
          )),
    );
  }
}
