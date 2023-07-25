import 'package:AirTours/services/cloud/cloud_flight.dart';
import 'package:AirTours/constants/flight_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FlightFirestore {
  final flights = FirebaseFirestore.instance.collection('flights');

  static final FlightFirestore _shared = FlightFirestore._sharedInstance();
  FlightFirestore._sharedInstance();
  factory FlightFirestore() => _shared;

  Stream<Iterable<CloudFlight>> allFlights({
    required String from,
    required String to,
    required String flightClass,
    required int numOfPas,
    required DateTime date,
  }) {
    Timestamp depDateStamp = Timestamp.fromDate(date);

    if (flightClass == 'business') {
      final allFlights = flights
          .where(fromField, isEqualTo: from)
          .where(toField, isEqualTo: to)
          .where(numOfbusField, isGreaterThanOrEqualTo: numOfPas)
          .where(depDateField, isEqualTo: depDateStamp)
          .snapshots()
          .map((event) =>
              event.docs.map((doc) => CloudFlight.fromSnapshot(doc)));

      return allFlights;
    } else {
      final allFlights = flights
          .where(fromField, isEqualTo: from)
          .where(toField, isEqualTo: to)
          .where(numOfGueField, isGreaterThanOrEqualTo: numOfPas)
          .where(depDateField, isEqualTo: depDateStamp)
          .snapshots()
          .map((event) =>
              event.docs.map((doc) => CloudFlight.fromSnapshot(doc)));
      return allFlights;
    }
  }

  Future<CloudFlight> createNewFlight({
    required fromCity,
    required toCity,
    required fromAirport,
    required toAirport,
    required numOfBusiness,
    required numOfGuest,
    required guestPrice,
    required busPrice,
    required depDate,
    required arrDate,
    required arrTime,
    required depTime,
  }) async {
    final document = await flights.add({
      fromField: fromCity,
      toField: toCity,
      fromAirField: fromAirport,
      toAirField: toAirport,
      numOfbusField: numOfBusiness,
      numOfGueField: numOfGuest,
      guePriceField: guestPrice,
      busPriceField: busPrice,
      depDateField: depDate,
      arrDateField: arrDate,
      arrTimeField: arrTime,
      depTimeField: depTime,
    });
    final fetchedFlight = await document.get();
    return CloudFlight(
        documentId: fetchedFlight.id,
        fromCity: fromCity,
        toCity: toCity,
        fromAirport: fromAirport,
        toAirport: toAirport,
        numOfBusiness: numOfBusiness,
        numOfGuest: numOfGuest,
        guestPrice: guestPrice,
        busPrice: busPrice,
        depDate: depDate,
        arrDate: arrDate,
        arrTime: arrTime,
        depTime: depTime);
  }
}
