import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quote_app/quotespage.dart';
import 'package:quote_app/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> categories = ["love", "inspirational", "life", "humor", "books"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 50),
              child: Text(
                "Quotes App",
                style: textStyle(25, Colors.black, FontWeight.w700),
              ),
            ),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: categories.map(
                (Category) {
                  return InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QuotesPage(Category))),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                            child: Center(
                          child: Text(
                            Category.toUpperCase(),
                            style: textStyle(20, Colors.black, FontWeight.bold),
                          ),
                        )),
                      ));
                },
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
