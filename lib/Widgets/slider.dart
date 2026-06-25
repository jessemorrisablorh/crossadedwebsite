import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DesktopSlider extends StatefulWidget {
  const DesktopSlider({super.key});

  @override
  State<DesktopSlider> createState() => _DesktopSliderState();
}

class _DesktopSliderState extends State<DesktopSlider> {
  final PageController sliderController = PageController();
  int _currentPage = 0;
  Timer? _timer;
  void _startAutoSlide(int itemCount) {
    _timer?.cancel(); // Cancel any previous timer
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (sliderController.hasClients && itemCount > 0) {
        _currentPage = (_currentPage + 1) % itemCount;
        sliderController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 15.0),
      child: SizedBox(
        height: 0.70 * height,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("sliders").snapshots(),
          builder: (context, slidersnapshot) {
            if (!slidersnapshot.hasData || slidersnapshot.data!.docs.isEmpty) {
              return Container(
                height: 0.70 * height,
                width: width,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    "",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ),
              );
            }
            // Start auto-slide with the number of items
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _startAutoSlide(slidersnapshot.data!.docs.length);
            });
            return PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: sliderController,
              itemCount: slidersnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 0.70 * height,
                  width: width,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    image: DecorationImage(
                      image: NetworkImage(
                        slidersnapshot.data!.docs[index]["image"],
                      ),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class MobileSlider extends StatefulWidget {
  const MobileSlider({super.key});

  @override
  State<MobileSlider> createState() => _MobileSliderState();
}

class _MobileSliderState extends State<MobileSlider> {
  final PageController sliderController = PageController();
  int _currentPage = 0;
  Timer? _timer;
  void _startAutoSlide(int itemCount) {
    _timer?.cancel(); // Cancel any previous timer
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (sliderController.hasClients && itemCount > 0) {
        _currentPage = (_currentPage + 1) % itemCount;
        sliderController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
      child: SizedBox(
        height: 0.30 * height,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("sliders").snapshots(),
          builder: (context, slidersnapshot) {
            if (!slidersnapshot.hasData || slidersnapshot.data!.docs.isEmpty) {
              return Container(
                height: 0.30 * height,
                width: width,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    "No slides available",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
              );
            }
            // Start auto-slide with the number of items
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _startAutoSlide(slidersnapshot.data!.docs.length);
            });
            return PageView.builder(
              controller: sliderController,
              itemCount: slidersnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 0.30 * height,
                  width: width,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    image: DecorationImage(
                      image: NetworkImage(
                        slidersnapshot.data!.docs[index]["image"],
                      ),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
