import 'package:AirTours/services/cloud/cloud_flight.dart';
import 'package:AirTours/constants/flight_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
      numOfAvabusField: numOfBusiness,
      numOfAvaGueField: numOfGuest,
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
        depTime: depTime,
        numOfAvaBusiness: numOfBusiness,
        numOfAvaGuest: numOfBusiness);
  }

  String formatTime(Timestamp timestamp) {
    var date = timestamp.toDate();
    var format = DateFormat('h:mm a');
    return format.format(date);
  }

  Future<List<CloudFlight>> getFlights(
      String departureId, String returnId) async {
    List<CloudFlight> currFlights = [];

    final tempdepFlight = flights.doc(departureId);
    final fetchedFlight = await tempdepFlight.get();
    final depFlight = CloudFlight(
        documentId: fetchedFlight.id,
        fromCity: fetchedFlight.data()![fromField],
        toCity: fetchedFlight.data()![toField],
        fromAirport: fetchedFlight.data()![fromAirField],
        toAirport: fetchedFlight.data()![toAirField],
        numOfBusiness: fetchedFlight.data()![numOfbusField],
        numOfGuest: fetchedFlight.data()![numOfGueField],
        guestPrice: fetchedFlight.data()![guePriceField],
        busPrice: fetchedFlight.data()![busPriceField],
        depDate: fetchedFlight.data()![depDateField],
        arrDate: fetchedFlight.data()![arrDateField],
        arrTime: fetchedFlight.data()![arrTimeField],
        depTime: fetchedFlight.data()![depTimeField],
        numOfAvaBusiness: fetchedFlight.data()![numOfAvabusField],
        numOfAvaGuest: fetchedFlight.data()![numOfAvaGueField]);
    currFlights.add(depFlight);

    if (returnId != 'none') {
      final tempFlight = flights.doc(returnId);
      final fetchedFlight = await tempFlight.get();
      final retFlight = CloudFlight(
          documentId: fetchedFlight.id,
          fromCity: fetchedFlight.data()![fromField],
          toCity: fetchedFlight.data()![toField],
          fromAirport: fetchedFlight.data()![fromAirField],
          toAirport: fetchedFlight.data()![toAirField],
          numOfBusiness: fetchedFlight.data()![numOfbusField],
          numOfGuest: fetchedFlight.data()![numOfGueField],
          guestPrice: fetchedFlight.data()![guePriceField],
          busPrice: fetchedFlight.data()![busPriceField],
          depDate: fetchedFlight.data()![depDateField],
          arrDate: fetchedFlight.data()![arrDateField],
          arrTime: fetchedFlight.data()![arrTimeField],
          depTime: fetchedFlight.data()![depTimeField],
          numOfAvaBusiness: fetchedFlight.data()![numOfAvabusField],
          numOfAvaGuest: fetchedFlight.data()![numOfAvaGueField]);
      currFlights.add(retFlight);
    }
    return currFlights;
  }

  Future<bool> isCurrentFlight(String departureId, String returnId) async {
    if (returnId != 'none') {
      final tempFlight = flights.doc(returnId);
      final fetchedFlight = await tempFlight.get();

      if (fetchedFlight.exists) {
        DateTime flightDate = fetchedFlight.data()![arrDateField].toDate();
        DateTime flightTime = fetchedFlight.data()![arrTimeField].toDate();
        DateTime totalTime = DateTime(flightDate.year, flightDate.month,
            flightDate.day, flightTime.hour, flightTime.minute);

        if (totalTime.isAfter(DateTime.now())) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else if (returnId == 'none') {
      final tempFlight = flights.doc(departureId);
      final fetchedFlight = await tempFlight.get();

      if (fetchedFlight.exists) {
        DateTime flightDate = fetchedFlight.data()![depDateField].toDate();
        DateTime flightTime = fetchedFlight.data()![depTimeField].toDate();
        DateTime totalTime = DateTime(flightDate.year, flightDate.month,
            flightDate.day, flightTime.hour, flightTime.minute);
        print(totalTime);
        if (totalTime.isAfter(DateTime.now())) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
