import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class QuoteService {
  Future<String> fetchRandomQuote(String apiUrl) async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final quotes = json.decode(response.body);
        final random = Random().nextInt(quotes.length);
        return quotes[random]
            ['quote']; // Adjust based on your API response format
      } else {
        throw Exception("Failed to load quote");
      }
    } catch (e) {
      throw Exception("Error fetching quote: $e");
    }
  }

  Future<void> sendRandomQuoteNotification(String apiUrl) async {
    try {
      String quote = await fetchRandomQuote(apiUrl);

      // Show notification
      var androidDetails = AndroidNotificationDetails(
        'quote_channel',
        'Quote Notifications',
        channelDescription: 'This channel sends random quotes every 2 minutes',
        importance: Importance.high,
        priority: Priority.high,
      );

      var notificationDetails = NotificationDetails(android: androidDetails);

      // Sending the notification with the quote
      await flutterLocalNotificationsPlugin.show(
        0,
        'Random Quote',
        quote,
        notificationDetails,
      );
    } catch (e) {
      print("Error fetching or sending quote: $e");
    }
  }
}
