import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_faded_web/Widgets/category_products.dart';
import 'package:cross_faded_web/Widgets/footer.dart';
import 'package:cross_faded_web/Widgets/header.dart';
import 'package:cross_faded_web/Widgets/essentials.dart';
import 'package:cross_faded_web/Widgets/loading_widget.dart';
import 'package:cross_faded_web/Widgets/mobile_drawer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductsByCategory extends StatelessWidget {
  final String categoryname;
  const ProductsByCategory({super.key, required this.categoryname});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return DesktopProductsByCategory(categoryname: categoryname);
        } else if (constraints.maxWidth > 800 && constraints.maxWidth <= 1200) {
          return DesktopProductsByCategory(categoryname: categoryname);
        } else {
          return MobileProductsByCategory(categoryname: categoryname);
        }
      },
    );
  }
}

class DesktopProductsByCategory extends StatelessWidget {
  final String categoryname;
  const DesktopProductsByCategory({super.key, required this.categoryname});

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
            DesktopCategoryProducts(categoryname: categoryname),
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

class MobileProductsByCategory extends StatelessWidget {
  final String categoryname;
  const MobileProductsByCategory({super.key, required this.categoryname});

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(symbol: " ");

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
                categoryname,
                style: GoogleFonts.raleway(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("products")
                    .where("category", isEqualTo: categoryname)
                    .snapshots(),
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return LoadingWidget();
                  }
                  if (!asyncSnapshot.hasData ||
                      asyncSnapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "No products found in this category",
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }

                  final docs = asyncSnapshot.data!.docs;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: docs.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.65,
                        ),
                    itemBuilder: (context, index) {
                      final prodId = docs[index].id;
                      final prodData =
                          docs[index].data() as Map<String, dynamic>;
                      final prodName = prodData['name'] ?? '';
                      final prodPrice = (prodData['price'] ?? 0.0).toDouble();
                      final dynamic prodImageUrls = prodData['imageUrls'];
                      final prodImage =
                          (prodImageUrls is List && prodImageUrls.isNotEmpty)
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
                                textAlign: TextAlign.center,
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
                  );
                },
              ),
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
}
