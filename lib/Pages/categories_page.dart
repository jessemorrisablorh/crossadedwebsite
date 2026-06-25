import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_faded_web/Widgets/footer.dart';
import 'package:cross_faded_web/Widgets/header.dart';
import 'package:cross_faded_web/Widgets/essentials.dart';
import 'package:cross_faded_web/Widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return const DesktopCategoriesPage();
        } else if (constraints.maxWidth > 800 && constraints.maxWidth <= 1200) {
          return const DesktopCategoriesPage();
        } else {
          return const MobileCategoriesPage();
        }
      },
    );
  }
}

class DesktopCategoriesPage extends StatefulWidget {
  const DesktopCategoriesPage({super.key});

  @override
  State<DesktopCategoriesPage> createState() => _DesktopCategoriesPageState();
}

class _DesktopCategoriesPageState extends State<DesktopCategoriesPage> {
  int currentPage = 0;
  final int itemsPerPage = 12; // 12 products per page
  final TextEditingController searchController = TextEditingController();

  List searchResults = [];
  bool showSuggestions = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 70.0, top: 50.0),
              child: Row(
                children: [
                  Text(
                    "Categories",
                    style: GoogleFonts.raleway(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('categories')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return LoadingWidget();
                }
                final products = snapshot.data!.docs;
                final int totalPages = (products.length / itemsPerPage).ceil();

                final int startIndex = currentPage * itemsPerPage;

                final int endIndex =
                    (startIndex + itemsPerPage) > products.length
                    ? products.length
                    : startIndex + itemsPerPage;

                final List currentProducts = products.sublist(
                  startIndex,
                  endIndex,
                );
                return Padding(
                  padding: const EdgeInsets.only(
                    left: 70.0,
                    right: 50.0,
                    top: 30.0,
                    bottom: 80.0,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                width: 400,
                                child: TextFormField(
                                  cursorColor: Colors.white,
                                  cursorHeight: 13,
                                  controller: searchController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: "Search categories...",
                                    hintStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.search,
                                      color: Colors.amber,
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade900,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    if (value.trim().isEmpty) {
                                      setState(() {
                                        searchResults = [];
                                        showSuggestions = false;
                                      });
                                      return;
                                    }

                                    setState(() {
                                      showSuggestions = true;

                                      searchResults = products.where((product) {
                                        final name = product["name"]
                                            .toString()
                                            .toLowerCase();

                                        return name.contains(
                                          value.toLowerCase(),
                                        );
                                      }).toList();
                                    });
                                  },
                                ),
                              ),

                              if (showSuggestions)
                                Container(
                                  width: 400,
                                  constraints: const BoxConstraints(
                                    maxHeight: 300,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade900,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: searchResults.length,
                                    itemBuilder: (context, index) {
                                      final product = searchResults[index];

                                      return ListTile(
                                        leading: SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: Image.network(
                                            product["image"],
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        title: Text(
                                          product["name"],
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "",
                                          // "GHS ${formatCurrency.format(product["price"] ?? 0)}",
                                          style: const TextStyle(
                                            color: Colors.amber,
                                          ),
                                        ),
                                        onTap: () {
                                          searchController.text =
                                              product["name"];

                                          setState(() {
                                            showSuggestions = false;
                                          });

                                          context.push(
                                            '/products-by-category',
                                            extra: product["name"],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: currentProducts.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            onTap: () {
                              context.push(
                                '/products-by-category',
                                extra: snapshot.data!.docs[index]["name"],
                              );
                            },
                            child: categoriesCard(
                              id: snapshot.data!.docs[index]["id"],
                              image: snapshot.data!.docs[index]["image"],
                              name: snapshot.data!.docs[index]["name"],
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                            ),
                          );
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 2 / 2.5,
                        ),
                      ),
                      const SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: currentPage > 0
                                ? () {
                                    setState(() {
                                      currentPage--;
                                    });
                                  }
                                : null,
                            child: const Text("Previous"),
                          ),

                          const SizedBox(width: 20),

                          Text(
                            "Page ${currentPage + 1} of $totalPages",
                            style: GoogleFonts.aldrich(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(width: 20),

                          ElevatedButton(
                            onPressed: currentPage < totalPages - 1
                                ? () {
                                    setState(() {
                                      currentPage++;
                                    });
                                  }
                                : null,
                            child: Text(
                              "Next",
                              style: GoogleFonts.aldrich(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            Footer(),
          ],
        ),
      ),
      floatingActionButton: floatingButtons(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        context: context,
      ),
    );
  }
}

class MobileCategoriesPage extends StatefulWidget {
  const MobileCategoriesPage({super.key});

  @override
  State<MobileCategoriesPage> createState() => _MobileCategoriesPageState();
}

class _MobileCategoriesPageState extends State<MobileCategoriesPage> {
  int currentPage = 0;
  final int itemsPerPage = 12; // 12 products per page
  final TextEditingController searchController = TextEditingController();

  List searchResults = [];
  bool showSuggestions = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Row(
                children: [
                  Text(
                    "Categories",
                    style: GoogleFonts.raleway(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('categories')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return LoadingWidget();
                }
                final products = snapshot.data!.docs;
                final int totalPages = (products.length / itemsPerPage).ceil();

                final int startIndex = currentPage * itemsPerPage;

                final int endIndex =
                    (startIndex + itemsPerPage) > products.length
                    ? products.length
                    : startIndex + itemsPerPage;

                final List currentProducts = products.sublist(
                  startIndex,
                  endIndex,
                );
                return Padding(
                  padding: const EdgeInsets.only(
                    left: 15.0,
                    right: 15.0,
                    top: 20.0,
                    bottom: 80.0,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 400,
                                  child: TextFormField(
                                    cursorColor: Colors.white,
                                    cursorHeight: 13,
                                    controller: searchController,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: "Search categories...",
                                      hintStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.search,
                                        color: Colors.amber,
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey.shade900,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      if (value.trim().isEmpty) {
                                        setState(() {
                                          searchResults = [];
                                          showSuggestions = false;
                                        });
                                        return;
                                      }

                                      setState(() {
                                        showSuggestions = true;

                                        searchResults = products.where((
                                          product,
                                        ) {
                                          final name = product["name"]
                                              .toString()
                                              .toLowerCase();

                                          return name.contains(
                                            value.toLowerCase(),
                                          );
                                        }).toList();
                                      });
                                    },
                                  ),
                                ),

                                if (showSuggestions)
                                  Container(
                                    width: 400,
                                    constraints: const BoxConstraints(
                                      maxHeight: 300,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade900,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: searchResults.length,
                                      itemBuilder: (context, index) {
                                        final product = searchResults[index];

                                        return ListTile(
                                          leading: SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: Image.network(
                                              product["image"],
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          title: Text(
                                            product["name"],
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          subtitle: Text(
                                            "",
                                            // "GHS ${formatCurrency.format(product["price"] ?? 0)}",
                                            style: const TextStyle(
                                              color: Colors.amber,
                                            ),
                                          ),
                                          onTap: () {
                                            searchController.text =
                                                product["name"];

                                            setState(() {
                                              showSuggestions = false;
                                            });

                                            context.push(
                                              '/products-by-category',
                                              extra: product["name"],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final categoryName =
                              snapshot.data!.docs[index]["name"];
                          return InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            onTap: () {
                              context.push(
                                '/products-by-category',
                                extra: snapshot.data!.docs[index]["name"],
                              );
                            },
                            child: mobilecategoriesCard(
                              id: snapshot.data!.docs[index]["id"],
                              image: snapshot.data!.docs[index]["image"],
                              name: snapshot.data!.docs[index]["name"],
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                            ),
                          );
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2 / 3.3,
                        ),
                      ),
                      const SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: currentPage > 0
                                ? () {
                                    setState(() {
                                      currentPage--;
                                    });
                                  }
                                : null,
                            child: const Text("Previous"),
                          ),

                          const SizedBox(width: 20),

                          Text(
                            "Page ${currentPage + 1} of $totalPages",
                            style: GoogleFonts.aldrich(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(width: 20),

                          ElevatedButton(
                            onPressed: currentPage < totalPages - 1
                                ? () {
                                    setState(() {
                                      currentPage++;
                                    });
                                  }
                                : null,
                            child: Text(
                              "Next",
                              style: GoogleFonts.aldrich(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            Footer(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Future<void> openWhatsApp() async {
            final Uri url = Uri.parse("https://wa.me/543236328?text=Hello");

            await launchUrl(url, mode: LaunchMode.externalApplication);
          }

          openWhatsApp();
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.message, color: Colors.white),
      ),
    );
  }
}
