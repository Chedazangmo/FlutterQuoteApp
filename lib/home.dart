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
  List<String> filteredCategories = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredCategories = categories;
    searchController.addListener(() {
      filterCategories();
    });
  }

  // Method to filter categories based on search input
  void filterCategories() {
    setState(() {
      if (searchController.text.isEmpty) {
        filteredCategories =
            categories; // Show all categories if search is empty
      } else {
        filteredCategories = categories
            .where((category) => category
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
            .toList(); // Filter categories based on search input
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // Ensure content doesn't overlap with system UI
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for categories...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              // Display "Not Found" if no categories match search
              if (filteredCategories.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'No categories found!',
                    style: textStyle(18, Colors.red, FontWeight.w500),
                  ),
                ),
              // Quote Category Grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: filteredCategories.map(
                  (category) {
                    return InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuotesPage(category),
                        ),
                      ),
                      child: Material(
                        elevation: 5, // Apply elevation to give shadow effect
                        borderRadius:
                            BorderRadius.circular(20), // Rounded corners
                        color: const Color.fromARGB(255, 90, 89,
                            89), // Set background color (light grey)
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(20), // Rounded corners
                            color: Colors.grey[200], // Light grey background
                          ),
                          child: Center(
                            child: Text(
                              category.toUpperCase(),
                              style:
                                  textStyle(20, Colors.black, FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
