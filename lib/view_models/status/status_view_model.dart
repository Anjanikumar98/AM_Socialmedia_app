import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/status.dart';
import '../../posts/story/confrim_status.dart';
import '../../services/post_service.dart';
import '../../services/status_services.dart';
import '../../services/user_service.dart';
import '../../utils/constants.dart';

class StatusViewModel extends ChangeNotifier {
  //Services
  UserService userService = UserService();
  PostService postService = PostService();
  StatusService statusService = StatusService();

  //Keys
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //Variables
  bool loading = false;
  String? username;
  File? mediaUrl;
  final picker = ImagePicker();
  String? description;
  String? email;
  String? userDp;
  String? userId;
  String? imgLink;
  bool edit = false;
  String? id;

  //integers
  int pageIndex = 0;

  setDescription(String val) {
    print('SetDescription $val');
    description = val;
    notifyListeners();
  }

  //Functions
  //Functions
  pickImage({bool camera = false, BuildContext? context}) async {
    loading = true;
    notifyListeners();

    try {
      final XFile? pickedFile = await picker.pickImage(
        source: camera ? ImageSource.camera : ImageSource.gallery,
      );

      if (pickedFile == null) {
        loading = false;
        notifyListeners();
        showInSnackBar('No image selected', context);
        return;
      }

      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(
            ratioX: 1, ratioY: 1), // ✅ Updated cropping approach
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Constants.lightAccent,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            minimumAspectRatio: 1.0,
          ),
        ],
      );

      if (croppedFile != null) {
        mediaUrl = File(croppedFile.path);
        Navigator.of(context!).push(
          CupertinoPageRoute(
            builder: (_) => ConfirmStatus(),
          ),
        );
      }

      loading = false;
      notifyListeners();
    } catch (e) {
      loading = false;
      notifyListeners();
      showInSnackBar('Cancelled', context);
    }
  }

  //send message
  sendStatus(String chatId, StatusModel message) {
    statusService.sendStatus(
      message,
      chatId,
    );
  }

  //send the first message
  Future<String> sendFirstStatus(StatusModel message) async {
    String newChatId = await statusService.sendFirstStatus(
      message,
    );

    return newChatId;
  }

  resetPost() {
    mediaUrl = null;
    description = null;
    edit = false;
    notifyListeners();
  }

  void showInSnackBar(String value, context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }
}
