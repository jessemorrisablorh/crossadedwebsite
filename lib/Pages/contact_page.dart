import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_faded_web/Widgets/essentials.dart';
import 'package:cross_faded_web/Widgets/footer.dart';
import 'package:cross_faded_web/Widgets/header.dart';
import 'package:cross_faded_web/Widgets/mobile_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return const DesktopContactPage();
        } else if (constraints.maxWidth > 800 && constraints.maxWidth <= 1200) {
          return const DesktopContactPage();
        } else {
          return const MobileContactPage();
        }
      },
    );
  }
}

class DesktopContactPage extends StatefulWidget {
  const DesktopContactPage({super.key});

  @override
  State<DesktopContactPage> createState() => _DesktopContactPageState();
}

class _DesktopContactPageState extends State<DesktopContactPage> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController messagecontroller = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Form(
      key: formkey,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            children: [
              DesktopHeader(),
              Container(
                width: width,
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Contact Us",
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
                            child: Stack(
                              children: [
                                Container(
                                  height: 0.60 * height,
                                  width: width,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[900],
                                    image: DecorationImage(
                                      image: AssetImage("images/maps.jpg"),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                Container(
                                  height: 0.15 * height,
                                  width: 0.30 * width,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                    ),
                                    //  borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    " FLAT NUMBER 2A, DANSOMAN HIGH ST, 9th Cl, Accra, Ghana",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Container(
                              height: 0.60 * height,
                              width: width,
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(50.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Send us a message",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Container(
                                      width: width,
                                      height: 0.060 * height,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withAlpha(90),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 15.0,
                                          right: 15.0,
                                        ),
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Please enter your name";
                                            }
                                            return null;
                                          },
                                          cursorHeight: 13,
                                          cursorColor: Colors.white,
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          controller: namecontroller,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Your Name",
                                            hintStyle: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    Container(
                                      width: width,
                                      height: 0.060 * height,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withAlpha(90),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 15.0,
                                          right: 15.0,
                                        ),
                                        child: TextFormField(
                                          controller: emailcontroller,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Please enter your email";
                                            } else if (!RegExp(
                                              r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
                                            ).hasMatch(value)) {
                                              return "Please enter a valid email";
                                            }
                                            return null;
                                          },
                                          cursorHeight: 13,
                                          cursorColor: Colors.white,
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Your Email",
                                            hintStyle: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    Container(
                                      width: width,
                                      height: 0.18 * height,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withAlpha(90),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 15.0,
                                          right: 15.0,
                                          top: 15.0,
                                          bottom: 15.0,
                                        ),
                                        child: TextFormField(
                                          controller: messagecontroller,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Please enter your message";
                                            }
                                            return null;
                                          },
                                          cursorHeight: 13,
                                          cursorColor: Colors.white,
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 20,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Your Message",
                                            hintStyle: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    InkWell(
                                      onTap: () async {
                                        await sendMessage();
                                      },
                                      child: Container(
                                        width: 0.17 * width,
                                        height: 0.060 * height,
                                        decoration: BoxDecoration(
                                          color: Colors.amber,
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: loading
                                            ? SizedBox(
                                                height: 13,
                                                width: 13,
                                                child:
                                                    CircularProgressIndicator(
                                                      color: Colors.black,
                                                      strokeWidth: 3,
                                                    ),
                                              )
                                            : Text(
                                                "Submit",
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
                              ),
                            ),
                          ),
                          SizedBox(height: 50),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50),
              DesktopFooter(),
            ],
          ),
        ),
        floatingActionButton: floatingButtons(
          height: height,
          width: width,
          context: context,
        ),
      ),
    );
  }

  Future<void> sendMessage() async {
    if (formkey.currentState!.validate()) {
      try {
        setState(() {
          loading = true;
        });
        DocumentReference docref = FirebaseFirestore.instance
            .collection("messages")
            .doc();
        await docref.set({
          "id": docref.id,
          "name": namecontroller.text,
          "email": emailcontroller.text,
          "message": messagecontroller.text,
          "timestamp": DateTime.now(),
        });
        setState(() {
          loading = false;
          namecontroller.clear();
          emailcontroller.clear();
          messagecontroller.clear();
        });
      } catch (e) {
        setState(() {
          loading = false;
          namecontroller.clear();
          emailcontroller.clear();
          messagecontroller.clear();
        });
      }
    }
  }
}

class MobileContactPage extends StatefulWidget {
  const MobileContactPage({super.key});

  @override
  State<MobileContactPage> createState() => _MobileContactPageState();
}

class _MobileContactPageState extends State<MobileContactPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  Future<void> _submitMessage() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });
      try {
        final docRef = FirebaseFirestore.instance.collection("messages").doc();
        await docRef.set({
          "id": docRef.id,
          "name": _nameController.text.trim(),
          "email": _emailController.text.trim(),
          "message": _messageController.text.trim(),
          "timestamp": DateTime.now(),
        });
        if (mounted) {
          setState(() {
            _loading = false;
            _nameController.clear();
            _emailController.clear();
            _messageController.clear();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Message sent successfully"),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        setState(() {
          _loading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Failed to send message"),
              backgroundColor: Colors.red,
            ),
          );
        }
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Contact Us",
                  style: GoogleFonts.raleway(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),

                // Map/Address Container
                Stack(
                  children: [
                    Container(
                      height: 220,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        image: const DecorationImage(
                          image: AssetImage("images/maps.jpg"),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    Container(
                      height: 80,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "FLAT NUMBER 2A, DANSOMAN HIGH ST, 9th Cl, Accra, Ghana",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                // Message Form Container
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Send us a message",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Name Field
                      TextFormField(
                        controller: _nameController,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                        cursorColor: Colors.amber,
                        decoration: InputDecoration(
                          hintText: "Your Name",
                          hintStyle: const TextStyle(color: Colors.white38),
                          filled: true,
                          fillColor: Colors.black38,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? "Please enter your name"
                            : null,
                      ),
                      const SizedBox(height: 15),

                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                        cursorColor: Colors.amber,
                        decoration: InputDecoration(
                          hintText: "Your Email",
                          hintStyle: const TextStyle(color: Colors.white38),
                          filled: true,
                          fillColor: Colors.black38,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your email";
                          }
                          if (!RegExp(
                            r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
                          ).hasMatch(value)) {
                            return "Please enter a valid email";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      // Message Field
                      TextFormField(
                        controller: _messageController,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                        maxLines: 5,
                        cursorColor: Colors.amber,
                        decoration: InputDecoration(
                          hintText: "Your Message",
                          hintStyle: const TextStyle(color: Colors.white38),
                          filled: true,
                          fillColor: Colors.black38,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? "Please enter your message"
                            : null,
                      ),
                      const SizedBox(height: 20),

                      // Submit Button
                      ElevatedButton(
                        onPressed: _loading ? null : _submitMessage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: _loading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                "Submit",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
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
