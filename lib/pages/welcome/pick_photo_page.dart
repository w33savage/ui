import 'dart:io';
import 'package:club_house/services/authenticate.dart';
import 'package:club_house/util/history.dart';
import 'package:club_house/widgets/round_button.dart';
import 'package:club_house/util/style.dart';
import 'package:club_house/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ref:  https://medium.com/fabcoding/adding-an-image-picker-in-a-flutter-app-pick-images-using-camera-and-gallery-photos-7f016365d856
class PickPhotoPage extends StatefulWidget {
  @override
  _PickPhotoPageState createState() => _PickPhotoPageState();
}

class _PickPhotoPageState extends State<PickPhotoPage> {
  final ImagePicker _picker = ImagePicker();

  XFile _image;

  _imgFromCamera() async {
    // Capture a photo
    final XFile photo =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = photo;
    });
  }

  _imgFromGallery() async {
    // Pick an image
    final XFile image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          buildActionButton(context),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(
          top: 30,
          bottom: 60,
        ),
        child: Column(
          children: [
            buildTitle(),
            Spacer(
              flex: 1,
            ),
            buildContents(),
            Spacer(
              flex: 3,
            ),
            buildBottom(),
          ],
        ),
      ),
    );
  }

  Widget buildActionButton(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: GestureDetector(
        onTap: () {
          History.pushPageReplacement(context, HomePage());
        },
        child: Text(
          'Skip',
          style: TextStyle(
            color: Style.DarkBrown,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildTitle() {
    return Text(
      'Great! Now add a photo?',
      style: TextStyle(
        fontSize: 25,
      ),
    );
  }

  Widget buildContents() {
    return Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(80),
        ),
        child: GestureDetector(
            onTap: () {
              _showPicker(context);
            },
            child: _image != null
                ? CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: Image.file(
                        File(this._image.path),
                        width: 160,
                        height: 160,
                        fit: BoxFit.fitWidth,
                      ),
                    ))
                : Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 100,
                    color: Style.AccentBlue,
                  )));
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget buildBottom() {
    return RoundButton(
      color: Style.AccentBlue,
      minimumWidth: 230,
      disabledColor: Style.AccentBlue.withOpacity(0.3),
      onPressed: () async {
        if (this._image != null) {
          try {
            await AuthService().uploadProfilePic(this._image);
            History.pushPageReplacement(context, HomePage());
          } catch (e) {
            print(e.message);
          }
        }
      },
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Next',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            Icon(
              Icons.arrow_right_alt,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
