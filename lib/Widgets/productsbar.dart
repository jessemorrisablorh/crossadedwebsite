import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_faded_web/Widgets/essentials.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class DesktopProductsBar extends StatelessWidget {
  const DesktopProductsBar({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(left: 80.0, right: 80.0),
      child: Column(
        children: [
          Text(
            "Our Bestsellers",
            style: GoogleFonts.raleway(
              color: Colors.white,
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Collect your loves with our newest arrivals.",
            style: GoogleFonts.raleway(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 30),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            onTap: () {
              context.go('/shop');
            },
            child: Container(
              height: 0.060 * height,
              width: 0.17 * width,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(5),
              ),
              alignment: Alignment.center,
              child: Text(
                "View all products",
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 70),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("products")
                .snapshots(),
            builder: (context, asyncSnapshot) {
              return GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 4,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 2 / 3,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    onTap: () {
                      context.push(
                        '/product-details',
                        extra: asyncSnapshot.data!.docs[index]["id"],

                        // asyncSnapshot.data!.docs[index]["id"],
                      );
                    },
                    child: productsCard(
                      id: asyncSnapshot.data!.docs[index]["id"],
                      productimage: asyncSnapshot.data!.docs[index]["image"],
                      productname: asyncSnapshot.data!.docs[index]["name"],
                      productprice: asyncSnapshot.data!.docs[index]["price"],
                      height: height,
                      width: width,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class MobileProductsBar extends StatelessWidget {
  const MobileProductsBar({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        bottom: 50.0,
        top: 50.0,
      ),
      child: Column(
        children: [
          Text(
            "Our Bestsellers",
            style: GoogleFonts.raleway(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Collect your loves with our newest arrivals.",
            style: GoogleFonts.raleway(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 30),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            onTap: () {
              context.go('/shop');
            },
            child: Container(
              height: 0.060 * height,
              width: width,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(7),
              ),
              alignment: Alignment.center,
              child: Text(
                "View all products",
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 70),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("products")
                .snapshots(),
            builder: (context, asyncSnapshot) {
              return GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 4,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2 / 3.7,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    onTap: () {
                      context.push(
                        '/product-details',
                        extra: asyncSnapshot.data!.docs[index]["id"],

                        // asyncSnapshot.data!.docs[index]["id"],
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: [
                          Container(
                            height: 0.30 * height,
                            width: width,
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(
                                  asyncSnapshot.data!.docs[index]["image"],
                                ),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            asyncSnapshot.data!.docs[index]["name"],
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.aldrich(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "GHS ${asyncSnapshot.data!.docs[index]["price"]}",
                            style: GoogleFonts.aldrich(
                              color: Colors.amber,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          // SizedBox(height: 20),
                          // InkWell(
                          //   onTap: () {
                          //     // context.go('/contactus');
                          //   },
                          //   child: Container(
                          //     width: 0.10 * width,
                          //     height: 0.065 * height,
                          //     decoration: BoxDecoration(
                          //       color: Colors.amber,
                          //       borderRadius: BorderRadius.circular(25),
                          //       boxShadow: [
                          //         BoxShadow(
                          //           color: Colors.black38,
                          //           blurRadius: 7,
                          //           offset: Offset(1, 2),
                          //         ),
                          //       ],
                          //     ),
                          //     alignment: Alignment.center,
                          //     child: Text(
                          //       "View product",
                          //       style: GoogleFonts.mulish(
                          //         color: Colors.white,
                          //         fontWeight: FontWeight.bold,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
