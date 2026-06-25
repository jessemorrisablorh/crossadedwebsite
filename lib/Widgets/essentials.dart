// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

Widget productsCard({
  required String id,
  required String productimage,
  required String productname,
  required num productprice,
  required double height,
  required double width,
}) {
  final formatCurrency = NumberFormat.currency(symbol: " ");
  return Padding(
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
              image: NetworkImage(productimage),
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(height: 20),
        Text(
          productname,
          textAlign: TextAlign.center,
          style: GoogleFonts.aldrich(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 20),
        Text(
          "GHS ${formatCurrency.format(productprice)}",
          textAlign: TextAlign.center,
          style: GoogleFonts.aldrich(
            color: Colors.amber,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

Widget categoriesCard({
  required double height,
  required double width,
  required String id,
  required String image,
  required String name,
}) {
  return Padding(
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
              image: NetworkImage(image),
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(height: 20),
        Text(
          name,
          textAlign: TextAlign.center,
          style: GoogleFonts.aldrich(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

Widget mobilecategoriesCard({
  required double height,
  required double width,
  required String id,
  required String image,
  required String name,
}) {
  return Padding(
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
              image: NetworkImage(image),
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(height: 20),
        Text(
          name,
          textAlign: TextAlign.center,
          style: GoogleFonts.aldrich(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

Widget floatingButtons({
  required double height,
  required double width,
  required BuildContext context,
}) {
  Future<void> openWhatsApp() async {
    final Uri url = Uri.parse("https://wa.me/543236328?text=Hello");

    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  return Padding(
    padding: const EdgeInsets.only(bottom: 50.0, right: 80.0),
    child: SizedBox(
      height: 0.20 * height,
      width: 0.15 * width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            onTap: () {
              if (FirebaseAuth.instance.currentUser == null) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AuthenticationWidget();
                  },
                );
              } else {
                context.go('/cart');
              }
            },
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),

                    child: Container(
                      height: 0.070 * height,
                      width: 0.043 * width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ImageIcon(
                          AssetImage("images/cart.png"),
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    height: 0.040 * height,
                    width: 0.040 * width,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: FirebaseAuth.instance.currentUser?.uid == null
                        ? Text(
                            "0",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("cart")
                                .where(
                                  "uid",
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser!.uid,
                                )
                                .snapshots(),
                            builder: (context, asyncSnapshot) {
                              if (!asyncSnapshot.hasData) {
                                return Text(
                                  "0",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                              return Text(
                                "${asyncSnapshot.data!.docs.length}",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          FloatingActionButton.extended(
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            onPressed: () async {
              await openWhatsApp();
            },
            backgroundColor: Colors.green,

            icon: ImageIcon(
              AssetImage("images/whatsapp.png"),
              color: Colors.white,
            ),
            label: Text(
              "Whatsapp us",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class MobileAuthenticationWidget extends StatefulWidget {
  const MobileAuthenticationWidget({super.key});

  @override
  State<MobileAuthenticationWidget> createState() =>
      _MobileAuthenticationWidgetState();
}

class _MobileAuthenticationWidgetState
    extends State<MobileAuthenticationWidget> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool hidepassword = true;
  bool loading = false;
  String screenstate = "login";
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Form(
      key: formkey,
      child: StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            child: Container(
              height: 0.50 * height,
              width: width,
              color: Colors.grey[900],
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      onTap: () => context.go('/'),
                      child: Text(
                        "CROSSFADED",
                        style: GoogleFonts.anton(
                          color: Colors.amber,
                          fontSize: 30,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // EMAIL
                    TextFormField(
                      controller: email,
                      cursorColor: Colors.white,
                      cursorHeight: 13,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Required";
                        } else if (!RegExp(
                          r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
                        ).hasMatch(value)) {
                          return "Invalid email address";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        hintText: screenstate == "login"
                            ? "Email"
                            : screenstate == "signup"
                            ? "Email"
                            : "Input your email to reset password",
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),
                    if (screenstate != "reset")
                      // PASSWORD
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: password,
                              cursorColor: Colors.white,
                              cursorHeight: 13,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                              obscureText: hidepassword,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Required";
                                }
                                return null;
                              },

                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                hintText: "Password",
                                hintStyle: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            onTap: () {
                              if (hidepassword == true) {
                                setState(() {
                                  hidepassword = false;
                                });
                              } else {
                                if (hidepassword == false) {
                                  setState(() {
                                    hidepassword = true;
                                  });
                                }
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  hidepassword == true
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 25),

                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      onTap: () async {
                        if (formkey.currentState!.validate()) {
                          if (screenstate == "login") {
                            await signInAccount(
                              email: email.text.trim(),
                              password: password.text.trim(),
                            );
                          } else if (screenstate == "signup") {
                            await createAccount(
                              email: email.text.trim(),
                              password: password.text.trim(),
                            );
                          } else if (screenstate == "reset") {
                            try {
                              await resetPassword(email: email.text.trim());
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Password reset email sent",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } catch (e) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    e.toString(),
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        }
                      },
                      child: Container(
                        height: 50,
                        width: 200,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: loading
                            ? Container(
                                height: 13,
                                width: 13,
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                  strokeWidth: 3,
                                ),
                              )
                            : Text(
                                screenstate == "login"
                                    ? "Sign In"
                                    : screenstate == "reset"
                                    ? "Reset Password"
                                    : "Sign Up",

                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 25),
                    if (screenstate == "login")
                      InkWell(
                        onTap: () {
                          if (screenstate == "reset") {
                            setState(() {
                              screenstate = "login";
                            });
                          } else {
                            setState(() {
                              screenstate = "reset";
                            });
                          }
                        },
                        child: Text(
                          screenstate == "reset"
                              ? "Sign In"
                              : "Forgot password?",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    SizedBox(height: 15),
                    InkWell(
                      onTap: () {
                        if (screenstate == "signup") {
                          setState(() {
                            screenstate = "login";
                          });
                        } else {
                          setState(() {
                            screenstate = "signup";
                          });
                        }
                      },
                      child: Text(
                        screenstate == "signup"
                            ? "Already have an account? Sign in"
                            : "Create new account",
                        style: GoogleFonts.poppins(
                          color: Colors.amber,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> signInAccount({
    required String email,
    required String password,
  }) async {
    try {
      setState(() {
        loading = true;
      });

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      setState(() {
        loading = false;
      });

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login successful"),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      String message = "Login failed";

      if (e.code == "user-not-found") {
        message = "No user found for this email";
      } else if (e.code == "wrong-password") {
        message = "Incorrect password";
      } else if (e.code == "invalid-email") {
        message = "Invalid email address";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> createAccount({
    required String email,
    required String password,
  }) async {
    try {
      setState(() {
        loading = true;
      });

      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
            await FirebaseFirestore.instance
                .collection("users")
                .doc(value.user!.uid)
                .set({
                  "email": email,
                  "password": password,
                  "firstname": "",
                  "lastname": "",
                  "address": "",
                  "region": "",
                  "city": "",
                  "phone": "",
                  "role": "customer",
                  "uid": value.user!.uid,
                });
          });

      if (!mounted) return;

      setState(() {
        loading = false;
      });

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Account created successfully",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      String message = "Failed, Try again";

      if (e.code == "user-not-found") {
        message = "No user found for this email";
      } else if (e.code == "wrong-password") {
        message = "Incorrect password";
      } else if (e.code == "invalid-email") {
        message = "Invalid email address";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error: $e",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> resetPassword({required String email}) async {
    if (formkey.currentState!.validate()) {
      try {
        setState(() {
          loading = true;
        });
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((
          value,
        ) {
          setState(() {
            loading = false;
          });
        });
      } on FirebaseAuthException catch (e) {
        String message = "Failed, Try again";

        if (e.code == "user-not-found") {
          message = "No user found for this email";
        } else if (e.code == "invalid-email") {
          message = "Invalid email address";
        }

        throw Exception(message);
      } catch (e) {
        setState(() {
          loading = false;
        });
        throw Exception("Error: $e");
      }
    }
  }
}

class AuthenticationWidget extends StatefulWidget {
  const AuthenticationWidget({super.key});

  @override
  State<AuthenticationWidget> createState() => _AuthenticationWidgetState();
}

class _AuthenticationWidgetState extends State<AuthenticationWidget> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool hidepassword = true;
  bool loading = false;
  String screenstate = "login";
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Form(
      key: formkey,
      child: StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            child: Container(
              height: 0.50 * height,
              width: 0.40 * width,
              color: Colors.grey[900],
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      onTap: () => context.go('/'),
                      child: Text(
                        "CROSSFADED",
                        style: GoogleFonts.anton(
                          color: Colors.amber,
                          fontSize: 30,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // EMAIL
                    TextFormField(
                      controller: email,
                      cursorColor: Colors.white,
                      cursorHeight: 13,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Required";
                        } else if (!RegExp(
                          r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
                        ).hasMatch(value)) {
                          return "Invalid email address";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        hintText: screenstate == "login"
                            ? "Email"
                            : screenstate == "signup"
                            ? "Email"
                            : "Input your email to reset password",
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),
                    if (screenstate != "reset")
                      // PASSWORD
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: password,
                              cursorColor: Colors.white,
                              cursorHeight: 13,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                              obscureText: hidepassword,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Required";
                                }
                                return null;
                              },

                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                hintText: "Password",
                                hintStyle: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            onTap: () {
                              if (hidepassword == true) {
                                setState(() {
                                  hidepassword = false;
                                });
                              } else {
                                if (hidepassword == false) {
                                  setState(() {
                                    hidepassword = true;
                                  });
                                }
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  hidepassword == true
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 25),

                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      onTap: () async {
                        if (formkey.currentState!.validate()) {
                          if (screenstate == "login") {
                            await signInAccount(
                              email: email.text.trim(),
                              password: password.text.trim(),
                            );
                          } else if (screenstate == "signup") {
                            await createAccount(
                              email: email.text.trim(),
                              password: password.text.trim(),
                            );
                          } else if (screenstate == "reset") {
                            try {
                              await resetPassword(email: email.text.trim());
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Password reset email sent",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } catch (e) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    e.toString(),
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        }
                      },
                      child: Container(
                        height: 50,
                        width: 200,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: loading
                            ? Container(
                                height: 13,
                                width: 13,
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                  strokeWidth: 3,
                                ),
                              )
                            : Text(
                                screenstate == "login"
                                    ? "Sign In"
                                    : screenstate == "reset"
                                    ? "Reset Password"
                                    : "Sign Up",

                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 25),
                    if (screenstate == "login")
                      InkWell(
                        onTap: () {
                          if (screenstate == "reset") {
                            setState(() {
                              screenstate = "login";
                            });
                          } else {
                            setState(() {
                              screenstate = "reset";
                            });
                          }
                        },
                        child: Text(
                          screenstate == "reset"
                              ? "Sign In"
                              : "Forgot password?",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    SizedBox(height: 15),
                    InkWell(
                      onTap: () {
                        if (screenstate == "signup") {
                          setState(() {
                            screenstate = "login";
                          });
                        } else {
                          setState(() {
                            screenstate = "signup";
                          });
                        }
                      },
                      child: Text(
                        screenstate == "signup"
                            ? "Already have an account? Sign in"
                            : "Create new account",
                        style: GoogleFonts.poppins(
                          color: Colors.amber,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> signInAccount({
    required String email,
    required String password,
  }) async {
    try {
      setState(() {
        loading = true;
      });

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      setState(() {
        loading = false;
      });

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login successful"),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      String message = "Login failed";

      if (e.code == "user-not-found") {
        message = "No user found for this email";
      } else if (e.code == "wrong-password") {
        message = "Incorrect password";
      } else if (e.code == "invalid-email") {
        message = "Invalid email address";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> createAccount({
    required String email,
    required String password,
  }) async {
    try {
      setState(() {
        loading = true;
      });

      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
            await FirebaseFirestore.instance
                .collection("users")
                .doc(value.user!.uid)
                .set({
                  "email": email,
                  "password": password,
                  "firstname": "",
                  "lastname": "",
                  "address": "",
                  "region": "",
                  "city": "",
                  "phone": "",
                  "role": "customer",
                  "uid": value.user!.uid,
                });
          });

      if (!mounted) return;

      setState(() {
        loading = false;
      });

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Account created successfully",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      String message = "Failed, Try again";

      if (e.code == "user-not-found") {
        message = "No user found for this email";
      } else if (e.code == "wrong-password") {
        message = "Incorrect password";
      } else if (e.code == "invalid-email") {
        message = "Invalid email address";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error: $e",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> resetPassword({required String email}) async {
    if (formkey.currentState!.validate()) {
      try {
        setState(() {
          loading = true;
        });
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((
          value,
        ) {
          setState(() {
            loading = false;
          });
        });
      } on FirebaseAuthException catch (e) {
        String message = "Failed, Try again";

        if (e.code == "user-not-found") {
          message = "No user found for this email";
        } else if (e.code == "invalid-email") {
          message = "Invalid email address";
        }

        throw Exception(message);
      } catch (e) {
        setState(() {
          loading = false;
        });
        throw Exception("Error: $e");
      }
    }
  }
}

class EditBillingInformation extends StatefulWidget {
  const EditBillingInformation({super.key});

  @override
  State<EditBillingInformation> createState() => _EditBillingInformationState();
}

class _EditBillingInformationState extends State<EditBillingInformation> {
  TextEditingController firstnametext = TextEditingController();
  TextEditingController lastnametext = TextEditingController();
  TextEditingController phonenumbertext = TextEditingController();
  TextEditingController addresstext = TextEditingController();
  TextEditingController citytext = TextEditingController();
  TextEditingController regiontext = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return StatefulBuilder(
      builder: (context, setState) {
        return Dialog(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, asyncSnapshot) {
              if (!asyncSnapshot.hasData) {
                return Container(
                  height: 0.60 * height,
                  width: 0.40 * width,
                  color: Colors.grey[900],
                );
              }
              final userData = asyncSnapshot.data;
              return Container(
                height: 0.60 * height,
                width: 0.40 * width,
                color: Colors.grey[900],
                child: Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: firstnametext,
                        cursorColor: Colors.white,
                        cursorHeight: 13,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          hintText:
                              userData!["firstname"] == null ||
                                  userData["firstname"] == ""
                              ? "First name"
                              : userData["firstname"],
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.white.withAlpha(90),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      TextField(
                        controller: lastnametext,
                        cursorColor: Colors.white,
                        cursorHeight: 13,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          hintText:
                              userData["lastname"] == null ||
                                  userData["lastname"] == ""
                              ? "Last name"
                              : userData["lastname"],
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.white.withAlpha(90),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      TextField(
                        controller: phonenumbertext,
                        cursorColor: Colors.white,
                        cursorHeight: 13,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          hintText:
                              userData["phone"] == null ||
                                  userData["phone"] == ""
                              ? "Phone number"
                              : userData["phone"],
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.white.withAlpha(90),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      TextField(
                        controller: addresstext,
                        cursorColor: Colors.white,
                        cursorHeight: 13,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          hintText:
                              asyncSnapshot.data!["address"] == null ||
                                  asyncSnapshot.data!["address"] == ""
                              ? "Address"
                              : asyncSnapshot.data!["address"],
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.white.withAlpha(90),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      TextField(
                        controller: citytext,
                        cursorColor: Colors.white,
                        cursorHeight: 13,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          hintText:
                              userData["city"] == null || userData["city"] == ""
                              ? "City"
                              : userData["city"],
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.white.withAlpha(90),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      TextField(
                        controller: regiontext,
                        cursorColor: Colors.white,
                        cursorHeight: 13,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          hintText:
                              userData["region"] == null ||
                                  userData["region"] == ""
                              ? "Region"
                              : userData["region"],
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.white.withAlpha(90),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        onTap: () async {
                          await changeBillingDetails(
                            region: asyncSnapshot.data!["region"],
                            city: asyncSnapshot.data!["city"],
                            address: asyncSnapshot.data!["address"],
                            phonenumber: asyncSnapshot.data!["phone"],
                            lastname: asyncSnapshot.data!["lastname"],
                            firstname: asyncSnapshot.data!["firstname"],
                          );
                        },
                        child: Container(
                          height: 50,
                          width: 200,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(5),
                          ),

                          child: loading
                              ? SizedBox(
                                  height: 13,
                                  width: 13,
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                    strokeWidth: 3,
                                  ),
                                )
                              : Text(
                                  "Save",
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
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> changeBillingDetails({
    required String region,
    required String city,
    required String address,
    required String phonenumber,
    required String lastname,
    required String firstname,
  }) async {
    try {
      setState(() {
        loading = true;
      });
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
            "firstname": firstnametext.text == ""
                ? firstname
                : firstnametext.text.trim(),
            "lastname": lastnametext.text == ""
                ? lastname
                : lastnametext.text.trim(),
            "phonenumber": phonenumbertext.text == ""
                ? phonenumber
                : phonenumbertext.text.trim(),
            "address": addresstext.text == ""
                ? address
                : addresstext.text.trim(),
            "city": citytext.text == "" ? city : citytext.text.trim(),
            "region": regiontext.text == "" ? region : regiontext.text.trim(),
          })
          .then((value) {
            if (!mounted) return;
            setState(() {
              loading = false;
            });
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Billing details updated successfully",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: Colors.green,
              ),
            );
          });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }
}

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  bool loading = false;
  TextEditingController currentPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Form(
          key: formkey,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, asyncSnapshot) {
              if (!asyncSnapshot.hasData) {
                return Container(
                  height: 0.43 * MediaQuery.of(context).size.height,
                  width: 0.30 * MediaQuery.of(context).size.width,
                  color: Colors.grey[900],
                );
              }
              return Dialog(
                child: Container(
                  height: 0.43 * MediaQuery.of(context).size.height,
                  width: 0.30 * MediaQuery.of(context).size.width,
                  color: Colors.grey[900],
                  child: Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            "Change Password",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Required";
                            } else if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            } else if (value.trim() ==
                                newPassword.text.trim()) {
                              return "Current password must be different from new password";
                            } else if (currentPassword.text.trim() !=
                                asyncSnapshot.data!["password"]) {
                              return "Incorrect current password";
                            }
                            return null;
                          },

                          controller: currentPassword,
                          cursorColor: Colors.white,
                          cursorHeight: 13,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            hintText: "Current password",
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.white.withAlpha(90),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Required";
                            } else if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            } else if (newPassword.text.trim() ==
                                currentPassword.text.trim()) {
                              return "New password must be different from current password";
                            }
                            return null;
                          },

                          controller: newPassword,
                          cursorColor: Colors.white,
                          cursorHeight: 13,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            hintText: "New password",
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.white.withAlpha(90),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          onTap: () async {
                            if (formkey.currentState!.validate()) {
                              await changePassword();
                            }
                          },
                          child: Container(
                            height: 50,
                            width: 200,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: loading
                                ? Container(
                                    height: 13,
                                    width: 13,
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                      strokeWidth: 3,
                                    ),
                                  )
                                : Text(
                                    "Change password",
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
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> changePassword() async {
    try {
      setState(() {
        loading = true;
      });
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(
            EmailAuthProvider.credential(
              email: FirebaseAuth.instance.currentUser!.email!,
              password: currentPassword.text.trim(),
            ),
          )
          .then((value) {
            return FirebaseAuth.instance.currentUser!.updatePassword(
              newPassword.text.trim(),
            );
          })
          .then((value) async {
            await FirebaseFirestore.instance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .update({"password": newPassword.text.trim()})
                .then((value) {
                  if (!mounted) return;
                  setState(() {
                    loading = false;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Password changed successfully",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                });
          });
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
      });
      String message = "Password change failed";
      if (e.code == "weak-password") {
        message = "The new password is too weak";
      } else if (e.code == "requires-recent-login") {
        message = "Please log out and log back in to change your password";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    } catch (e) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }
}
