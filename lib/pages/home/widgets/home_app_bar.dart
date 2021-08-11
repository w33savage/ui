import 'package:club_house/models/user.dart';
import 'package:club_house/services/authenticate.dart';
import 'package:club_house/widgets/round_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({Key key, this.profile, this.onProfileTab})
      : super(key: key);

  final User profile;
  final Function onProfileTab;
  @override
  _HomeAppBarPageState createState() => _HomeAppBarPageState();
}

class _HomeAppBarPageState extends State<HomeAppBar> {
  String _profilePic;
  User profile;
  _HomeAppBarPageState({this.profile});

  Future<void> downloadURLExample() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference =
        storage.ref().child("profileImages/${AuthService().getUid()}");
    var downloadUrl = await reference.getDownloadURL();
    setState(() {
      _profilePic = downloadUrl;
    });

    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          child: IconButton(
            onPressed: () {},
            iconSize: 30,
            icon: Icon(Icons.search),
          ),
        ),
        Spacer(),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              iconSize: 30,
              icon: Icon(Icons.mail),
            ),
            SizedBox(
              width: 10,
            ),
            IconButton(
              onPressed: () {},
              iconSize: 30,
              icon: Icon(Icons.calendar_today),
            ),
            SizedBox(
              width: 10,
            ),
            IconButton(
              onPressed: () {},
              iconSize: 30,
              icon: Icon(Icons.notifications_active_outlined),
            ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: widget.onProfileTab,
              child: (downloadURLExample().toString() == null)
                  ? RoundImage(
                      path: profile.profileImage,
                      width: 40,
                      height: 40,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        _profilePic,
                        height: 40,
                        fit: BoxFit.fill,
                        width: 40,
                      )),
            )
          ],
        ),
      ],
    );
  }
}
