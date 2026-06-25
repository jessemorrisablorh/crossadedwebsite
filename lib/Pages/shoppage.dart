import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_faded_web/Widgets/essentials.dart';
import 'package:cross_faded_web/Widgets/footer.dart';
import 'package:cross_faded_web/Widgets/header.dart';
import 'package:cross_faded_web/Widgets/mobile_drawer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Shoppage extends StatelessWidget {
  const Shoppage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return const DesktopShopPage();
        } else if (constraints.maxWidth > 800 && constraints.maxWidth <= 1200) {
          return const DesktopShopPage();
        } else {
          return const MobileShopPage();
        }
      },
    );
  }
}

class DesktopShopPage extends StatefulWidget {
  const DesktopShopPage({super.key});

  @override
  State<DesktopShopPage> createState() => _DesktopShopPageState();
}

class _DesktopShopPageState extends State<DesktopShopPage> {
  final formatCurrency = NumberFormat.currency(symbol: " ");
  String selectedCategory = "";
  int currentPage = 0;
  final int itemsPerPage = 12; // 12 products per page
  final TextEditingController searchController = TextEditingController();

  List searchResults = [];
  bool showSuggestions = false;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            DesktopHeader(),
            Container(
              width: width,
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 80.0,
                  right: 80.0,
                  top: 80.0,
                  bottom: 80.0,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Our Shop",
                          style: GoogleFonts.raleway(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 0.70 * height,
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(50.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedCategory = "";
                                      });
                                    },
                                    child: Text(
                                      "All Categories",
                                      style: GoogleFonts.poppins(
                                        color: selectedCategory == ""
                                            ? Colors.amber
                                            : Colors.white,

                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection("categories")
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      final categories = snapshot.data!.docs;
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: categories.length,
                                        itemBuilder: (context, index) {
                                          final category = categories[index];
                                          return ListTile(
                                            title: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedCategory =
                                                      category["name"];
                                                });
                                              },
                                              child: Text(
                                                category["name"],
                                                style: GoogleFonts.poppins(
                                                  color:
                                                      selectedCategory ==
                                                          category["name"]
                                                      ? Colors.amber
                                                      : Colors.white,

                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              // Handle category tap
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Container(
                            //  height: 0.70 * height,
                            width: width,
                            decoration: BoxDecoration(
                              // color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: StreamBuilder(
                              stream: selectedCategory == ""
                                  ? FirebaseFirestore.instance
                                        .collection("products")
                                        .snapshots()
                                  : FirebaseFirestore.instance
                                        .collection("products")
                                        .where(
                                          "category",
                                          isEqualTo: selectedCategory,
                                        )
                                        .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                final products = snapshot.data!.docs;
                                final int totalPages =
                                    (products.length / itemsPerPage).ceil();

                                final int startIndex =
                                    currentPage * itemsPerPage;

                                final int endIndex =
                                    (startIndex + itemsPerPage) >
                                        products.length
                                    ? products.length
                                    : startIndex + itemsPerPage;

                                final List currentProducts = products.sublist(
                                  startIndex,
                                  endIndex,
                                );
                                return products.isEmpty
                                    ? Center(
                                        child: Text(
                                          "No products found",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      )
                                    : Column(
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
                                                      controller:
                                                          searchController,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                      decoration: InputDecoration(
                                                        hintText:
                                                            "Search products...",
                                                        hintStyle:
                                                            const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14,
                                                            ),
                                                        prefixIcon: const Icon(
                                                          Icons.search,
                                                          color: Colors.amber,
                                                        ),
                                                        filled: true,
                                                        fillColor: Colors
                                                            .grey
                                                            .shade900,
                                                        border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                        ),
                                                      ),
                                                      onChanged: (value) {
                                                        if (value
                                                            .trim()
                                                            .isEmpty) {
                                                          setState(() {
                                                            searchResults = [];
                                                            showSuggestions =
                                                                false;
                                                          });
                                                          return;
                                                        }

                                                        setState(() {
                                                          showSuggestions =
                                                              true;

                                                          searchResults = products.where((
                                                            product,
                                                          ) {
                                                            final name =
                                                                product["name"]
                                                                    .toString()
                                                                    .toLowerCase();

                                                            return name.contains(
                                                              value
                                                                  .toLowerCase(),
                                                            );
                                                          }).toList();
                                                        });
                                                      },
                                                    ),
                                                  ),

                                                  if (showSuggestions)
                                                    Container(
                                                      width: 400,
                                                      constraints:
                                                          const BoxConstraints(
                                                            maxHeight: 300,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Colors
                                                            .grey
                                                            .shade900,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                      ),
                                                      child: ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: searchResults
                                                            .length,
                                                        itemBuilder: (context, index) {
                                                          final product =
                                                              searchResults[index];

                                                          return ListTile(
                                                            leading: SizedBox(
                                                              width: 50,
                                                              height: 50,
                                                              child: Image.network(
                                                                product["image"],
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                            ),
                                                            title: Text(
                                                              product["name"],
                                                              style:
                                                                  const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                            ),
                                                            subtitle: Text(
                                                              "GHS ${formatCurrency.format(product["price"] ?? 0)}",
                                                              style:
                                                                  const TextStyle(
                                                                    color: Colors
                                                                        .amber,
                                                                  ),
                                                            ),
                                                            onTap: () {
                                                              searchController
                                                                      .text =
                                                                  product["name"];

                                                              setState(() {
                                                                showSuggestions =
                                                                    false;
                                                              });

                                                              context.push(
                                                                '/product-details',
                                                                extra:
                                                                    product["id"],
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
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 4,
                                                  childAspectRatio: 1 / 1.7,
                                                ),
                                            itemCount: currentProducts.length,
                                            itemBuilder: (context, index) {
                                              final product = products[index];
                                              return InkWell(
                                                splashColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                onTap: () {
                                                  context.push(
                                                    '/product-details',
                                                    extra: product["id"],
                                                  );
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    5.0,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        height: 0.35 * height,
                                                        width: 0.40 * width,
                                                        decoration: BoxDecoration(
                                                          color:
                                                              Colors.grey[900],
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                          image: DecorationImage(
                                                            image: NetworkImage(
                                                              product["image"],
                                                            ),
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 20),
                                                      Text(
                                                        product["name"] ??
                                                            "Product Name",
                                                        textAlign:
                                                            TextAlign.center,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            GoogleFonts.aldrich(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                      ),
                                                      SizedBox(height: 20),
                                                      Text(
                                                        "GHS ${formatCurrency.format(product["price"] ?? 0)}",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            GoogleFonts.aldrich(
                                                              color:
                                                                  Colors.amber,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          const SizedBox(height: 30),

                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                                onPressed:
                                                    currentPage < totalPages - 1
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
                                      );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            DesktopFooter(),
          ],
        ),
      ),
      floatingActionButton: floatingButtons(
        height: height,
        width: width,
        context: context,
      ),
    );
  }
}

class MobileShopPage extends StatefulWidget {
  const MobileShopPage({super.key});

  @override
  State<MobileShopPage> createState() => _MobileShopPageState();
}

class _MobileShopPageState extends State<MobileShopPage> {
  final formatCurrency = NumberFormat.currency(symbol: " ");
  String selectedCategory = "";
  int currentPage = 0;
  final int itemsPerPage = 8; // 8 products per page
  final TextEditingController searchController = TextEditingController();

  List searchResults = [];
  bool showSuggestions = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      endDrawer: MobileDrawer(),
      appBar: Header(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Our Shop",
                style: GoogleFonts.raleway(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Search Input
              _buildSearchInput(),
              const SizedBox(height: 25),

              // Category Horizontal List
              Text(
                "Categories",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildCategoriesRow(),
              const SizedBox(height: 25),

              // Product Feed
              _buildProductsFeed(height, width),
              const SizedBox(height: 40),
              const Footer(),
            ],
          ),
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

  Widget _buildSearchInput() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("products").snapshots(),
      builder: (context, snapshot) {
        final products = snapshot.hasData ? snapshot.data!.docs : [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              cursorColor: Colors.white,
              cursorHeight: 13,
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search products...",
                hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Colors.amber),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
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
                    final name = product["name"].toString().toLowerCase();
                    return name.contains(value.toLowerCase());
                  }).toList();
                });
              },
            ),
            if (showSuggestions && searchResults.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(maxHeight: 250),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final product = searchResults[index];
                    final dynamic imageUrls = product["image"];
                    final imageUrl = (imageUrls is List && imageUrls.isNotEmpty)
                        ? imageUrls[0]
                        : (product["image"] ?? '');
                    return ListTile(
                      leading: SizedBox(
                        width: 40,
                        height: 40,
                        child: imageUrl.isNotEmpty
                            ? Image.network(imageUrl, fit: BoxFit.contain)
                            : const Icon(Icons.image, color: Colors.white30),
                      ),
                      title: Text(
                        product["name"],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                      subtitle: Text(
                        "GHS ${formatCurrency.format(product["price"] ?? 0)}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 12,
                        ),
                      ),
                      onTap: () {
                        searchController.text = product["name"];
                        setState(() {
                          showSuggestions = false;
                        });
                        context.push('/product-details', extra: product.id);
                      },
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildCategoriesRow() {
    return SizedBox(
      height: 40,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("categories").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox();
          final categories = snapshot.data!.docs;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length + 1,
            itemBuilder: (context, index) {
              final isAll = index == 0;
              final catName = isAll
                  ? "All Categories"
                  : categories[index - 1]["name"];
              final isSelected = isAll
                  ? selectedCategory == ""
                  : selectedCategory == catName;

              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: ChoiceChip(
                  label: Text(
                    catName,

                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: Colors.amber,
                  backgroundColor: Colors.grey[900],
                  checkmarkColor: isSelected ? Colors.black : Colors.white,
                  onSelected: (selected) {
                    setState(() {
                      selectedCategory = isAll ? "" : catName;
                      currentPage = 0;
                    });
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildProductsFeed(double height, double width) {
    return StreamBuilder<QuerySnapshot>(
      stream: selectedCategory == ""
          ? FirebaseFirestore.instance.collection("products").snapshots()
          : FirebaseFirestore.instance
                .collection("products")
                .where("category", isEqualTo: selectedCategory)
                .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.amber),
          );
        }

        final products = snapshot.data!.docs;
        if (products.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: Text(
                "No products found",
                style: TextStyle(color: Colors.white54),
              ),
            ),
          );
        }

        final int totalPages = (products.length / itemsPerPage).ceil();
        final int startIndex = currentPage * itemsPerPage;
        final int endIndex = (startIndex + itemsPerPage) > products.length
            ? products.length
            : startIndex + itemsPerPage;
        final List currentProducts = products.sublist(startIndex, endIndex);

        return Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.6,
              ),
              itemCount: currentProducts.length,
              itemBuilder: (context, index) {
                final product = currentProducts[index];
                final prodId = product.id;
                final prodName = product["name"] ?? 'Product';
                final prodPrice = (product["price"] ?? 0.0).toDouble();
                final dynamic imageUrls = product["image"];
                final prodImage = (imageUrls is List && imageUrls.isNotEmpty)
                    ? imageUrls[0]
                    : (product["image"] ?? '');

                return InkWell(
                  onTap: () {
                    context.push('/product-details', extra: prodId);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: prodImage.isNotEmpty
                                  ? Image.network(
                                      prodImage,
                                      fit: BoxFit.contain,
                                    )
                                  : const Icon(
                                      Icons.image,
                                      color: Colors.white30,
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          prodName,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.aldrich(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "GHS ${formatCurrency.format(prodPrice)}",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.aldrich(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),

            // Pagination Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: currentPage > 0
                      ? () {
                          setState(() {
                            currentPage--;
                          });
                        }
                      : null,
                  icon: const Icon(Icons.chevron_left, color: Colors.amber),
                ),
                const SizedBox(width: 15),
                Text(
                  "Page ${currentPage + 1} of $totalPages",
                  style: GoogleFonts.aldrich(color: Colors.white, fontSize: 12),
                ),
                const SizedBox(width: 15),
                IconButton(
                  onPressed: currentPage < totalPages - 1
                      ? () {
                          setState(() {
                            currentPage++;
                          });
                        }
                      : null,
                  icon: const Icon(Icons.chevron_right, color: Colors.amber),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
