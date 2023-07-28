import 'package:AirTours/constants/booking_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CloudBooking {
  final String documentId;
  final double bookingPrice;
  final String bookingClass;
  final String departureFlight;
  final String returnFlight;

  CloudBooking(
      {required this.documentId,
      required this.bookingPrice,
      required this.bookingClass,
      required this.departureFlight,
      required this.returnFlight});

  CloudBooking.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        bookingClass = snapshot.data()[bookingClassField] as String,
        bookingPrice = snapshot.data()[bookingPriceField] as double,
        returnFlight = snapshot.data()[returnFlightField] as String,
        departureFlight = snapshot.data()[departureFlightField] as String;
}
