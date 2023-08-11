import 'package:AirTours/services/cloud/cloud_booking.dart';
import 'package:AirTours/services/cloud/cloud_flight.dart';
import 'package:AirTours/services/cloud/cloud_ticket.dart';
import 'package:AirTours/services/cloud/firestore_ticket.dart';
import 'package:flutter/material.dart';

class TicketsView extends StatefulWidget {
  final CloudBooking booking;
  final CloudFlight flight;

  const TicketsView({
    Key? key,
    required this.booking,
    required this.flight,
  }) : super(key: key);

  @override
  State<TicketsView> createState() => _TicketsViewState();
}

class _TicketsViewState extends State<TicketsView> {
  late final TicketFirestore _ticketsService;
  late final String bookingId;
  late final String flightId;

  @override
  void initState() {
    super.initState();
    _ticketsService = TicketFirestore();
    flightId = widget.flight.documentId;
    bookingId = widget.booking.documentId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        title: const Text(
          'List of Tickets',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<Iterable<CloudTicket>>(
          stream: _ticketsService.allTickets(
              bookingId: bookingId, flightId: flightId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              final allTickets = snapshot.data!;
              return ListView.builder(
                itemCount: allTickets.length,
                itemBuilder: (context, index) {
                  final ticket = allTickets.elementAt(index);
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue[200]!, Colors.blue[100]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${ticket.firstName} ${ticket.lastName}',
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            const Text(
                              'Booking Reference',
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              ticket.bookingReference,
                              style: const TextStyle(
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            const Text(
                              'Flight Reference',
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              ticket.flightReference,
                              style: const TextStyle(
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            const Text(
                              'Ticket Price',
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$${ticket.ticketPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (ticket.checkInStatus) {
                                    // View boarding pass
                                  } else {
                                    final isChecked =
                                        await _ticketsService.checkInUpdating(
                                            ticket.documentId, flightId);
                                    print(isChecked);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[900],
                                ),
                                child: Text(
                                  ticket.checkInStatus
                                      ? 'View Boarding Pass'
                                      : 'Issue Boarding Pass',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
