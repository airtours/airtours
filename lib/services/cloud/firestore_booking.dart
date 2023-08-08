import 'package:AirTours/constants/flight_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:AirTours/services/cloud/cloud_booking.dart';
import 'package:AirTours/constants/booking_constants.dart';

class BookingFirestore {
  final bookings = FirebaseFirestore.instance.collection('bookings');
  final flights = FirebaseFirestore.instance.collection('flights');

  static final BookingFirestore _shared = BookingFirestore._sharedInstance();
  BookingFirestore._sharedInstance();
  factory BookingFirestore() => _shared;

  Stream<Iterable<CloudBooking>> allBookings({required String userId}) {
    final allBookings = bookings
        .where(bookingUserIdField, isEqualTo: userId)
        .snapshots()
        .map(
            (event) => event.docs.map((doc) => CloudBooking.fromSnapshot(doc)));
    return allBookings;
  }

  Future<CloudBooking> createNewBooking(
      {required bookingClass,
      required bookingPrice,
      required departureFlight,
      required returnFlight,
      required numOfSeats}) async {
    final document = await bookings.add({
      bookingClassField: bookingClass,
      bookingPriceField: bookingPrice,
      departureFlightField: departureFlight,
      returnFlightField: returnFlight
    });
    decreaseNumberOfSeats(departureFlight, numOfSeats, bookingClass);
    if (returnFlight != 'none') {
      decreaseNumberOfSeats(returnFlight, numOfSeats, bookingClass);
    }

    final fetchedBooking = await document.get();
    return CloudBooking(
        documentId: fetchedBooking.id,
        bookingPrice: bookingPrice,
        bookingClass: bookingClass,
        departureFlight: departureFlight,
        returnFlight: returnFlight);
  }

  Future<void> decreaseNumberOfSeats(
      String flightId, int numOfSeats, String flightClass) async {
    try {
      final tempFlight = flights.doc(flightId);
      final fetchedFlight = await tempFlight.get();

      if (flightClass == 'business') {
        int currentSeats = fetchedFlight.data()![numOfAvabusField];
        if (currentSeats > 0) {
          int newSeats = currentSeats - numOfSeats;
          tempFlight.update({numOfAvabusField: newSeats});
        }
      } else {
        int currentSeats = fetchedFlight.data()![numOfAvaGueField];
        if (currentSeats > 0) {
          int newSeats = currentSeats - numOfSeats;
          tempFlight.update({numOfAvaGueField: newSeats});
        }
      }
    } catch (e) {
      print('Error updating numberOfSeats field: $e');
    }
  }
}
