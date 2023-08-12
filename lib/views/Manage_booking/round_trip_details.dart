import 'package:AirTours/services/cloud/cloud_booking.dart';
import 'package:AirTours/services/cloud/cloud_flight.dart';
import 'package:AirTours/views/Manage_booking/tickets_view.dart';
import 'package:flutter/material.dart';

import '../../services/cloud/firestore_booking.dart';

class RoundTripDetails extends StatefulWidget {
  final CloudBooking booking;
  final CloudFlight depFlight;
  final CloudFlight retFlight;

  const RoundTripDetails({
    super.key,
    required this.booking,
    required this.depFlight,
    required this.retFlight,
  });

  @override
  State<RoundTripDetails> createState() => _RoundTripDetailsState();
}

class _RoundTripDetailsState extends State<RoundTripDetails> {
  late final BookingFirestore _bookingService;
  late final CloudFlight departFlight;
  late final CloudFlight retuFlight;
  late final CloudBooking currentBooking;

  @override
  void initState() {
    super.initState();
    _bookingService = BookingFirestore();
    departFlight = widget.depFlight;
    retuFlight = widget.retFlight;
    currentBooking = widget.booking;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TicketsView(
                        booking: widget.booking, flight: widget.depFlight),
                  ));
            },
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Destination Flight',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    children: [
                      const Icon(
                        Icons.flight_takeoff,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        widget.depFlight.fromCity,
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Icon(
                        Icons.flight_land,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        widget.depFlight.toCity,
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TicketsView(
                        booking: widget.booking, flight: widget.retFlight),
                  ));
            },
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Return Flight',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    children: [
                      const Icon(
                        Icons.flight_takeoff,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        widget.retFlight.fromCity,
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Icon(
                        Icons.flight_land,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        widget.retFlight.toCity,
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      bool result = await _bookingService.upgradeRoundTrip(
                          bookingId: currentBooking.documentId,
                          departureFlightId: departFlight.documentId,
                          returnFlightId: retuFlight.documentId,
                          numOfPas: currentBooking.numOfSeats);
                      print(result);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 24.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Upgrade Booking',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  ElevatedButton(
                    onPressed: () async {
                      bool result = await _bookingService.deleteBooking(
                          bookingId: currentBooking.documentId,
                          flightId1: departFlight.documentId,
                          flightId2: retuFlight.documentId,
                          flightClass: currentBooking.bookingClass,
                          numOfPas: currentBooking.numOfSeats);
                      print(result);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 24.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
