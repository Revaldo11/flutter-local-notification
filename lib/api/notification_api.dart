import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/timezone.dart' as tz;

class NotificationApi {
  static final _notification = FlutterLocalNotificationsPlugin();

  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'your channel id',
        'your channel name',
        channelDescription: "your channel description",
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
      ),
    );
  }

  static Future<Map<String, dynamic>> fetchScheduleData() async {
    final response = await http.post(
        Uri.parse(
            'https://outsource.indohrm.com/index.php?r=apiInternal/dataToday&table=schedule'),
        body: {
          'token': 'ZSJK9ffB3A0UogUMRLg2HOrpRah5ES0A',
        });

    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load schedule data');
    }
  }

  static void scheduleNotificationFromApi() async {
    int id = 0;
    try {
      final scheduleData = await fetchScheduleData();

      final date = scheduleData['data']['date'];
      final scheduleIn = scheduleData['data']['schedule_in'];
      final scheduleOut = DateTime(2023, 11, 24, 9, 28);

      print("scheduleOut: $scheduleOut");

      final scheduleInDateTime =
          tz.TZDateTime.parse(tz.local, '$date $scheduleIn');
      final scheduleOutDateTime = scheduleOut;
      // final scheduleOutDateTime =
      //     tz.TZDateTime.parse(tz.local, '$date $scheduleOut');
      final currentTime = tz.TZDateTime.now(tz.local);
      print("currentTime: $currentTime");

      // Check if the schedule_in time is in the future
      if (scheduleOutDateTime.isAfter(currentTime)) {
        final notificationTimeIn =
            scheduleOutDateTime.subtract(const Duration(seconds: 10));
        print("notificationTimeIn: $notificationTimeIn");

        _notification.zonedSchedule(
          id,
          'Absensi Reminder',
          'Waktunya untuk absensi (schedule_in)!',
          tz.TZDateTime.from(notificationTimeIn, tz.local),
          await _notificationDetails(),
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true,
          payload: 'absensi_payload_in',
        );
      } else {
        print('Scheduled time_in is in the past.');
      }
    } catch (e) {
      print('Error scheduling notification: $e');
    }
  }
}
