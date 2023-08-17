import 'package:flutter/material.dart';
import 'package:a4s/MainPage/home_page.dart';
import 'package:a4s/data/repository/auth_repository.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _Root();
}

class _Root extends State<MainPage> with SingleTickerProviderStateMixin {
  late final TabController controller;
  late List<GlobalKey<NavigatorState>> _navigatorKeyList;

  void onPressed() {
    authRepositoryProvider.signOut();
    Navigator.pop(context);
  }

  int _selectedIdx = 1;
  final List _pages = [
    const HomePage(),
  ];

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this, initialIndex: 2);
    _navigatorKeyList =
        List.generate(_pages.length, (index) => GlobalKey<NavigatorState>());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !(await _navigatorKeyList[_selectedIdx]
            .currentState!
            .maybePop());
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          leadingWidth: 0,
          titleSpacing: 0,
          title: Image.asset(
            "/logo.png",
            width: 120,
            height: double.maxFinite,
          ),
          shape: const Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
        ),
        body: IndexedStack(
          index: _selectedIdx,
          children: _pages.map((page) {
            int idx = _pages.indexOf(page);
            return Navigator(
              key: _navigatorKeyList[idx],
              onGenerateRoute: (_) {
                return MaterialPageRoute(builder: (context) => page);
              },
            );
          }).toList(),
        ),
        bottomNavigationBar: TabBar(
          controller: controller,
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Color(0xff6694ff)),
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(fontSize: 10),
          labelPadding: EdgeInsets.zero,
          onTap: (index) {
            setState(() {
              _selectedIdx = index;
            });
          },
          tabs: [
            Tab(
              text: '디지털\n테라퓨틱스',
              icon: Image.asset(
                'navbar/therapy.png',
                width: 25,
                height: 25,
                color: controller.index == 0
                    ? const Color.fromRGBO(14, 32, 87, 1)
                    : Colors.grey,
              ),
            ),
            Tab(
              text: '알람',
              icon: Image.asset(
                'navbar/alarm.png',
                width: 25,
                height: 25,
                color: controller.index == 1
                    ? const Color.fromRGBO(14, 32, 87, 1)
                    : Colors.grey,
              ),
            ),
            Tab(
              text: '내 정보',
              icon: Image.asset(
                'navbar/user.png',
                width: 25,
                height: 25,
                color: controller.index == 2
                    ? const Color.fromRGBO(14, 32, 87, 1)
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
