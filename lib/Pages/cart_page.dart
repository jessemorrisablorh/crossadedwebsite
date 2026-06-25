import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_faded_web/Widgets/cart_page_widget.dart';
import 'package:cross_faded_web/Widgets/footer.dart';
import 'package:cross_faded_web/Widgets/header.dart';
import 'package:cross_faded_web/Widgets/essentials.dart';
import 'package:cross_faded_web/Widgets/mobile_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return const DesktopCartPage();
        } else if (constraints.maxWidth > 800 && constraints.maxWidth <= 1200) {
          return const DesktopCartPage();
        } else {
          return const MobileCartPage();
        }
      },
    );
  }
}

class DesktopCartPage extends StatelessWidget {
  const DesktopCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [DesktopHeader(), DesktopCartPageWidget(), DesktopFooter()],
        ),
      ),
    );
  }
}

class MobileCartPage extends StatefulWidget {
  const MobileCartPage({super.key});

  @override
  State<MobileCartPage> createState() => _MobileCartPageState();
}

class _MobileCartPageState extends State<MobileCartPage> {
  final formatCurrency = NumberFormat.currency(symbol: " ");

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    if (user == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        endDrawer: MobileDrawer(),
        appBar: Header(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_cart_outlined, color: Colors.white30, size: 80),
              const SizedBox(height: 20),
              Text(
                'Please sign in to view your cart',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context.go('/login'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                child: Text('Sign In', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const Footer(),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      endDrawer: MobileDrawer(),
      appBar: Header(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("cart")
            .where("uid", isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.amber));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.remove_shopping_cart, color: Colors.white30, size: 60),
                  const SizedBox(height: 20),
                  Text('Your cart is empty', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 16)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => context.go('/shop'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                    child: Text('Go Shopping', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          }

          final cartDocs = snapshot.data!.docs;
          double total = 0;
          List<Map<String, dynamic>> cartItems = [];

          for (var doc in cartDocs) {
            final data = doc.data() as Map<String, dynamic>;
            final price = (data['price'] ?? 0.0).toDouble();
            final quantity = (data['quantity'] ?? 1).toInt();
            total += price * quantity;
            cartItems.add({'id': doc.id, ...data});
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "My Cart",
                    style: GoogleFonts.raleway(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Cart Items list
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      final docId = item['id'];
                      final name = item['productname'] ?? 'Product';
                      final image = item['productimage'] ?? '';
                      final price = (item['price'] ?? 0.0).toDouble();
                      final quantity = (item['quantity'] ?? 1).toInt();

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: image.isNotEmpty
                                  ? Image.network(image, width: 70, height: 70, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, color: Colors.white30))
                                  : const Icon(Icons.image, color: Colors.white30, size: 70),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'GHS ${price.toStringAsFixed(2)}',
                                    style: GoogleFonts.aldrich(color: Colors.amber, fontSize: 13),
                                  ),
                                  const SizedBox(height: 8),

                                  // Quantity controllers
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          if (quantity > 1) {
                                            await FirebaseFirestore.instance
                                                .collection('cart')
                                                .doc(docId)
                                                .update({'quantity': quantity - 1});
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(4)),
                                          child: const Icon(Icons.remove, size: 16, color: Colors.black),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                        child: Text('$quantity', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          await FirebaseFirestore.instance
                                              .collection('cart')
                                              .doc(docId)
                                              .update({'quantity': quantity + 1});
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(4)),
                                          child: const Icon(Icons.add, size: 16, color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              onPressed: () async {
                                await FirebaseFirestore.instance.collection('cart').doc(docId).delete();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Total & Checkout card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total:', style: GoogleFonts.raleway(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('GHS ${total.toStringAsFixed(2)}', style: GoogleFonts.aldrich(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => _showCheckoutDialog(context, total, cartItems),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          ),
                          child: Text(
                            'Proceed to Checkout',
                            style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Footer(),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: floatingButtons(
        height: height,
        width: width,
        context: context,
      ),
    );
  }

  void _showCheckoutDialog(BuildContext context, double total, List<Map<String, dynamic>> cartItems) {
    showDialog(
      context: context,
      builder: (context) => _MobileCheckoutDialog(
        total: total,
        cartItems: cartItems,
      ),
    );
  }
}

class _MobileCheckoutDialog extends StatefulWidget {
  final double total;
  final List<Map<String, dynamic>> cartItems;

  const _MobileCheckoutDialog({
    required this.total,
    required this.cartItems,
  });

  @override
  State<_MobileCheckoutDialog> createState() => _MobileCheckoutDialogState();
}

class _MobileCheckoutDialogState extends State<_MobileCheckoutDialog> {
  final TextEditingController _noteController = TextEditingController();
  bool _ordering = false;

  Future<void> _placeOrder(Map<String, dynamic> userData) async {
    if (userData['firstname'] == "" ||
        userData['lastname'] == "" ||
        userData['address'] == "" ||
        userData['region'] == "" ||
        userData['city'] == "" ||
        userData['phone'] == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Complete Billing details to complete order",
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _ordering = true;
    });

    try {
      final docRef = FirebaseFirestore.instance.collection("orders").doc();
      await docRef.set({
        "id": docRef.id,
        "uid": FirebaseAuth.instance.currentUser!.uid,
        "total": widget.total,
        "paid": false,
        "date_created": DateTime.now(),
        "day_created": DateTime.now().day,
        "month_created": DateTime.now().month,
        "year_created": DateTime.now().year,
        "status": "pending",
        "note": _noteController.text.trim(),
        "payment_method": "cod",
        "payment_method_title": "Payment on delivery",
        "cartitems": widget.cartItems,
      });

      // Clear Cart
      final cartSnap = await FirebaseFirestore.instance
          .collection("cart")
          .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      for (var doc in cartSnap.docs) {
        await doc.reference.delete();
      }

      if (mounted) {
        setState(() {
          _ordering = false;
        });
        Navigator.pop(context); // Close checkout dialog
        context.go('/success');
      }
    } catch (e) {
      setState(() {
        _ordering = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Order failed, please try again"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Dialog(
      insetPadding: const EdgeInsets.all(15),
      child: Container(
        width: width * 0.95,
        height: height * 0.85,
        color: Colors.grey[900],
        padding: const EdgeInsets.all(20),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator(color: Colors.amber));
            }
            final userData = snapshot.data!.data() as Map<String, dynamic>? ?? {};

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Order Confirmation",
                      style: GoogleFonts.raleway(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const EditBillingInformation(),
                        );
                      },
                      child: Text("Edit Billing Info", style: GoogleFonts.poppins(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const Divider(color: Colors.white24),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        _billingRow("First name", userData['firstname'] ?? ''),
                        _billingRow("Last name", userData['lastname'] ?? ''),
                        _billingRow("Phone number", userData['phone'] ?? ''),
                        _billingRow("Address", userData['address'] ?? ''),
                        _billingRow("Region", userData['region'] ?? ''),
                        _billingRow("City", userData['city'] ?? ''),
                        const SizedBox(height: 20),
                        
                        // Note field
                        Text("Order Notes", style: GoogleFonts.poppins(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(5)),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            controller: _noteController,
                            cursorColor: Colors.white,
                            maxLines: 4,
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                            decoration: const InputDecoration(border: InputBorder.none, hintText: "Notes about your order..."),
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        _billingRow("Payment Method", "Cash On Delivery (COD)"),
                      ],
                    ),
                  ),
                ),
                const Divider(color: Colors.white24),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: _ordering ? null : () => Navigator.pop(context),
                      child: const Text("Cancel", style: TextStyle(color: Colors.amber)),
                    ),
                    ElevatedButton(
                      onPressed: _ordering ? null : () => _placeOrder(userData),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                      child: _ordering
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                          : Text("Place Order (GHS ${widget.total.toStringAsFixed(2)})", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _billingRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.poppins(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold)),
          Text(value.isEmpty ? 'Not set' : value, style: GoogleFonts.poppins(color: Colors.white, fontSize: 13)),
        ],
      ),
    );
  }
}
