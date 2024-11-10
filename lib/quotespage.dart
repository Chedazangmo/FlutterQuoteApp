import 'package:flutter/material.dart';
import 'package:quote_app/utils.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart'; // For Clipboard
import 'package:share_plus/share_plus.dart'; // For Sharing

class QuotesPage extends StatefulWidget {
  final String categoryname;
  const QuotesPage(this.categoryname, {super.key});

  @override
  State<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  List quotes = [];
  List authors = [];
  bool isDataThere = false;
  int currentPageIndex = 0;

  bool isBackgroundColor = true; // Default background option is color
  bool isBackgroundChanging = true;

  final List<Color> backgroundColors = [
    const Color.fromARGB(255, 227, 229, 231),
    const Color.fromARGB(255, 10, 147, 221),
    const Color.fromARGB(255, 12, 199, 37),
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

  final List<String> imageBackgrounds = [
    'assets/images/bg1.jpg',
    'assets/images/bg2.jpg',
    'assets/images/bg3.jpg',
    'assets/images/bg4.jpg',
    'assets/images/ng6.jpg',
    'assets/images/bg9.jpg',
    'assets/images/bg10.jpg',
    'assets/images/bg12.jpg',
    'assets/images/bg13.jpg',
    'assets/images/download.jpg',
    // Add more image paths as needed
  ];

  // New variable to hold selected background option (color or image)
  String selectedBackground = 'Color';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quotes - ${widget.categoryname}'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black, // Make the button's background black
                borderRadius:
                    BorderRadius.circular(8), // Optional: rounded corners
              ),
              child: DropdownButton<String>(
                dropdownColor:
                    Colors.black, // Set the dropdown background to black
                value: selectedBackground,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                style:
                    const TextStyle(color: Colors.white), // Dropdown text color
                underline: Container(), // Remove the default underline
                onChanged: (String? newValue) {
                  setState(() {
                    selectedBackground = newValue!;
                  });
                },
                items: <String>['Color', 'Image', 'Default']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: Colors.white)),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      body: isDataThere == false
          ? const Center(child: CircularProgressIndicator())
          : PageView.builder(
              itemCount: quotes.length,
              onPageChanged: (index) {
                if (isBackgroundChanging) {
                  setState(() {
                    currentPageIndex = index % backgroundColors.length;
                  });
                }
              },
              itemBuilder: (context, index) {
                Widget backgroundWidget;

                if (selectedBackground == 'Color') {
                  Color bgColor = isBackgroundChanging
                      ? backgroundColors[currentPageIndex]
                      : backgroundColors[0];
                  backgroundWidget = Container(
                    color: bgColor,
                  );
                } else if (selectedBackground == 'Image') {
                  String imageUrl =
                      imageBackgrounds[index % imageBackgrounds.length];
                  backgroundWidget = isBackgroundChanging
                      ? Image.asset(
                          imageUrl,
                          fit: BoxFit
                              .cover, // Ensures the image covers the entire screen
                          width: double.infinity,
                          height: double.infinity,
                          alignment: Alignment.center,
                        )
                      : Image.asset(
                          imageUrl,
                          fit: BoxFit
                              .cover, // Ensures the image covers the entire screen
                          width: double.infinity,
                          height: double.infinity,
                          alignment: Alignment.center,
                        );
                } else {
                  backgroundWidget = Container(
                    color: Colors.white,
                  );
                }

                return Stack(
                  children: [
                    backgroundWidget,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Card(
                        elevation: 10,
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AutoSizeText(
                                quotes[index],
                                style: textStyle(
                                    24, Colors.white, FontWeight.w700),
                                textAlign: TextAlign.center,
                                maxLines: 5,
                                minFontSize: 16,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                '- ${authors[index]}',
                                style: textStyle(
                                    18,
                                    Colors.white.withOpacity(0.7),
                                    FontWeight.w400),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.copy,
                                        color: Colors.white.withOpacity(0.7)),
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(
                                          text:
                                              '${quotes[index]} - ${authors[index]}'));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "Quote copied to clipboard!"),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.share,
                                        color: Colors.white.withOpacity(0.7)),
                                    onPressed: () {
                                      Share.share(
                                          '${quotes[index]} - ${authors[index]}');
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
