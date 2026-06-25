import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: SizedBox(
        height: 25,
        width: 25,
        child: CircularProgressIndicator(color: Colors.amber, strokeWidth: 3),
      ),
    );
  }
}
