import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_faded_web/Widgets/essentials.dart';
import 'package:cross_faded_web/Widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class DesktopCategoriesBar extends StatelessWidget {
  const DesktopCategoriesBar({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("categories").snapshots(),
      builder: (context, asyncsnapshot) {
        if (!asyncsnapshot.hasData) {
          return SizedBox();
        }
        return Padding(
          padding: const EdgeInsets.only(left: 80.0, right: 80.0, top: 80.0),
          child: Column(
            children: [
              Text(
                "Categories",
                style: GoogleFonts.raleway(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Collect your loves with our newest arrivals.",
                style: GoogleFonts.raleway(
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
                  context.go('/categories');
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
                    "View all categories",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    onTap: () {
                      context.push(
                        '/products-by-category',
                        extra: asyncsnapshot.data!.docs[index]["name"],
                      );
                    },
                    child: categoriesCard(
                      id: asyncsnapshot.data!.docs[index]["id"],
                      image: asyncsnapshot.data!.docs[index]["image"],
                      name: asyncsnapshot.data!.docs[index]["name"],
                      height: height,
                      width: width,
                    ),
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 2 / 3,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MobileCategoriesBar extends StatelessWidget {
  const MobileCategoriesBar({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("categories").snapshots(),
      builder: (context, asyncsnapshot) {
        if (!asyncsnapshot.hasData) {
          return LoadingWidget();
        }
        return Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0),
          child: Column(
            children: [
              Text(
                "Categories",
                style: GoogleFonts.raleway(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Collect your loves with our newest arrivals.",
                style: GoogleFonts.raleway(
                  color: Colors.white,
                  fontSize: 13,
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
                  context.go('/categories');
                },
                child: Container(
                  height: 0.060 * height,
                  width: width,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "View all categories",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 2,
                itemBuilder: (context, index) {
                  final categoryName = asyncsnapshot.data!.docs[index]["name"];
                  return InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    onTap: () {
                      context.push(
                        '/products-by-category',
                        extra: categoryName,
                      );
                    },
                    child: Padding(
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
                                image: NetworkImage(
                                  asyncsnapshot.data!.docs[index]["image"],
                                ),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            asyncsnapshot.data!.docs[index]["name"],
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.aldrich(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2 / 3.3,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
