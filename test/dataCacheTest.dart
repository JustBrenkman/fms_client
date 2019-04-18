import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fms_client/main.dart';
import 'package:fms_client/redux/app_data.dart';
import 'data.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    DataCache dataCache = new DataCache();
    Data data = new Data();
    dataCache.events = data.getMockEventData();
    dataCache.people = data.getMockPeopleData();

    dataCache.processData();
  });
}