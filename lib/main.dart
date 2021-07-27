import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:ui/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clubhouse App',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          // primarySwatch: Colors.green,
          fontFamily: 'Cairo',
          scaffoldBackgroundColor: kBackgroundColor,
          textTheme:
              Theme.of(context).textTheme.apply(displayColor: kTextColor)),
      home: new HomeScreen(),
      // home: MyHomePage(title: 'Flutter Demo Home Page1'),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    getBodyPageWidget(int index) {
      switch (index) {
        case 0:
          return new _AvailableRoomListWidget();
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Title'),
          backgroundColor: kBackgroundColor,
          elevation: 1,
          leading: IconButton(
              onPressed: () {},
              icon: Badge(
                child: Icon(
                  Icons.email,
                  color: Colors.black,
                ),
                badgeColor: Colors.green,
                position: BadgePosition.topEnd(top: 1, end: -1),
              )),
          actions: <Widget>[
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.calendar_today,
                  color: Colors.black,
                )),
            IconButton(
                onPressed: () {},
                icon: Badge(
                  child: Icon(
                    Icons.notifications,
                    color: Colors.black,
                  ),
                  badgeColor: Colors.green,
                  badgeContent: Text(
                    '3',
                    // style: TextStyle(color: Colors.red),
                  ),
                )),
            AnimatedContainer(
                duration: Duration(seconds: 2),
                curve: Curves.easeIn,
                child: Container(
                  padding: EdgeInsets.all(5),
                  width: 60,
                  height: 50,
                  child: Material(
                      borderRadius: BorderRadius.circular(50),
                      child: InkWell(
                        onTap: () {},
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            width: 32,
                            height: 32,
                            fit: BoxFit.cover,
                            imageUrl:
                                'https://lh3.googleusercontent.com/ogw/ADea4I7Abb9tQqHg2l2zJ-9Ifg4JjZgylFIi8yDJYfxzZA=s32-c-mo',
                          ),
                        ),
                      )),
                )),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Room',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.contacts),
              label: 'Contacts',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[900],
          unselectedItemColor: Colors.black,
          onTap: _onItemTapped,
        ),
        body: getBodyPageWidget(_selectedIndex));
  }
}

class _AvailableRoomListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.lightGreen,
        child: Center(
          child: Text('Room List'),
        ),
      ),
    );
  }
}
