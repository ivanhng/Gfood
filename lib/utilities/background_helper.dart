/*import 'dart:isolate';

import 'dart:ui';
import 'package:gfood_app/components/data/models/restaurant.dart';
import 'package:gfood_app/components/data/services/api_services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gfood_app/utilities/notification_helper.dart';

final ReceivePort port = ReceivePort();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class BackgroundService {
  static BackgroundService? _instance;
  static const String _isolateName = 'isolate';
  static SendPort? _uiSendPort;

  BackgroundService._internal() {
    _instance = this;
  }

  factory BackgroundService() => _instance ?? BackgroundService._internal();

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(port.sendPort, _isolateName);
  }

  static Future<void> callback() async {
    final NotificationHelper notificationHelper = NotificationHelper();
    var result = await ApiService()
        .fetchRestaurants(); // Use fetchRestaurants instead of getRestaurantList
    await notificationHelper.showNotification(
      flutterLocalNotificationsPlugin,
      result as Restaurants,
    );

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}
*/