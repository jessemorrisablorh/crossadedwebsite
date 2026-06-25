import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_faded_web/Widgets/essentials.dart';
import 'package:cross_faded_web/Widgets/footer.dart';
import 'package:cross_faded_web/Widgets/header.dart';
import 'package:cross_faded_web/Widgets/mobile_drawer.dart';
import 'package:cross_faded_web/Widgets/product_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailsPage extends StatelessWidget {
  final String id;

  const ProductDetailsPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return DesktopProductDetailsPage(id: id);
        } else if (constraints.maxWidth > 800 && constraints.maxWidth <= 1200) {
          return DesktopProductDetailsPage(id: id);
        } else {
          return MobileProductDetailsPage(id: id);
        }
      },
    );
  }
}

class DesktopProductDetailsPage extends StatelessWidget {
  final String id;

  const DesktopProductDetailsPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const DesktopHeader(),
            DesktopProductDetails(productid: id),
            const DesktopFooter(),
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

class MobileProductDetailsPage extends StatefulWidget {
  final String id;
  const MobileProductDetailsPage({super.key, required this.id});

  @override
  State<MobileProductDetailsPage> createState() =>
      _MobileProductDetailsPageState();
}

class _MobileProductDetailsPageState extends State<MobileProductDetailsPage> {
  final formatCurrency = NumberFormat.currency(symbol: " ");
  int _counter = 1;
  bool _isLoading = false;

  Future<void> _addToCart({
    required String productid,
    required String productname,
    required String productimage,
    required num productprice,
    required int quantity,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      showDialog(
        context: context,
        builder: (context) => const AuthenticationWidget(),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final docRef = FirebaseFirestore.instance.collection("cart").doc();
      await docRef.set({
        "id": docRef.id,
        "productid": productid,
        "productname": productname,
        "productimage": productimage,
        "price": productprice,
        "quantity": quantity,
        "uid": user.uid,
      });

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Item added to cart",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (kDebugMode) {
        print("Add to cart error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      endDrawer: MobileDrawer(),
      appBar: Header(),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("products")
            .doc(widget.id)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.amber),
            );
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text(
                'Product not found',
                style: GoogleFonts.poppins(color: Colors.white70),
              ),
            );
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final name = data['name'] ?? 'Product Details';
          final price = (data['price'] ?? 0.0).toDouble();
          final desc =
              data['description'] ??
              'Premium quality smoking accessory built to last.';
          final categoryName = data['categoryName'] ?? data['category'] ?? '';
          final dynamic imageUrls = data['imageUrls'];
          final List<String> urls = (imageUrls is List && imageUrls.isNotEmpty)
              ? List<String>.from(imageUrls)
              : [data['image'] ?? ''];

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Product details",
                    style: GoogleFonts.raleway(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Image Slider/Card
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: PageView.builder(
                        itemCount: urls.length,
                        itemBuilder: (context, index) {
                          final imgUrl = urls[index];
                          return imgUrl.isNotEmpty
                              ? Image.network(imgUrl, fit: BoxFit.contain)
                              : const Icon(
                                  Icons.image,
                                  color: Colors.white30,
                                  size: 80,
                                );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Product Title & Price
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "GHS ${formatCurrency.format(price)}",
                    style: GoogleFonts.aldrich(
                      color: Colors.amber,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Description
                  Text(
                    desc,
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Quantity Selector
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          if (_counter > 1) {
                            setState(() {
                              _counter--;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 8,
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                            ),
                          ),
                          child: const Icon(
                            Icons.remove,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        color: Colors.white,
                        child: Text(
                          "$_counter",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _counter++;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 8,
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                            ),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Add To Cart Button
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () => _addToCart(
                            productid: widget.id,
                            productname: name,
                            productimage: urls.first,
                            productprice: price,
                            quantity: _counter,
                          ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 3,
                            ),
                          )
                        : Text(
                            "Add to Cart",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                  ),
                  const SizedBox(height: 40),

                  // Similar Products Title
                  Text(
                    "Similar products",
                    style: GoogleFonts.raleway(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Similar Products Stream Grid
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("products")
                        .where("category", isEqualTo: categoryName)
                        .snapshots(),
                    builder: (context, asyncSnapshot) {
                      if (!asyncSnapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.amber),
                        );
                      }

                      final docs = asyncSnapshot.data!.docs
                          .where((d) => d.id != widget.id)
                          .toList();

                      if (docs.isEmpty) {
                        return Text(
                          "No similar products found.",
                          style: GoogleFonts.poppins(
                            color: Colors.white54,
                            fontSize: 13,
                          ),
                        );
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: docs.length > 2 ? 2 : docs.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.6,
                            ),
                        itemBuilder: (context, index) {
                          final prodId = docs[index].id;
                          final prodData =
                              docs[index].data() as Map<String, dynamic>;
                          final prodName = prodData['name'] ?? '';
                          final prodPrice = (prodData['price'] ?? 0.0)
                              .toDouble();
                          final dynamic prodImageUrls = prodData['imageUrls'];
                          final prodImage =
                              (prodImageUrls is List &&
                                  prodImageUrls.isNotEmpty)
                              ? prodImageUrls[0]
                              : (prodData['image'] ?? '');

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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.aldrich(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "GHS ${formatCurrency.format(prodPrice)}",
                                    style: GoogleFonts.aldrich(
                                      color: Colors.amber,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  const Footer(),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          launchUrl(
            Uri.parse(
              "https://wa.me/+1234567890?text=Hello,%20I%20have%20a%20question",
            ),
          );
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.message, color: Colors.white),
      ),
    );
  }
}
