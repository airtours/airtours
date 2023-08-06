import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:AirTours/services/cloud/cloud_ticket.dart';
import 'package:AirTours/constants/ticket_constants';

class TicketFirestore {
  final tickets = FirebaseFirestore.instance.collection('tickets');

  static final TicketFirestore _shared = TicketFirestore._sharedInstance();
  TicketFirestore._sharedInstance();
  factory TicketFirestore() => _shared;

  Future<CloudTicket> createNewTicket(
      {required String firstName,
      required String middleName,
      required bool checkInStatus,
      required int bagQuantity,
      required String mealType,
      required String lastName,
      required double ticketPrice,
      required String bookingReference,
      required String ticketUserId,
      required DateTime birthDate,
      required String flightReference,
      required String ticketClass}) async {
    Timestamp birthdateStamp = Timestamp.fromDate(birthDate);

    final document = await tickets.add({
      ticketClassField: ticketClass,
      ticketPriceField: ticketPrice,
      checkInStatusField: checkInStatus,
      flightRefField: flightReference,
      firstNameField: firstName,
      middleNameField: middleName,
      lastNameField: lastName,
      bagQuantityField: bagQuantity,
      mealTypeField: mealType,
      ticketUserIdField: ticketUserId,
      birthDateField: birthdateStamp,
      bookingReferenceField: bookingReference
    });
    final fetchedTicket = await document.get();
    return CloudTicket(
        documentId: fetchedTicket.id,
        firstName: firstName,
        middleName: middleName,
        checkInStatus: checkInStatus,
        bagQuantity: bagQuantity,
        mealType: mealType,
        lastName: lastName,
        ticketPrice: ticketPrice,
        bookingReference: bookingReference,
        ticketUserId: ticketUserId,
        birthDate: birthdateStamp,
        flightReference: flightReference,
        ticketClass: ticketClass);
  }
}
