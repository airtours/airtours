import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:AirTours/views/One-Way/oneWay.dart';
import 'package:AirTours/views/One-Way/roundTrip.dart';

//import 'package:toggle_switch/toggle_switch.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? cityName;
  List<String> flight = [
    "Riyad",
    "jedah",
  ];
  final From = TextEditingController();
  void updateList(String val) {}
  void addFlight() {
    setState(() {
      flight.add(From.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[200]),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: DropdownSearch<String>(
                          mode: Mode.MENU,
                          showSelectedItems: true,
                          items: flight,
                          onChanged: (value) => cityName = value,
                          dropdownSearchDecoration: InputDecoration(
                              suffixIcon:
                                  const Icon(Icons.flight_takeoff_rounded),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none),
                              labelText: "from",
                              hintText: "form"),
                          showSearchBox: true,
                        ),
                      ),
                    ),
                    const SizedBox(
                        height: 20, child: Icon(Icons.arrow_downward_sharp)),
                    Container(
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey[200]),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: DropdownSearch<String>(
                            mode: Mode.MENU,
                            showSelectedItems: true,
                            items: flight,
                            onChanged: (value) => cityName = value,
                            dropdownSearchDecoration: InputDecoration(
                                suffixIcon:
                                    const Icon(Icons.flight_takeoff_rounded),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide.none),
                                labelText: "from",
                                hintText: "form"),
                            showSearchBox: true,
                          ),
                        )),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(),
                    TextField(
                      controller: From,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.flight_takeoff_rounded),
                        hintText: "From",
                      ),
                    ),
                    TextButton(onPressed: addFlight, child: const Text("add")),
                    TextField(
                        style: const TextStyle(color: Colors.black),
                        controller: null,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.flight_takeoff_rounded),
                          suffixIconColor: Colors.blue[300],
                          filled: true,
                          fillColor: Colors.red,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none),
                          hintText: "From",
                        )),
                    const TextField(
                      controller: null,
                    )
                  ],
                ))));
  }
}

// import 'package:flutter/material.dart';
// import 'package:dropdownfield2/dropdownfield2.dart';

// class Home extends StatefulWidget {
//   @override
//   State<Home> createState() => _HomeState();
// }
// class _HomeState extends State<Home> {
//   List <String> az=[];
//   void createFlight(){
//     print("flight is created");

//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: SafeArea(
//       child:Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           children: [
//             ,
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.grey[200]),
//                 child: Padding(
//                   padding: const EdgeInsets.all(15.0),
//                   child: Column(children: [Row(children: [DropDownField()],)
// ],),
//                 ),
//               ),
//             ),SizedBox(height: 10,),Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                       decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.red[200]),
//                       child: Padding(
//                         padding: const EdgeInsets.all(15.0),
//                         child: Column(children: [
//                 ],),
//                       ),
//                     ),
//                 ),
//               ],
//             ),
//           Expanded(flex: 10,child: SizedBox())
//           ],
//         ),
//       )
//     ));
//   }
// }

//can use the below

// class Home extends StatefulWidget {
//   @override
//   State<Home> createState() => _HomeState();
// }
// class _HomeState extends State<Home> {
//   String from="";
//   String to="";

//   void createFlight(){
//     print("flight is created");

//   }
//   final c=TextEditingController();
//   final d=TextEditingController();

//   List <String> city =["riyadh","jedah","riyadh","jedah","riyadh","jedah","riyadh","jedah","riyadh","jedah","riyadh","jedah","riyadh","jedah","riyadh","jedah","riyadh","jedah","riyadh","jedah","riyadh","jedah","riyadh","jedah","riyadh","jedah","riyadh","jedah","riyadh","jedah","riyadh","jedah","riyadh","jedah","riyadh","jedah","riyadh","jedah","riyadh","jedah","riyadh","jedah","riyadh","jedah","riyadh","jedah","riyadh","jedah","riyadh","jedah","riyadh","jedah","riyadh","jedah","riyadh","jedah","riyadh","jedah","riyadh","jedah","riyadh","jedah",];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: SafeArea(
//       child:Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           children: [SizedBox(height: 15,),Container(
//            // decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.grey[200]),
//             child: Column(
//               children: [
//                 DropDownField(controller: c,hintText: "From",enabled: true,items:city,itemsVisibleInDropdown: city.length,onValueChanged: (value1) {
//                   setState(() {
//                     from=value1;
//                     print(from);
//                   });
//                 },),SizedBox(height: 5,),DropDownField(controller: d,hintText: "To",enabled: true,items:city,itemsVisibleInDropdown: city.length,onValueChanged: (value2) {
//             setState(() {
//               to=value2;
//               print(to);
//             });
//           },)
//               ],
//             ),
//           ),
//           ],
//         ),
//       )
//     ));
//   }
// }

// class Home extends StatefulWidget {
//   @override
//   State<Home> createState() => _HomeState();
// }
// class _HomeState extends State<Home> {
//   List <String> flight=["Riyad","jedah","Riyad","dama","Riyad","jedah","Riyad","jedah","Riyad","jedah","Riyad","jedah","Riyad","jedah","Riyad","jedah","Riyad","jedah","Riyad","jedah","Riyad","jedah","Riyad","jedah","Riyad","jedah","Riyad","jedah","Riyad","jedah","Riyad","jedah","Riyad","jedah","Riyad","jedah","Riyad","jedah","Riyad","jedah","Riyad","jedah","Riyad","jedah",];
//   void updateList(String val){

//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(backgroundColor: Colors.grey[300],body: SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(children: [Center(child: Text("Search Flight",style: TextStyle(fontSize: 25,),)),SizedBox(height: 10,),
//         TextField(style: TextStyle(color: Colors.black),controller: null,decoration: InputDecoration(suffixIcon:Icon(Icons.flight_takeoff_rounded) ,suffixIconColor: Colors.blue[300],filled: true,fillColor: Colors.white,border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),borderSide: BorderSide.none),hintText: "From",))
//         ,SizedBox(height: 10,),
//         Expanded(child: ListView.separated(itemCount: flight.length,itemBuilder: (context, index) { return ListTile(title:Text(flight[index],style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         );},
//         separatorBuilder: (context, index) {return Divider();},))
//         ],),
//       )

//     ));}}

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
                    oneWay(),
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
