import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TherapyPage extends ConsumerStatefulWidget {
  const TherapyPage({super.key});

  @override
  _TherapyPage createState() => _TherapyPage();
}

class _TherapyPage extends ConsumerState<TherapyPage> {
  int pageNum = 1;
  void getPageNum(int index) {
    setState(() {
      pageNum = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SingleChildScrollView(
        child: Column(
      children: [Text("0"), Text("0")],
    ));
  }
}
