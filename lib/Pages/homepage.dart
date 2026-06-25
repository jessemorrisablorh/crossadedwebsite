import 'package:cross_faded_web/Widgets/categariesbar.dart';
import 'package:cross_faded_web/Widgets/essentials.dart';
import 'package:cross_faded_web/Widgets/firstblock.dart';
import 'package:cross_faded_web/Widgets/footer.dart';
import 'package:cross_faded_web/Widgets/header.dart';
import 'package:cross_faded_web/Widgets/lastblock.dart';
import 'package:cross_faded_web/Widgets/productsbar.dart';
import 'package:cross_faded_web/Widgets/slider.dart';
import 'package:cross_faded_web/Widgets/mobile_drawer.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return const DesktopHomepage();
        } else if (constraints.maxWidth > 800 && constraints.maxWidth <= 1200) {
          return const DesktopHomepage();
        } else {
          return const MobileHomepage();
        }
      },
    );
  }
}

class DesktopHomepage extends StatelessWidget {
  const DesktopHomepage({super.key});

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
            DesktopSlider(),
            Firstblock(),
            DesktopCategoriesBar(),
            DesktopProductsBar(),
            DesktopLastBlock(),
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

class MobileHomepage extends StatelessWidget {
  const MobileHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: MobileDrawer(),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            MobileHeader(),
            MobileSlider(),
            MobileCategoriesBar(),
            MobileProductsBar(),
            MobileFooter(),
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
}
