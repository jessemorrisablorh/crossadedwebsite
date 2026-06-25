import 'package:cross_faded_web/Widgets/essentials.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'responsive_layout.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    if (ResponsiveLayout.isMobile(context) || ResponsiveLayout.isTablet(context)) {
      return const MobileFooter();
    }
    return const DesktopFooter();
  }
}

class DesktopFooter extends StatelessWidget {
  const DesktopFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: 0.60 * height,
      color: Colors.grey[900],
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 80.0, right: 80.0),
        child: Column(
          children: [
            SizedBox(height: 80),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "CROSSFADED",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.anton(
                            color: Colors.amber,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "CrossFaded is a modern smoking accessories brand offering premium grinders, ashtrays, storage solutions, and lifestyle essentials. We combine quality, style, and functionality to deliver products that elevate every smoking experience.",
                          style: GoogleFonts.abel(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 50),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Navigation",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.mulish(
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
                            context.go('/');
                          },
                          child: Text(
                            "Home",
                            textAlign: TextAlign.start,
                            style: GoogleFonts.abel(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        // InkWell(
                        //   splashColor: Colors.transparent,
                        //   highlightColor: Colors.transparent,
                        //   hoverColor: Colors.transparent,
                        //   focusColor: Colors.transparent,
                        //   onTap: () {
                        //     // context.go('/aboutus');
                        //   },
                        //   child: Text(
                        //     "",
                        //     // "About us",
                        //     textAlign: TextAlign.start,
                        //     style: GoogleFonts.abel(
                        //       color: Colors.grey,
                        //       fontWeight: FontWeight.w600,
                        //     ),
                        //   ),
                        // ),
                        SizedBox(height: 10),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          onTap: () {
                            context.go('/shop');
                          },
                          child: Text(
                            "Our Shop",
                            style: GoogleFonts.abel(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          onTap: () {
                            context.go('/contactus');
                          },
                          child: Text(
                            "Contact us",
                            style: GoogleFonts.abel(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 50),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Quick Links",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.mulish(
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
                            if (FirebaseAuth.instance.currentUser == null) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AuthenticationWidget();
                                },
                              );
                            } else {
                              context.go('/account');
                            }
                          },
                          child: Text(
                            "My Account",
                            textAlign: TextAlign.start,
                            style: GoogleFonts.abel(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
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
                          child: Text(
                            "My Cart",
                            textAlign: TextAlign.start,
                            style: GoogleFonts.abel(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
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
                              context.go('/orders');
                            }
                          },
                          child: Text(
                            "My Orders",
                            style: GoogleFonts.abel(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          onTap: () {
                            context.go('/contactus');
                          },
                          child: Text(
                            "Contact Us",
                            style: GoogleFonts.abel(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 50),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Contact us",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.mulish(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30),
                        Text(
                          "Need help ?",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.abel(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "+233 54 323 6328",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.abel(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              "Address:",
                              style: GoogleFonts.abel(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 15),
                            Text(
                              "Accra Ghana",
                              style: GoogleFonts.abel(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              "Email",
                              style: GoogleFonts.abel(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 15),
                            Text(
                              "info@crossfadedgh.com",
                              style: GoogleFonts.abel(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 50),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Newsletter",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.mulish(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30),
                        Text(
                          "Sign up for our mailing list to get latest Updates and offers.",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.abel(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                height: 0.055 * height,
                                width: width,
                                decoration: BoxDecoration(color: Colors.white),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10.0,
                                    right: 10.0,
                                  ),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Email",
                                      hintStyle: GoogleFonts.aboreto(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                height: 0.055 * height,
                                width: width,
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Subscribe",
                                  style: GoogleFonts.mulish(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: width,
              height: 0.10 * height,
              child: Text(
                "© ${DateTime.now().year} CrossFaded GH. All Rights Reserved.",
                style: GoogleFonts.mulish(color: Colors.white, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MobileFooter extends StatelessWidget {
  const MobileFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width,

      color: Colors.black,
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "CROSSFADED",
              textAlign: TextAlign.start,
              style: GoogleFonts.anton(
                color: Colors.amber,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "CrossFaded is a modern smoking accessories brand offering premium grinders, ashtrays, storage solutions, and lifestyle essentials. We combine quality, style, and functionality to deliver products that elevate every smoking experience.",
              style: GoogleFonts.abel(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Quick Links",
              textAlign: TextAlign.start,
              style: GoogleFonts.mulish(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  onTap: () {
                    context.go('/');
                  },
                  child: Text(
                    "Home",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.abel(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  onTap: () {
                    context.go('/aboutus');
                  },
                  child: Text(
                    "About us",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.abel(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  onTap: () {
                    context.go('/shop');
                  },
                  child: Text(
                    "Our Shop",
                    style: GoogleFonts.abel(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  onTap: () {
                    context.go('/contactus');
                  },
                  child: Text(
                    "Contact us",
                    style: GoogleFonts.abel(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Contact us",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.mulish(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Need help ?",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.abel(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "+233 54 323 6328",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.abel(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "Address:",
                      style: GoogleFonts.abel(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 15),
                    Text(
                      "Accra Ghana",
                      style: GoogleFonts.abel(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "Email",
                      style: GoogleFonts.abel(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 15),
                    Text(
                      "info@crossfadedgh.com",
                      style: GoogleFonts.abel(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 30),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Newsletter",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.mulish(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Sign up for our mailing list to get latest Updates and offers.",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.abel(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 0.060 * height,
                        width: width,
                        decoration: BoxDecoration(color: Colors.white),
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                            right: 10.0,
                          ),

                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Email",
                              hintStyle: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 0.060 * height,
                        width: width,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Subscribe",
                          style: GoogleFonts.mulish(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            SizedBox(
              width: width,
              height: 0.10 * height,
              child: Text(
                "© ${DateTime.now().year} CrossFaded GH. All Rights Reserved.",
                style: GoogleFonts.mulish(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
