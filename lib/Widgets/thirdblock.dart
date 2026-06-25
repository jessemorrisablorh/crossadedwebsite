import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DesktopThirdBlock extends StatelessWidget {
  const DesktopThirdBlock({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(left: 80.0, right: 80.0),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Container(
              height: 0.50 * height,
              width: width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Row(
            children: [
              SizedBox(width: 80),
              Image.asset("images/cigar.png", height: 0.65 * height),
              SizedBox(width: 40),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Get the best Cigars",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 50,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Get the best Cigars",
                    style: GoogleFonts.poppins(color: Colors.black),
                  ),
                  SizedBox(height: 30),
                  Container(
                    height: 0.060 * height,
                    width: 0.17 * width,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Browse Cigars",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
