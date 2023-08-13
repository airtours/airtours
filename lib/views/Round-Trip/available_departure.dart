import 'package:AirTours/services/cloud/cloud_flight.dart';
import 'package:AirTours/views/Round-Trip/available_return.dart';
import 'package:flutter/material.dart';
import '../../services/cloud/firestore_flight.dart';

class RoundTripSearch1 extends StatefulWidget {
  final String from;
  final String to;
  final String flightClass;
  final int numOfPas;
  final DateTime depDate;
  final DateTime retDate;

  const RoundTripSearch1({
    super.key,
    required this.from,
    required this.to,
    required this.flightClass,
    required this.numOfPas,
    required this.depDate,
    required this.retDate,
  });

  @override
  State<RoundTripSearch1> createState() => _RoundTripSearch1State();
}

class _RoundTripSearch1State extends State<RoundTripSearch1> {
  late final FlightFirestore _flightsService;
  void toNext(CloudFlight flight1, double flightPrice1, String flightClass) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RoundTripSearch2(
                flight1: flight1,
                from: widget.to,
                flightPrice1: flightPrice1,
                to: widget.from,
                flightClass: flightClass,
                numOfPas: widget.numOfPas,
                depDate: widget.depDate,
                retDate: widget.retDate)));
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
            title: Text('${widget.from} to ${widget.to} ',
                style: const TextStyle(
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
              date: widget.depDate),
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
                      double flightText = widget.flightClass == 'business'
                          ? flight.busPrice
                          : flight.guestPrice;
                      DateTime flightDate = flight.depDate.toDate();
                      DateTime flightTime = flight.depTime.toDate();
                      DateTime totalFlightTime = DateTime(
                          flightDate.year,
                          flightDate.month,
                          flightDate.day,
                          flightTime.hour,
                          flightTime.minute);

                      if (DateTime.now().isBefore(totalFlightTime)) {
                        return GestureDetector(
                          onTap: () {
                            toNext(flight, flightText, widget.flightClass);
                          },
                          child: Card(
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
                                        '\$$flightText',
                                        style: const TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            _flightsService
                                                .formatTime(flight.depTime),
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
                                          const SizedBox(height: 4.0),
                                          Text(
                                            _flightsService
                                                .formatTime(flight.arrTime),
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
                                  const SizedBox(height: 16.0),
                                  Row(
                                    children: [
                                      Icon(Icons.flight_takeoff,
                                          color: Colors.grey[600]),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        flight.fromCity,
                                        style: const TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8.0),
                                  Row(
                                    children: [
                                      Icon(Icons.flight_land,
                                          color: Colors.grey[600]),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        flight.toCity,
                                        style: const TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  );
                } else {
                  return const CircularProgressIndicator();
                }

              default:
                return const CircularProgressIndicator();
            }
          },
        )));
  }
}
