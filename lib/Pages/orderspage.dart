import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_faded_web/Widgets/essentials.dart';
import 'package:cross_faded_web/Widgets/footer.dart';
import 'package:cross_faded_web/Widgets/header.dart';
import 'package:cross_faded_web/Widgets/mobile_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Orderspage extends StatelessWidget {
  const Orderspage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return const DesktopOrdersPage();
        } else if (constraints.maxWidth > 800 && constraints.maxWidth <= 1200) {
          return const DesktopOrdersPage();
        } else {
          return const MobileOrdersPage();
        }
      },
    );
  }
}

class DesktopOrdersPage extends StatefulWidget {
  const DesktopOrdersPage({super.key});

  @override
  State<DesktopOrdersPage> createState() => _DesktopOrdersPageState();
}

class _DesktopOrdersPageState extends State<DesktopOrdersPage> {
  final formatCurrency = NumberFormat.currency(symbol: " ");

  String status = "pending";

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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "My Orders",
                      style: GoogleFonts.raleway(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(50.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      status = "pending";
                                    });
                                  },
                                  child: Text(
                                    "Pending Orders",
                                    style: TextStyle(
                                      color: status == "pending"
                                          ? Colors.green
                                          : Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      status = "cancelled";
                                    });
                                  },
                                  child: Text(
                                    "Cancelled Orders",
                                    style: TextStyle(
                                      color: status == "cancelled"
                                          ? Colors.red
                                          : Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      status = "completed";
                                    });
                                  },
                                  child: Text(
                                    "Completed Orders",
                                    style: TextStyle(
                                      color: status == "completed"
                                          ? Colors.green
                                          : Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 50),
                        Expanded(
                          child: Container(
                            width: width,
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(50.0),
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("orders")
                                    .where("status", isEqualTo: status)
                                    .where(
                                      "uid",
                                      isEqualTo: FirebaseAuth
                                          .instance
                                          .currentUser!
                                          .uid,
                                    )
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Container();
                                  }
                                  final orders = snapshot.data!.docs;
                                  return orders.isEmpty
                                      ? Center(
                                          child: Text(
                                            "No $status orders found.",
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        )
                                      : ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: orders.length,
                                          itemBuilder: (context, index) {
                                            final order = orders[index];
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 15),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    "${order["day_created"]} - ${order["month_created"]} - ${order["year_created"]}",
                                                    textAlign: TextAlign.right,
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.amber,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Order Status:  ",
                                                      style:
                                                          GoogleFonts.poppins(
                                                            color: Colors.amber,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
                                                    Text(
                                                      order["status"],
                                                      style:
                                                          GoogleFonts.poppins(
                                                            color: Colors.white,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Order ID:   ",
                                                      style:
                                                          GoogleFonts.poppins(
                                                            color: Colors.amber,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
                                                    Text(
                                                      order["id"] ?? "N/A",
                                                      style:
                                                          GoogleFonts.poppins(
                                                            color: Colors.white,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Total Amount:   ",
                                                      style:
                                                          GoogleFonts.poppins(
                                                            color: Colors.amber,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
                                                    Text(
                                                      "GHS ${formatCurrency.format(order["total"])}",
                                                      style:
                                                          GoogleFonts.poppins(
                                                            color: Colors.white,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Payment Method:   ",
                                                      style:
                                                          GoogleFonts.poppins(
                                                            color: Colors.amber,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
                                                    Text(
                                                      order["payment_method_title"],
                                                      style:
                                                          GoogleFonts.poppins(
                                                            color: Colors.white,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return Dialog(
                                                            child: Container(
                                                              height:
                                                                  0.50 * height,
                                                              width:
                                                                  0.40 * width,
                                                              color: Colors
                                                                  .grey[900],
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets.all(
                                                                      50.0,
                                                                    ),
                                                                child: ListView.separated(
                                                                  itemCount:
                                                                      order["cartitems"]
                                                                          .length,
                                                                  itemBuilder:
                                                                      (
                                                                        context,
                                                                        index,
                                                                      ) {
                                                                        final item =
                                                                            order["cartitems"][index];
                                                                        return ListTile(
                                                                          leading: Image.network(
                                                                            item["productimage"],
                                                                            height:
                                                                                50,
                                                                            width:
                                                                                50,
                                                                          ),
                                                                          title: Text(
                                                                            item["productname"],
                                                                            style: GoogleFonts.poppins(
                                                                              color: Colors.white,
                                                                              fontSize: 13,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                          subtitle: Text(
                                                                            "Quantity: ${item["quantity"]} - Price: GHS ${formatCurrency.format(item["price"])}",
                                                                            style: GoogleFonts.poppins(
                                                                              color: Colors.grey,
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                  separatorBuilder:
                                                                      (
                                                                        BuildContext
                                                                        context,
                                                                        int
                                                                        index,
                                                                      ) {
                                                                        return const Divider(
                                                                          color:
                                                                              Colors.grey,
                                                                        );
                                                                      },
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Text(
                                                      "View Cart Details",
                                                      textAlign:
                                                          TextAlign.right,
                                                      style:
                                                          GoogleFonts.poppins(
                                                            color: Colors.grey,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 15),
                                              ],
                                            );
                                          },
                                          separatorBuilder:
                                              (
                                                BuildContext context,
                                                int index,
                                              ) {
                                                return const Divider(
                                                  color: Colors.grey,
                                                );
                                              },
                                        );
                                },
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

class MobileOrdersPage extends StatefulWidget {
  const MobileOrdersPage({super.key});

  @override
  State<MobileOrdersPage> createState() => _MobileOrdersPageState();
}

class _MobileOrdersPageState extends State<MobileOrdersPage> {
  final formatCurrency = NumberFormat.currency(symbol: " ");
  String status = "pending";

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
                "My Orders",
                style: GoogleFonts.raleway(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Horizontal status tabs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _statusTab("Pending", "pending", Colors.green),
                  _statusTab("Cancelled", "cancelled", Colors.red),
                  _statusTab("Completed", "completed", Colors.green),
                ],
              ),
              const SizedBox(height: 20),

              // Orders Stream List
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("orders")
                      .where("status", isEqualTo: status)
                      .where(
                        "uid",
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                      )
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.amber),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40.0),
                        child: Center(
                          child: Text(
                            "No $status orders found.",
                            style: GoogleFonts.poppins(
                              color: Colors.white54,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }

                    final orders = snapshot.data!.docs;

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: orders.length,
                      separatorBuilder: (context, index) =>
                          const Divider(color: Colors.white24, height: 25),
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        final day = order["day_created"];
                        final month = order["month_created"];
                        final year = order["year_created"];
                        final totalAmt = (order["total"] ?? 0.0).toDouble();
                        final orderId = order["id"] ?? '';

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Order ID: ${orderId.substring(0, orderId.length > 8 ? 8 : orderId.length)}...",
                                  style: GoogleFonts.poppins(
                                    color: Colors.amber,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "$day - $month - $year",
                                  style: GoogleFonts.poppins(
                                    color: Colors.amber,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            _orderInfoRow("Status", order["status"]),
                            _orderInfoRow(
                              "Total Amount",
                              "GHS ${formatCurrency.format(totalAmt)}",
                            ),
                            _orderInfoRow(
                              "Payment",
                              order["payment_method_title"] ?? '',
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: () => _viewCartDetails(
                                  context,
                                  order["cartitems"] ?? [],
                                ),
                                icon: const Icon(
                                  Icons.list_alt,
                                  color: Colors.grey,
                                  size: 18,
                                ),
                                label: Text(
                                  "View Items",
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
              const Footer(),
            ],
          ),
        ),
      ),
      floatingActionButton: floatingButtons(
        height: height,
        width: width,
        context: context,
      ),
    );
  }

  Widget _statusTab(String label, String value, Color activeColor) {
    final isSelected = status == value;
    return InkWell(
      onTap: () {
        setState(() {
          status = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: isSelected ? activeColor : Colors.white24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? activeColor : Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _orderInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _viewCartDetails(BuildContext context, List<dynamic> items) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.5,
          color: Colors.grey[900],
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Order Items",
                style: GoogleFonts.raleway(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(color: Colors.white24, height: 20),
              Expanded(
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (context, index) =>
                      const Divider(color: Colors.white12),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final name = item["productname"] ?? '';
                    final image = item["productimage"] ?? '';
                    final qty = item["quantity"] ?? 1;
                    final price = (item["price"] ?? 0.0).toDouble();

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: image.isNotEmpty
                          ? Image.network(
                              image,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.image, color: Colors.white30),
                      title: Text(
                        name,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "Qty: $qty - GHS ${formatCurrency.format(price)}",
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                  ),
                  child: const Text(
                    "Close",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
