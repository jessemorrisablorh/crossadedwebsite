import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_faded_web/Widgets/essentials.dart';
import 'package:cross_faded_web/Widgets/loading_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DesktopProductDetails extends StatefulWidget {
  final String productid;
  const DesktopProductDetails({super.key, required this.productid});

  @override
  State<DesktopProductDetails> createState() => _DesktopProductDetailsState();
}

class _DesktopProductDetailsState extends State<DesktopProductDetails> {
  final formatCurrency = NumberFormat.currency(symbol: " ");
  int counter = 1;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("products")
          .doc(widget.productid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoadingWidget();
        }
        return Padding(
          padding: const EdgeInsets.only(left: 80.0, right: 80.0, top: 50.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Product details",
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
                children: [
                  Expanded(
                    child: Container(
                      height: 0.60 * height,
                      width: width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(snapshot.data?["image"]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 0.60 * height,
                      width: width,
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    snapshot.data?["name"],
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "GHS ${formatCurrency.format(snapshot.data?["price"])}",
                                    style: GoogleFonts.aldrich(
                                      color: Colors.amber,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Premium herb grinders built for smooth grinding, durability, and the perfect session every time.",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 30),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (counter > 1) {
                                      setState(() {
                                        counter--;
                                      });
                                    }
                                  },
                                  child: Container(
                                    height: 0.060 * height,
                                    width: 0.040 * width,
                                    decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        bottomLeft: Radius.circular(5),
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.remove,
                                      color: Colors.black,
                                      size: 30,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 0.060 * height,
                                  width: 0.040 * width,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "$counter",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    if (counter >= 1) {
                                      setState(() {
                                        counter++;
                                      });
                                    }
                                  },
                                  child: Container(
                                    height: 0.060 * height,
                                    width: 0.040 * width,
                                    decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(5),
                                        bottomRight: Radius.circular(5),
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.black,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 40),

                            // Container(
                            //   height: 0.060 * height,
                            //   width: 0.17 * width,
                            //   decoration: BoxDecoration(
                            //     color: Colors.amber,
                            //     borderRadius: BorderRadius.circular(5),
                            //   ),
                            //   alignment: Alignment.center,
                            //   child: loading
                            //       ? SizedBox(
                            //           height: 14,
                            //           width: 14,
                            //           child: CircularProgressIndicator(
                            //             color: Colors.black,
                            //             strokeWidth: 3,
                            //           ),
                            //         )
                            //       : Text(
                            //           "Add to cart",
                            //           style: GoogleFonts.poppins(
                            //             color: Colors.black,
                            //             fontWeight: FontWeight.w600,
                            //             fontSize: 13,
                            //           ),
                            //         ),
                            // ),
                            addToCartButton(
                              loading: loading,
                              height: height,
                              width: width,
                              quantity: counter,
                              productid: snapshot.data?["id"],
                              productname: snapshot.data?["name"],
                              productimage: snapshot.data?["image"],
                              productprice: snapshot.data?["price"],
                              productquantity: counter,
                              context: context,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              Row(
                children: [
                  Text(
                    "Similar products",
                    style: GoogleFonts.raleway(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("products")
                    .where("category", isEqualTo: snapshot.data?["category"])
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
                              "jbkndlfkbs",
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
                              child: productsCard(
                                id: asyncSnapshot.data!.docs[index]["id"],
                                productimage:
                                    asyncSnapshot.data!.docs[index]["image"],
                                productname:
                                    asyncSnapshot.data!.docs[index]["name"],
                                productprice:
                                    asyncSnapshot.data!.docs[index]["price"],
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
      },
    );
  }

  Widget addToCartButton({
    required double height,
    required double width,
    required bool loading,
    required int quantity,
    required String productid,
    required String productname,
    required String productimage,
    required num productprice,
    required int productquantity,
    required BuildContext context,
  }) {
    return InkWell(
      onTap: () async {
        await addToCart(
          context: context,
          productid: productid,
          productname: productname,
          productimage: productimage,
          productprice: productprice,
          productquantity: productquantity,
          height: height,
          width: width,
        );
      },
      child: Container(
        height: 0.060 * height,
        width: 0.17 * width,
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(5),
        ),
        alignment: Alignment.center,
        child: loading
            ? SizedBox(
                height: 14,
                width: 14,
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 3,
                ),
              )
            : Text(
                "Add to cart",
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
      ),
    );
  }

  Future<void> addToCart({
    required String productid,
    required String productname,
    required String productimage,
    required num productprice,
    required int productquantity,
    required BuildContext context,
    required double height,
    required double width,
  }) async {
    if (FirebaseAuth.instance.currentUser == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AuthenticationWidget();
        },
      );
    } else {
      try {
        setState(() {
          loading = true;
        });
        DocumentReference documentReference = FirebaseFirestore.instance
            .collection("cart")
            .doc();
        await documentReference
            .set({
              "id": documentReference.id,
              "productid": productid,
              "productname": productname,
              "productimage": productimage,
              "price": productprice,
              "quantity": productquantity,
              "uid": FirebaseAuth.instance.currentUser!.uid,
            })
            .then((value) {
              setState(() {
                loading = false;
              });
              if (!context.mounted) return;
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
            });
      } catch (e) {
        setState(() {
          loading = false;
        });
        if (kDebugMode) {
          print("Error :: $e");
        }
      }
    }
  }
}
