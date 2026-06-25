import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_faded_web/Widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class DesktopCategoryProducts extends StatelessWidget {
  final String categoryname;
  const DesktopCategoryProducts({super.key, required this.categoryname});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(left: 80.0, right: 80.0, top: 100),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                categoryname,
                style: GoogleFonts.raleway(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          SizedBox(height: 70),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("products")
                .where("category", isEqualTo: categoryname)
                .snapshots(),
            builder: (context, asyncSnapshot) {
              if (!asyncSnapshot.hasData) {
                return LoadingWidget();
              }
              return GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: asyncSnapshot.data!.docs.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 2 / 3,
                ),
                itemBuilder: (context, index) {
                  return asyncSnapshot.data!.docs.isEmpty
                      ? Text(
                          "Empty",
                          style: GoogleFonts.poppins(color: Colors.white),
                        )
                      : InkWell(
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
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Container(
                                  height: 0.35 * height,
                                  width: 0.40 * width,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[900],
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        asyncSnapshot
                                            .data!
                                            .docs[index]["image"],
                                      ),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  asyncSnapshot.data!.docs[index]["name"],
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.aldrich(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "GHS ${asyncSnapshot.data!.docs[index]["price"]}",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.aldrich(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.w600,
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
        ],
      ),
    );
  }
}
