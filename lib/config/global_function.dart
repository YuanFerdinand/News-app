import 'package:flutter/material.dart';

class GlobalFunction {
  var scrollController = ScrollController();
  void setLoading(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
