import 'package:AirTours/views/Manage_booking/one_way_details.dart';
import 'package:AirTours/views/Manage_booking/round_trip_details.dart';
import 'package:AirTours/views/Round-Trip/round_trip.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/cloud/cloud_booking.dart';
import '../../services/cloud/cloud_flight.dart';
import '../../services/cloud/firestore_booking.dart';
import '../../services/cloud/firestore_flight.dart';

class ViewBookings extends StatefulWidget {
  const ViewBookings({super.key});

  @override
  State<ViewBookings> createState() => _ViewBookingsState();
}

class _ViewBookingsState extends State<ViewBookings> {
  late final BookingFirestore _bookingService;
  late final FlightFirestore _flightsService;
  FirebaseAuth auth = FirebaseAuth.instance;
  late final List<CloudFlight> allFlights;
  CloudFlight? returnFlight;
  CloudFlight? departureFlight;
  @override
  void initState() {
    super.initState();
    _bookingService = BookingFirestore();
    _flightsService = FlightFirestore();
  }

  Future<List<CloudBooking>> filterCurrentBookings(
      Iterable<CloudBooking> bookings) async {
    final List<CloudBooking> currentBookings = [];

    for (final booking in bookings) {
      final isCurrent = await _flightsService.isCurrentFlight(
        booking.departureFlight,
        booking.returnFlight,
      );

      if (isCurrent) {
        currentBookings.add(booking);
      }
    }

    return currentBookings;
  }

  void toNext(
      CloudFlight retFlight, CloudFlight depFlight, CloudBooking booking) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RoundTripDetails(
                booking: booking, depFlight: depFlight, retFlight: retFlight)));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Iterable<CloudBooking>>(
      stream: _bookingService.allBookings(bookingUserId: auth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            final allBookings = snapshot.data as Iterable<CloudBooking>;

            return FutureBuilder<List<CloudBooking>>(
              future: filterCurrentBookings(allBookings),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  final currentBookings = snapshot.data!;

                  return ListView.builder(
                    itemCount: currentBookings.length,
                    itemBuilder: (context, index) {
                      final booking = currentBookings[index];

                      return FutureBuilder<List<CloudFlight>>(
                        future: _flightsService.getFlights(
                            booking.departureFlight, booking.returnFlight),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasData) {
                            final flights = snapshot.data!;

                            final departureFlight = flights[0];
                            if (flights.length > 1) {
                              returnFlight = flights[1];
                            }

                            return GestureDetector(
                              onTap: () {
                                if (booking.returnFlight == 'none') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OneWayDetails(
                                          booking: booking,
                                          depFlight: departureFlight),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RoundTripDetails(
                                          booking: booking,
                                          depFlight: departureFlight,
                                          retFlight: returnFlight!),
                                    ),
                                  );
                                }
                              },
                              child: Card(
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '\$${booking.bookingPrice}',
                                            style: const TextStyle(
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              SizedBox(height: 4.0),
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
                                            "${departureFlight.fromCity} to ${departureFlight.toCity}",
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
                                          if (booking.returnFlight == 'none')
                                            const Text(
                                              "",
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          if (booking.returnFlight != 'none')
                                            Text(
                                              "${returnFlight!.fromCity} to ${returnFlight!.toCity}",
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
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return const Text('No data');
                          }
                        },
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const Text('No data');
                }
              },
            );
          } else {
            return const Text('Not Available');
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
