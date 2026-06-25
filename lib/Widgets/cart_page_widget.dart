// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_faded_web/Widgets/essentials.dart';
import 'package:cross_faded_web/Widgets/loading_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DesktopCartPageWidget extends StatefulWidget {
  const DesktopCartPageWidget({super.key});

  @override
  State<DesktopCartPageWidget> createState() => _DesktopCartPageWidgetState();
}

class _DesktopCartPageWidgetState extends State<DesktopCartPageWidget> {
  final formatCurrency = NumberFormat.currency(symbol: " ");
  TextEditingController note = TextEditingController();
  List<Map<String, dynamic>> cartItems = [];
  bool ordering = false;
  num total = 0;
  Future<void> getTotal() async {
    total = 0;
    await FirebaseFirestore.instance
        .collection("cart")
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
          for (var element in value.docs) {
            setState(() {
              total += element["price"] * element["quantity"] as int;
            });
          }
        });
  }

  Future<void> fetchCartDetails() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("cart")
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    cartItems = snapshot.docs.map((doc) {
      return {"id": doc.id, ...doc.data()};
    }).toList();

    setState(() {}); // refresh UI if needed
  }

  @override
  void initState() {
    super.initState();
    getTotal();
    fetchCartDetails();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("cart")
          .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
                    "Cart",
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
                  Expanded(
                    child: Container(
                      width: width,
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        snapshot
                                            .data!
                                            .docs[index]["productimage"],
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        snapshot
                                            .data!
                                            .docs[index]["productname"],
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Text(
                                            "Quantity:   ",
                                            style: GoogleFonts.aldrich(
                                              color: Colors.amber,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            "${snapshot.data!.docs[index]["quantity"]}",
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Text(
                                            "Price:   ",
                                            style: GoogleFonts.aldrich(
                                              color: Colors.amber,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            "GHS ${formatCurrency.format(snapshot.data!.docs[index]["price"])}",
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Text(
                                            "Total Price:   ",
                                            style: GoogleFonts.aldrich(
                                              color: Colors.amber,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),

                                          Text(
                                            "${snapshot.data!.docs[index]["quantity"]} X ${snapshot.data!.docs[index]["price"]}  =  ",
                                            style: GoogleFonts.aldrich(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),

                                          Text(
                                            "GHS ${formatCurrency.format(snapshot.data!.docs[index]["price"] * snapshot.data!.docs[index]["quantity"])}",
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    await FirebaseFirestore.instance
                                        .collection("cart")
                                        .doc(snapshot.data!.docs[index]["id"])
                                        .delete()
                                        .then((value) async {
                                          setState(() {
                                            total = 0;
                                          });

                                          await getTotal();
                                        });
                                  },
                                  child: Icon(
                                    Icons.delete_forever,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                top: 10.0,
                                bottom: 10.0,
                              ),
                              child: Divider(color: Colors.grey),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      width: width,
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Total:  ",
                                  style: GoogleFonts.raleway(
                                    color: Colors.grey,
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "GHS ${formatCurrency.format(total)}",

                                  style: GoogleFonts.aldrich(
                                    color: Colors.amber,
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return StatefulBuilder(
                                          builder: (context, setState) {
                                            return Dialog(
                                              child: Container(
                                                width: 0.35 * width,
                                                height: 0.81 * height,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[900],
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        left: 50.0,
                                                        right: 50.0,
                                                        top: 50.0,
                                                        bottom: 50.0,
                                                      ),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            "Order Confirmation",
                                                            style:
                                                                GoogleFonts.raleway(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder: (context) {
                                                                  return EditBillingInformation();
                                                                },
                                                              ); // Navigate to edit account information page
                                                            },
                                                            child: Text(
                                                              "Edit",
                                                              style: GoogleFonts.poppins(
                                                                color: Colors
                                                                    .amber,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 10),
                                                      Divider(
                                                        color: Colors.grey,
                                                      ),
                                                      SizedBox(height: 10),
                                                      StreamBuilder(
                                                        stream: FirebaseFirestore
                                                            .instance
                                                            .collection("users")
                                                            .doc(
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid,
                                                            )
                                                            .snapshots(),
                                                        builder: (context, snapshot) {
                                                          if (!snapshot
                                                              .hasData) {
                                                            return Text(
                                                              "Loading",
                                                              style: GoogleFonts.poppins(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            );
                                                          }
                                                          return Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "First name",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: GoogleFonts.poppins(
                                                                      color: Colors
                                                                          .amber,
                                                                      fontSize:
                                                                          11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),

                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    snapshot
                                                                        .data?["firstname"],
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: GoogleFonts.poppins(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          13,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "Last name",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: GoogleFonts.poppins(
                                                                      color: Colors
                                                                          .amber,
                                                                      fontSize:
                                                                          11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    snapshot
                                                                        .data?["lastname"],
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: GoogleFonts.poppins(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          13,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "Phone number",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: GoogleFonts.poppins(
                                                                      color: Colors
                                                                          .amber,
                                                                      fontSize:
                                                                          11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    snapshot
                                                                        .data?["phone"],
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: GoogleFonts.poppins(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          13,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "Address",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: GoogleFonts.poppins(
                                                                      color: Colors
                                                                          .amber,
                                                                      fontSize:
                                                                          11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    snapshot
                                                                        .data?["address"],
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: GoogleFonts.poppins(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          13,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "Region",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: GoogleFonts.poppins(
                                                                      color: Colors
                                                                          .amber,
                                                                      fontSize:
                                                                          11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    snapshot
                                                                        .data?["region"],
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: GoogleFonts.poppins(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          13,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "City",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: GoogleFonts.poppins(
                                                                      color: Colors
                                                                          .amber,
                                                                      fontSize:
                                                                          11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Text(
                                                                snapshot
                                                                    .data?["city"],
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: GoogleFonts.poppins(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                              Container(
                                                                width: width,
                                                                height:
                                                                    0.10 *
                                                                    height,
                                                                decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        5,
                                                                      ),
                                                                  color: Colors
                                                                      .grey[300],
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets.all(
                                                                        15.0,
                                                                      ),
                                                                  child: TextField(
                                                                    controller:
                                                                        note,
                                                                    cursorColor:
                                                                        Colors
                                                                            .black,
                                                                    cursorHeight:
                                                                        13,
                                                                    style: GoogleFonts.poppins(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          13,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                    maxLines:
                                                                        20,
                                                                    decoration: InputDecoration(
                                                                      border: InputBorder
                                                                          .none,
                                                                      hintText:
                                                                          "Note",
                                                                      hintStyle: GoogleFonts.poppins(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                              Divider(
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "Payment method",
                                                                    style: GoogleFonts.poppins(
                                                                      color: Colors
                                                                          .amber,
                                                                      fontSize:
                                                                          11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Text(
                                                                "Cash On Delivery",
                                                                style: GoogleFonts.poppins(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 30,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () async {
                                                                      if (snapshot.data?["firstname"] ==
                                                                              "" ||
                                                                          snapshot.data?["lastname"] ==
                                                                              "" ||
                                                                          snapshot
                                                                              .data?["address"] ||
                                                                          snapshot.data?["region"] ==
                                                                              "" ||
                                                                          snapshot.data?["city"] ==
                                                                              "" ||
                                                                          snapshot.data?["phone"] ==
                                                                              "") {
                                                                        ScaffoldMessenger.of(
                                                                          context,
                                                                        ).showSnackBar(
                                                                          SnackBar(
                                                                            content: Text(
                                                                              "Complete Billing details to complete order",
                                                                              style: GoogleFonts.poppins(
                                                                                color: Colors.white,
                                                                                fontSize: 13,
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                            ),
                                                                            backgroundColor:
                                                                                Colors.red,
                                                                          ),
                                                                        );
                                                                      } else {
                                                                        await makeOrder();
                                                                      }
                                                                      // Future<void>
                                                                      // makeOrder() async {
                                                                      //   try {
                                                                      //     setState(() {
                                                                      //       ordering = true;
                                                                      //     });
                                                                      //     DocumentReference
                                                                      //     documentReference =
                                                                      //         FirebaseFirestore
                                                                      //             .instance
                                                                      //             .collection(
                                                                      //               "orders",
                                                                      //             )
                                                                      //             .doc();
                                                                      //     await documentReference
                                                                      //         .set({
                                                                      //           "id":
                                                                      //               documentReference
                                                                      //                   .id,
                                                                      //           "uid": FirebaseAuth
                                                                      //               .instance
                                                                      //               .currentUser!
                                                                      //               .uid,
                                                                      //           "total":
                                                                      //               total,
                                                                      //           "paid":
                                                                      //               false,
                                                                      //           "date_created":
                                                                      //               DateTime.now(),
                                                                      //           "day_created":
                                                                      //               DateTime.now()
                                                                      //                   .day,
                                                                      //           "month_created":
                                                                      //               DateTime.now()
                                                                      //                   .month,
                                                                      //           "year_created":
                                                                      //               DateTime.now()
                                                                      //                   .year,
                                                                      //           "status":
                                                                      //               "pending",
                                                                      //           "note": note
                                                                      //               .text
                                                                      //               .trim(),
                                                                      //           "payment_method":
                                                                      //               "cod", // or "bacs", "paypal", etc.
                                                                      //           "payment_method_title":
                                                                      //               "Payment on delivery",
                                                                      //           "cartitems":
                                                                      //               cartItems,
                                                                      //         })
                                                                      //         .then((
                                                                      //           value,
                                                                      //         ) async {
                                                                      //           await FirebaseFirestore
                                                                      //               .instance
                                                                      //               .collection(
                                                                      //                 "cart",
                                                                      //               )
                                                                      //               .where(
                                                                      //                 "uid",
                                                                      //                 isEqualTo: FirebaseAuth
                                                                      //                     .instance
                                                                      //                     .currentUser!
                                                                      //                     .uid,
                                                                      //               )
                                                                      //               .get()
                                                                      //               .then((
                                                                      //                 newvalue,
                                                                      //               ) {
                                                                      //                 for (var element
                                                                      //                     in newvalue.docs) {
                                                                      //                   element.reference.delete();
                                                                      //                 }
                                                                      //               })
                                                                      //               .then((
                                                                      //                 value,
                                                                      //               ) {
                                                                      //                 setState(
                                                                      //                   () {
                                                                      //                     ordering = false;
                                                                      //                   },
                                                                      //                 );
                                                                      //                 if (!mounted) {
                                                                      //                   return;
                                                                      //                 }
                                                                      //                 Navigator.pop(
                                                                      //                   context,
                                                                      //                 );

                                                                      //                 context.go(
                                                                      //                   '/success',
                                                                      //                 );
                                                                      //               });
                                                                      //         });
                                                                      //   } catch (e) {
                                                                      //     setState(() {
                                                                      //       ordering =
                                                                      //           false;
                                                                      //     });
                                                                      //     if (!mounted) {
                                                                      //       return;
                                                                      //     }
                                                                      //     ScaffoldMessenger.of(
                                                                      //       context,
                                                                      //     ).showSnackBar(
                                                                      //       SnackBar(
                                                                      //         content: Text(
                                                                      //           "Try again",
                                                                      //           style: GoogleFonts.poppins(
                                                                      //             color: Colors
                                                                      //                 .white,
                                                                      //             fontSize:
                                                                      //                 13,
                                                                      //             fontWeight:
                                                                      //                 FontWeight
                                                                      //                     .w600,
                                                                      //           ),
                                                                      //         ),
                                                                      //         backgroundColor:
                                                                      //             Colors
                                                                      //                 .red,
                                                                      //       ),
                                                                      //     );
                                                                      //   }
                                                                      // }

                                                                      // await makeOrder();
                                                                    },
                                                                    child: Container(
                                                                      height:
                                                                          0.060 *
                                                                          height,
                                                                      width:
                                                                          0.17 *
                                                                          width,
                                                                      decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .amber,
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              5,
                                                                            ),
                                                                      ),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          ordering
                                                                          ? SizedBox(
                                                                              height: 13,
                                                                              width: 13,
                                                                              child: CircularProgressIndicator(
                                                                                color: Colors.black,
                                                                                strokeWidth: 3,
                                                                              ),
                                                                            )
                                                                          : Text(
                                                                              "Confirm Order",
                                                                              style: GoogleFonts.poppins(
                                                                                color: Colors.black,
                                                                                fontSize: 13,
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                            ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
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
                                    child: Text(
                                      "Checkout",
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 100),
            ],
          ),
        );
      },
    );
  }

  Future<void> makeOrder() async {
    try {
      setState(() {
        ordering = true;
      });
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("orders")
          .doc();
      await documentReference
          .set({
            "id": documentReference.id,
            "uid": FirebaseAuth.instance.currentUser!.uid,
            "total": total,
            "paid": false,
            "date_created": DateTime.now(),
            "day_created": DateTime.now().day,
            "month_created": DateTime.now().month,
            "year_created": DateTime.now().year,
            "status": "pending",
            "note": note.text.trim(),
            "payment_method": "cod", // or "bacs", "paypal", etc.
            "payment_method_title": "Payment on delivery",
            "cartitems": cartItems,
          })
          .then((value) async {
            try {
              // Fetch admins' email addresses
              final adminDocs = await FirebaseFirestore.instance.collection('admins').get();
              final adminEmails = adminDocs.docs
                  .map((doc) => (doc.data())['email'] as String?)
                  .where((email) => email != null && email.isNotEmpty)
                  .cast<String>()
                  .toList();

              if (adminEmails.isNotEmpty) {
                final buffer = StringBuffer();
                buffer.write('<div style="font-family: Arial, sans-serif; max-width: 600px; color: #333;">');
                buffer.write('<h2 style="color: #FFC107; border-bottom: 2px solid #FFC107; padding-bottom: 10px;">New Order Placed</h2>');
                buffer.write('<p><strong>Order ID:</strong> ${documentReference.id}</p>');
                buffer.write('<p><strong>Payment Method:</strong> Payment on delivery</p>');
                if (note.text.trim().isNotEmpty) {
                  buffer.write('<p><strong>Customer Note:</strong> ${note.text.trim()}</p>');
                }
                buffer.write('<h3 style="border-bottom: 1px solid #ddd; padding-bottom: 5px; margin-top: 20px;">Order Items:</h3>');
                buffer.write('<table style="width: 100%; border-collapse: collapse; margin-top: 10px;">');
                buffer.write('<tr style="background-color: #f8f9fa;">');
                buffer.write('<th style="border: 1px solid #ddd; padding: 8px; text-align: left;">Product</th>');
                buffer.write('<th style="border: 1px solid #ddd; padding: 8px; text-align: center;">Qty</th>');
                buffer.write('<th style="border: 1px solid #ddd; padding: 8px; text-align: right;">Price</th>');
                buffer.write('<th style="border: 1px solid #ddd; padding: 8px; text-align: right;">Subtotal</th>');
                buffer.write('</tr>');
                
                for (var item in cartItems) {
                  final pName = item['productname'] ?? 'Unknown Product';
                  final pPrice = item['price'] ?? 0.0;
                  final pQty = item['quantity'] ?? 0;
                  final subTotal = pPrice * pQty;
                  buffer.write('<tr>');
                  buffer.write('<td style="border: 1px solid #ddd; padding: 8px;">$pName</td>');
                  buffer.write('<td style="border: 1px solid #ddd; padding: 8px; text-align: center;">$pQty</td>');
                  buffer.write('<td style="border: 1px solid #ddd; padding: 8px; text-align: right;">GHS $pPrice</td>');
                  buffer.write('<td style="border: 1px solid #ddd; padding: 8px; text-align: right;">GHS $subTotal</td>');
                  buffer.write('</tr>');
                }
                buffer.write('</table>');
                buffer.write('<p style="font-size: 16px; margin-top: 20px; text-align: right;"><strong>Total Amount:</strong> <span style="color: #FFC107; font-size: 18px;">GHS $total</span></p>');
                buffer.write('</div>');

                await FirebaseFirestore.instance.collection('mail').add({
                  'to': adminEmails,
                  'message': {
                    'subject': 'New Order Notification - #${documentReference.id}',
                    'html': buffer.toString(),
                  },
                });
              }
            } catch (e) {
              debugPrint("Error sending admin email: $e");
            }

            await FirebaseFirestore.instance
                .collection("cart")
                .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .get()
                .then((newvalue) {
                  for (var element in newvalue.docs) {
                    element.reference.delete();
                  }
                })
                .then((newvalue) {
                  setState(() {
                    ordering = false;
                  });
                  Navigator.pop(context);
                  context.go('/success');
                });
          });
    } catch (e) {
      setState(() {
        ordering = false;
      });
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Try again",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
