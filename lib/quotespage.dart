import 'package:flutter/material.dart';
import 'package:quote_app/utils.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:auto_size_text/auto_size_text.dart';

class QuotesPage extends StatefulWidget {
  final String categoryname;
  QuotesPage(this.categoryname);

  @override
  State<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  List quotes = [];
  List authors = [];
  bool isDataThere = false;
  int currentPageIndex = 0;

  final List<Color> backgroundColors = [
    Colors.blueAccent.shade100,
    Colors.pinkAccent.shade100,
    Colors.greenAccent.shade100,
    Colors.orangeAccent.shade100,
    Colors.purpleAccent.shade100,
    Colors.tealAccent.shade100,
    Colors.redAccent.shade100,
    Colors.amberAccent.shade100,
    Colors.lightBlueAccent.shade100,
    Colors.lightGreenAccent.shade100,
    Colors.yellowAccent.shade100,
    Colors.cyanAccent.shade100,
    Colors.indigoAccent.shade100,
    Colors.deepPurpleAccent.shade100,
    Colors.deepOrangeAccent.shade100,
    Colors.limeAccent.shade100,
    Colors.brown.shade100,
    Colors.blueGrey.shade100,
    Colors.grey.shade200,
    Colors.cyan.shade200,
  ];

  @override
  void initState() {
    super.initState();
    getquotes();
  }

  getquotes() async {
    String url = "https://quotes.toscrape.com/tag/${widget.categoryname}/";
    Uri uri = Uri.parse(url);
    http.Response response = await http.get(uri);
    dom.Document document = parser.parse(response.body);
    final quotesclass = document.getElementsByClassName("quote");

    quotes = quotesclass
        .map((element) => element.getElementsByClassName('text')[0].innerHtml)
        .toList();

    authors = quotesclass
        .map((element) => element.getElementsByClassName('author')[0].innerHtml)
        .toList();

    setState(() {
      isDataThere = true;
    });
  }

  Color getTextColor(Color backgroundColor) {
    return backgroundColor.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isDataThere == false
          ? Center(child: CircularProgressIndicator())
          : PageView.builder(
              itemCount: quotes.length,
              onPageChanged: (index) {
                setState(() {
                  currentPageIndex = index % backgroundColors.length;
                });
              },
              itemBuilder: (context, index) {
                Color bgColor = backgroundColors[currentPageIndex];
                Color textColor = getTextColor(bgColor);

                return Container(
                  color: bgColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Card(
                      color: bgColor,
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AutoSizeText(
                              quotes[index],
                              style: textStyle(24, textColor, FontWeight.w700),
                              textAlign: TextAlign.center,
                              maxLines: 5, // Limits the number of lines
                              minFontSize:
                                  16, // Minimum font size to scale down to
                            ),
                            SizedBox(height: 20),
                            Text(
                              '- ${authors[index]}',
                              style: textStyle(18, textColor.withOpacity(0.7),
                                  FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
