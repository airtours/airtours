import 'package:AirTours/services/cloud/cloud_flight.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../services/cloud/firestore_flight.dart';

class OneWaySearch extends StatefulWidget {
  final String from;
  final String to;
  final String flightClass;
  final int numOfPas;
  final DateTime date;

  const OneWaySearch({
    super.key,
    required this.from,
    required this.to,
    required this.flightClass,
    required this.numOfPas,
    required this.date,
  });

  @override
  State<OneWaySearch> createState() => _OneWaySearchState();
}

class _OneWaySearchState extends State<OneWaySearch> {
  late final FlightFirestore _flightsService;

  String _formatTime(Timestamp timestamp) {
    var date = timestamp.toDate();
    var format = DateFormat('h:mm a');
    return format.format(date);
  }

  @override
  void initState() {
    super.initState();
    _flightsService = FlightFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.blue[900],
            centerTitle: true,
            title: const Text('Flight Details',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ))),
        body: SafeArea(
            child: StreamBuilder(
          stream: _flightsService.allFlights(
              from: widget.from,
              to: widget.to,
              flightClass: widget.flightClass,
              numOfPas: widget.numOfPas,
              date: widget.date),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allFlights = snapshot.data as Iterable<CloudFlight>;
                  return ListView.builder(
                    itemCount: allFlights.length,
                    itemBuilder: (context, index) {
                      final flight = allFlights.elementAt(index);
                      return Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\$${flight.busPrice}',
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        _formatTime(flight.depTime),
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      Text(
                                        'Departure',
                                        style: TextStyle(
                                          fontSize: 10.0,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      SizedBox(height: 4.0),
                                      Text(
                                        _formatTime(flight.arrTime),
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      Text(
                                        'Arrival',
                                        style: TextStyle(
                                          fontSize: 10.0,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.0),
                              Row(
                                children: [
                                  Icon(Icons.flight_takeoff,
                                      color: Colors.grey[600]),
                                  SizedBox(width: 8.0),
                                  Text(
                                    '${flight.fromCity}',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.0),
                              Row(
                                children: [
                                  Icon(Icons.flight_land,
                                      color: Colors.grey[600]),
                                  SizedBox(width: 8.0),
                                  Text(
                                    '${flight.toCity}',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Text('No Available Flights');
                }

              default:
                return const CircularProgressIndicator();
            }
          },
        )));
  }
}
