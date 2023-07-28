import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:AirTours/services/cloud/cloud_booking.dart';
import 'package:AirTours/constants/booking_constants.dart';

class BookingFirestore {
  final bookings = FirebaseFirestore.instance.collection('bookings');

  static final BookingFirestore _shared = BookingFirestore._sharedInstance();
  BookingFirestore._sharedInstance();
  factory BookingFirestore() => _shared;

  Future<CloudBooking> createNewBooking(
      {required bookingClass,
      required bookingPrice,
      required departureFlight,
      required returnFlight}) async {
    final document = await bookings.add({
      bookingClassField: bookingClass,
      bookingPriceField: bookingPrice,
      departureFlightField: departureFlight,
      returnFlightField: returnFlight
    });
    final fetchedBooking = await document.get();
    return CloudBooking(
        documentId: fetchedBooking.id,
        bookingPrice: bookingPrice,
        bookingClass: bookingClass,
        departureFlight: departureFlight,
        returnFlight: returnFlight);
  }
}
