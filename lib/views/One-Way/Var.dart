import 'package:flutter/material.dart';

List<String> monthNames = [
  "jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec",
];
int count = 1;
List<String> passengerType = ['guest', 'business'];
String currentPassenger = passengerType[0];
DateTimeRange dateRange =
    DateTimeRange(start: DateTime.now(), end: DateTime.now());
DateTime dateTime = DateTime.now();

String? fromName;
String? toName;
List<String> flightName = [
  "Riyadh",
  "Jeddah",
];
final From = TextEditingController();
