import 'package:a4s/myPage/myPage.dart';
import 'package:a4s/therapy/therapy.dart';
import 'package:flutter/material.dart';
import 'package:a4s/alarm/alarm.dart';
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
  final List _pages = [const TherapyPage(), const AlarmPage(), const MyPage()];

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this, initialIndex: 1);
    _navigatorKeyList =
        List.generate(_pages.length, (index) => GlobalKey<NavigatorState>());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return !(await _navigatorKeyList[_selectedIdx]
            .currentState!
            .maybePop());
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: AppBar(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            elevation: 0.0,
            leadingWidth: 0,
            titleSpacing: 0,
            title: Container(
              height: 80,
              child: Image.asset(
                "assets/logo.png",
                width: 150,
                height: double.maxFinite,
              ),
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
        bottomNavigationBar: SizedBox(
          height: 70,
          child: TabBar(
            controller: controller,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Color(0xff6694ff)),
            indicatorSize: TabBarIndicatorSize.tab,
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.white,
            labelStyle:
                const TextStyle(fontSize: 10, fontWeight: FontWeight.w100),
            labelPadding: EdgeInsets.symmetric(vertical: 5),
            onTap: (index) {
              setState(() {
                _selectedIdx = index;
              });
            },
            tabs: [
              Tab(
                child: Text(
                  '디지털',
                  textAlign: TextAlign.center,
                ),
                icon: Image.asset(
                  'assets/navbar/therapy.png',
                  width: 24,
                  height: 24,
                  color: controller.index == 0 ? Colors.white : Colors.grey,
                ),
              ),
              Tab(
                text: '알람',
                icon: Image.asset(
                  'assets/navbar/alarm.png',
                  width: 24,
                  height: 24,
                  color: controller.index == 1 ? Colors.white : Colors.grey,
                ),
              ),
              Tab(
                text: '내 정보',
                icon: Image.asset(
                  'assets/navbar/user.png',
                  width: 24,
                  height: 24,
                  color: controller.index == 2 ? Colors.white : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
