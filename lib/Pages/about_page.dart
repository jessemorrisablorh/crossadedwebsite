import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Widgets/header.dart';
import '../Widgets/footer.dart';
import '../Widgets/essentials.dart';
import '../Widgets/responsive_layout.dart';
import '../Widgets/mobile_drawer.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile =
        ResponsiveLayout.isMobile(context) ||
        ResponsiveLayout.isTablet(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      endDrawer: isMobile ? MobileDrawer() : null,
      appBar: isMobile ? Header() : null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (!isMobile) const DesktopHeader(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20.0 : 80.0,
                vertical: isMobile ? 40.0 : 80.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "About Us",
                    style: GoogleFonts.raleway(
                      color: Colors.white,
                      fontSize: isMobile ? 28 : 38,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Get to know CrossFaded GH",
                    style: GoogleFonts.raleway(
                      color: Colors.amber,
                      fontSize: isMobile ? 14 : 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 40),

                  isMobile
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildAboutContent(isMobile),
                            const SizedBox(height: 30),
                            _buildAboutImage(isMobile),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: _buildAboutContent(isMobile),
                            ),
                            const SizedBox(width: 50),
                            Expanded(
                              flex: 2,
                              child: _buildAboutImage(isMobile),
                            ),
                          ],
                        ),
                ],
              ),
            ),
            const Footer(),
          ],
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

  Widget _buildAboutContent(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "OUR STORY",
          style: GoogleFonts.raleway(
            color: Colors.amber,
            fontSize: isMobile ? 18 : 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 15),
        Text(
          "Founded with a passion for quality and design, CrossFaded GH has grown into a leading modern smoking accessories brand. We curate premium products that seamlessly blend aesthetic appeal with superior functionality, redefining the lifestyle experience.",
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: isMobile ? 14 : 16,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 30),
        Text(
          "OUR MISSION",
          style: GoogleFonts.raleway(
            color: Colors.amber,
            fontSize: isMobile ? 18 : 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 15),
        Text(
          "We strive to elevate everyday experiences by offering products that are not only functional but also art pieces in their own right. From sleek, medical-grade grinders to artistically designed ashtrays and secure storage solutions, we believe every accessory should reflect personal style.",
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: isMobile ? 14 : 16,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 30),
        Text(
          "WHY CHOOSE US",
          style: GoogleFonts.raleway(
            color: Colors.amber,
            fontSize: isMobile ? 18 : 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 15),
        _buildBulletPoint(
          "Premium Quality",
          "We use durable, high-grade materials that stand the test of time.",
          isMobile,
        ),
        _buildBulletPoint(
          "Modern Design",
          "Our products combine sleek minimalism with eye-catching aesthetics.",
          isMobile,
        ),
        _buildBulletPoint(
          "Customer Focus",
          "We offer exceptional customer support and reliable delivery.",
          isMobile,
        ),
      ],
    );
  }

  Widget _buildBulletPoint(String title, String description, bool isMobile) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.amber, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: isMobile ? 13 : 15,
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text: "$title: ",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutImage(bool isMobile) {
    return Container(
      height: isMobile ? 250 : 400,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.amber.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
        image: const DecorationImage(
          image: AssetImage("images/crushers.jpeg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
