import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:quote_app/home.dart';
import 'package:workmanager/workmanager.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void _initializeNotifications() async {
  const androidInitialize =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const initializationSettings =
      InitializationSettings(android: androidInitialize);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher,
      isInDebugMode: true); // Initialize WorkManager
  _initializeNotifications();
  startQuoteNotification(); // Start the periodic task
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await sendRandomQuoteNotification();
    return Future.value(true);
  });
}

// Start periodic task every 2 minutes
void startQuoteNotification() {
  Workmanager().registerPeriodicTask(
    'quote_notification_task', // Task identifier
    'fetch_random_quote', // Task name
    frequency: const Duration(minutes: 15), // Frequency set to 2 minutes
  );
}

Future<void> sendRandomQuoteNotification() async {
  String apiUrl = 'https://quotes.toscrape.com/';
  String quote = await fetchRandomQuote(apiUrl);

  var androidDetails = const AndroidNotificationDetails(
    'quote_channel',
    'Quote Notifications',
    channelDescription: 'This channel sends random quotes every 2 minutes',
    importance: Importance.high,
    priority: Priority.high,
  );

  var notificationDetails = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    0,
    'Random Quote',
    quote,
    notificationDetails,
  );
}

Future<String> fetchRandomQuote(String apiUrl) async {
  try {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final document = parse(response.body);
      final quotes = document
          .querySelectorAll('.quote'); // Assuming each quote has this class
      final randomQuote = quotes[Random().nextInt(quotes.length)];

      // Extracting the text of the quote
      final quoteText =
          randomQuote.querySelector('.text')?.text ?? 'No quote found';
      return quoteText;
    } else {
      throw Exception('Failed to load quote');
    }
  } catch (e) {
    print("Error fetching quote: $e");
    return 'Failed to fetch quote';
  }
}
