import 'package:custom_note/elements/data_format.dart';
import 'package:flutter/material.dart';

// tabs
import 'tabs/solo_tab.dart';

//provider

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //navi index
  int _selectedIndex = 0;
  //navi tabs
  final List<Widget> _widgetOptions = SoloSort.values
      .map((SoloSort soloSort) => SoloTab(soloSort: soloSort))
      .toList();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   // backgroundColor:
      //   //     Theme.of(context).colorScheme.background.withOpacity(0.01),
      //   surfaceTintColor:
      //       Theme.of(context).colorScheme.primary.withOpacity(0.1),
      // ),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:
            Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
        type: BottomNavigationBarType.fixed,
        items: SoloSort.values.map((SoloSort soloSort) {
          BottomNavigationBarItem item = BottomNavigationBarItem(
              icon: Icon(soloIconMap[soloSort]), label: soloSort.name);
          return item;
        }).toList(),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
