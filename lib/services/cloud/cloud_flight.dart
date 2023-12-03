import 'package:AirTours/constants/flight_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFlight {
  final String documentId;
  final String fromCity;
  final String toCity;
  final String fromAirport;
  final String toAirport;
  final Timestamp depDate;
  final Timestamp arrDate;
  final Timestamp arrTime;
  final Timestamp depTime;
  final int numOfBusiness;
  final int numOfEco;
  final double ecoPrice;
  final double busPrice;
  final int numOfAvaBusiness;
  final int numOfAvaEco;

  CloudFlight({
    required this.documentId,
    required this.fromCity,
    required this.toCity,
    required this.fromAirport,
    required this.toAirport,
    required this.numOfBusiness,
    required this.numOfEco,
    required this.ecoPrice,
    required this.busPrice,
    required this.depDate,
    required this.arrDate,
    required this.arrTime,
    required this.depTime,
    required this.numOfAvaBusiness,
    required this.numOfAvaEco,
  });

  CloudFlight.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        fromCity = snapshot.data()[fromField] as String,
        toCity = snapshot.data()[toField] as String,
        fromAirport = snapshot.data()[fromAirField] as String,
        toAirport = snapshot.data()[toAirField] as String,
        ecoPrice = snapshot.data()[guePriceField] as double,
        busPrice = snapshot.data()[busPriceField] as double,
        numOfBusiness = snapshot.data()[numOfbusField] as int,
        numOfEco = snapshot.data()[numOfEcoField] as int,
        numOfAvaBusiness = snapshot.data()[numOfAvabusField] as int,
        numOfAvaEco = snapshot.data()[numOfAvaEcoField] as int,
        depDate = snapshot.data()[depDateField] as Timestamp,
        arrDate = snapshot.data()[arrDateField] as Timestamp,
        arrTime = snapshot.data()[arrTimeField] as Timestamp,
        depTime = snapshot.data()[depTimeField] as Timestamp;
}