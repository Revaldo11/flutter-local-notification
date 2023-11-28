import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/timezone.dart' as tz;

// class NotificationApi {
//   static final _notification = FlutterLocalNotificationsPlugin();

//   static Future _notificationDetails() async {
//     return const NotificationDetails(
//       android: AndroidNotificationDetails(
//         'your channel id',
//         'your channel name',
//         channelDescription: "your channel description",
//         importance: Importance.max,
//         priority: Priority.high,
//       ),
//     );
//   }

//   static Future<Map<String, dynamic>> fetchScheduleData() async {
//     try {
//       final response = await http.post(
//           Uri.parse(
//               'https://outsource.indohrm.com/index.php?r=apiInternal/dataToday&table=schedule'),
//           body: {
//             'token': 'vk0q6A6QSn0OXfhwIuxv8hm7NCJRkFwz',
//           });

//       if (response.statusCode == 200) {
//         print(response.body);
//         Fluttertoast.showToast(msg: "Schedule data fetched successfully");
//         return json.decode(response.body);
//       } else {
//         throw Exception('Failed to load schedule data');
//       }
//     } catch (e) {
//       print('Error fetching schedule data: $e');
//       Fluttertoast.showToast(msg: "Failed to load schedule data, $e");
//       rethrow;
//     }
//   }

//   static void scheduleNotificationFromApi() async {
//     try {
//       final scheduleData = await fetchScheduleData();

//       final id = scheduleData['data']['employee_id'];
//       final date = scheduleData['data']['date'];
//       final scheduleIn = scheduleData['data']['schedule_in'];
//       final scheduleOutHardDate = DateTime(2023, 11, 27, 18, 58);
//       // final scheduleOut = scheduleData['data']['schedule_out'];

//       final scheduleInDateTime =
//           tz.TZDateTime.parse(tz.local, '$date $scheduleIn');
//       final scheduleOutDateTime =
//           tz.TZDateTime.parse(tz.local, '$scheduleOutHardDate');
//       print("scheduleOutDateTime: $scheduleOutDateTime");
//       final currentTime = tz.TZDateTime.now(tz.local);
//       print("currentTime: $currentTime");

//       // Check if the schedule_in time is in the future
//       if (scheduleOutDateTime.isAfter(currentTime)) {
//         final notificationTimeIn =
//             scheduleOutDateTime.subtract(const Duration(seconds: 10));

//         await _notification.zonedSchedule(
//           id,
//           'Absensi Reminder',
//           'Jangan lupa untuk absensi pulang (($scheduleOutDateTime))',
//           tz.TZDateTime.from(notificationTimeIn, tz.local),
//           await _notificationDetails(),
//           uiLocalNotificationDateInterpretation:
//               UILocalNotificationDateInterpretation.absoluteTime,
//           androidAllowWhileIdle: true,
//           payload: 'absensi_payload_in',
//         );
//         Fluttertoast.showToast(msg: "Notification scheduled is in the future.");
//       } else {
//         print('Scheduled time_in is in the past.');
//         Fluttertoast.showToast(msg: "Scheduled time_in is in the past.");
//       }
//     } catch (e) {
//       print('Error scheduling notification: $e');
//       Fluttertoast.showToast(msg: "Error scheduling notification: $e");
//     }
//   }
// }

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
        icon: 'app_icon',
      ),
    );
  }

  static void showScheduleNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime schedule,
  }) async {
    _notification.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(schedule, tz.local),
      await _notificationDetails(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      payload: payload,
    );
  }
}
