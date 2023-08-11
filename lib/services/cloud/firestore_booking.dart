import 'package:AirTours/constants/flight_constants.dart';
import 'package:AirTours/services/cloud/cloud_ticket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:AirTours/services/cloud/cloud_booking.dart';
import 'package:AirTours/constants/booking_constants.dart';

import '../../constants/ticket_constants';

class BookingFirestore {
  final bookings = FirebaseFirestore.instance.collection('bookings');
  final flights = FirebaseFirestore.instance.collection('flights');
  final tickets = FirebaseFirestore.instance.collection('tickets');

  static final BookingFirestore _shared = BookingFirestore._sharedInstance();
  BookingFirestore._sharedInstance();
  factory BookingFirestore() => _shared;

  Future<bool> deleteBooking({
    required String bookingId,
    required String flightId1,
    required String flightId2,
    required String flightClass,
    required int numOfPas,
  }) async {
    try {
      bool flag = false;
      DateTime now = DateTime.now();
      final tmpBooking = flights.doc(bookingId);
      final tempFlight = flights.doc(flightId1);
      final fetchedFlight = await tempFlight.get();
      DateTime flightDate = fetchedFlight.data()![arrDateField].toDate();
      DateTime flightTime = fetchedFlight.data()![arrTimeField].toDate();
      DateTime totalTime = DateTime(flightDate.year, flightDate.month,
          flightDate.day, flightTime.hour, flightTime.minute);
      if (now.isBefore(totalTime)) {
        if (fetchedFlight.exists) {
          Duration timeDifference = totalTime.difference(now);

          if (timeDifference.inHours > 24) {
            await tmpBooking.delete();
            int currentBusiness = fetchedFlight.data()![numOfAvabusField];
            int currentGuest = fetchedFlight.data()![numOfAvaGueField];

            if (flightClass == 'business') {
              final int newBus = currentBusiness + numOfPas;
              await tempFlight.update({numOfbusField: newBus});
            } else {
              final int newGue = currentGuest + numOfPas;
              await tempFlight.update({numOfGueField: newGue});
            }
            flag = true; // Corrected assignment
            //roundtrip
            if (flightId2 != 'none') {
              final tempFlight2 = flights.doc(flightId2);
              final fetchedFlight2 = await tempFlight2.get();
              if (fetchedFlight2.exists) {
                int current2Business = fetchedFlight2.data()![numOfAvabusField];
                int current2Guest = fetchedFlight2.data()![numOfAvaGueField];
                if (flightClass == 'business') {
                  final int newBus = current2Business + numOfPas;
                  await tempFlight2.update({numOfbusField: newBus});
                } else {
                  final int newGue = current2Guest + numOfPas;
                  await tempFlight2.update({numOfGueField: newGue});
                }
              }
            }
          }
        }
      }
      return flag;
    } catch (e) {
      return false;
    }
  }

  Stream<Iterable<CloudBooking>> allBookings({required String bookingUserId}) {
    final allBookings = bookings
        .where(bookingUserIdField, isEqualTo: bookingUserId)
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
      required numOfSeats,
      required String bookingUserId}) async {
    final document = await bookings.add({
      bookingClassField: bookingClass,
      bookingPriceField: bookingPrice,
      departureFlightField: departureFlight,
      returnFlightField: returnFlight,
      bookingUserIdField: bookingUserId,
      numOfSeatsField: numOfSeats
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
        returnFlight: returnFlight,
        bookingUserId: bookingUserId,
        numOfSeats: numOfSeats);
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
          await tempFlight.update({numOfAvaGueField: newSeats});
        }
      }
    } catch (e) {
      print(e);
    }
  }

  // Future<void> deleteTicketsByBookingId(String bookingId) async {
  //   try {
  //     QuerySnapshot querySnapshot = await tickets
  //         .where(bookingReferenceField, isEqualTo: bookingId)
  //         .get();

  //     List<Future<CloudTicket>> deleteFutures = [];
  //     querySnapshot.docs.forEach((doc) {
  //       deleteFutures.add(doc.reference.delete());
  //     });

  //     // Wait for all the delete operations to complete
  //     await Future.wait(deleteFutures);

  //     print('Tickets with bookingId $bookingId deleted successfully');
  //   } catch (e) {
  //     print('Error deleting tickets: $e');
  //   }
  // }
}
