import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:AirTours/services/cloud/cloud_Ticket.dart';
import 'package:AirTours/constants/ticket_constants';

class TicketFirestore {
  final tickets = FirebaseFirestore.instance.collection('tickets');

  static final TicketFirestore _shared = TicketFirestore._sharedInstance();
  TicketFirestore._sharedInstance();
  factory TicketFirestore() => _shared;

  Future<CloudTicket> createNewTicket(
      {required documentId,
      required firstName,
      required middleName,
      required checkInStatus,
      required bagQuantity,
      required mealType,
      required lastName,
      required ticketPrice,
      required bookingReference,
      required ticketUserId,
      required birthDate,
      required flightReference,
      required ticketClass}) async {
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
      birthDateField: birthDate
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
        birthDate: birthDate,
        flightReference: flightReference,
        ticketClass: ticketClass);
  }
}
