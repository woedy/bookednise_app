import 'dart:convert';
import 'dart:io';

import 'package:bookednise_app/Authentication/Login/login_screen.dart';
import 'package:bookednise_app/Bookings/user_bookings.dart';
import 'package:bookednise_app/Components/generic_error_dialog_box.dart';
import 'package:bookednise_app/Components/generic_loading_dialogbox.dart';
import 'package:bookednise_app/Components/generic_success_dialog_box.dart';
import 'package:bookednise_app/Components/keyboard_utils.dart';
import 'package:bookednise_app/Components/photos/select_photo_options_screen.dart';
import 'package:bookednise_app/Components/sho_dialog.dart';
import 'package:bookednise_app/Profile/UserProfile.dart';
import 'package:bookednise_app/Profile/models/user_profile_models.dart';
import 'package:bookednise_app/Profile/reset_password_profile.dart';
import 'package:bookednise_app/ShopView/shops_screen.dart';
import 'package:bookednise_app/HomeScreen/home_screen.dart';
import 'package:bookednise_app/Message/chat_screen.dart';
import 'package:bookednise_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:http/http.dart' as http;

Future<UserProfileModel> updateProfile(data) async {
  var token = await getApiPref();

  print(token);
  print(data);

  final url = Uri.parse(hostName + "user-profile/update-user-profile/");
  final request = http.MultipartRequest('POST', url);

  request.headers['Accept'] = 'application/json';
  request.headers['Content-Type'] = 'multipart/form-data';
  request.headers['Authorization'] = 'Token ' + token.toString();

  if (data["photo"] != "") {
    request.files
        .add(await http.MultipartFile.fromPath('photo', data["photo"]));
  } else {
    // Handle the case where the photo is null, such as skipping the file addition
    // request.files.add(await http.MultipartFile.fromString('photo', ''));
  }

  request.fields['user_id'] = data["user_id"];
  request.fields['full_name'] = data["full_name"];
  request.fields['email'] = data["email"];
  request.fields['phone'] = data["phone"];
  request.fields['country'] = data["country"];

  try {
    final response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseBody = await response.stream.bytesToString();
      final result = json.decode(responseBody);

      print("############");
      print("WE ARE INNNNNNNN");
      print(result);

      return UserProfileModel.fromJson(result);
    } else if (response.statusCode == 422 ||
        response.statusCode == 403 ||
        response.statusCode == 400) {
      final responseBody = await response.stream.bytesToString();
      final result = json.decode(responseBody);

      print("############");
      print("ERRORRRRRR");
      print(result);

      return UserProfileModel.fromJson(result);
    } else {
      throw Exception('Failed to Update');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Failed to Update');
  }
}

class EditProfile extends StatefulWidget {
  final userData;
  const EditProfile({super.key, required this.userData});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  Map<String, dynamic> userData = {};

  final _formKey = GlobalKey<FormState>();
  FocusNode focusNode = FocusNode();

  Future<UserProfileModel>? _futureUpdateProfile;

  File? _image;

  String? full_name;
  String? phone;
  String? email;
  String? _code;
  String? _number;
  String? country;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (_futureUpdateProfile == null)
        ? buildColumn()
        : buildFutureBuilder();
  }

  buildColumn() {
    return Scaffold(
      body: Container(
        child: SafeArea(
          bottom: false,
          top: false,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  //color: bookPrimary,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(7),
                    bottomLeft: Radius.circular(7),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 35,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: const Icon(
                                Icons.arrow_back,
                                size: 25,
                                color: bookPrimary,
                              )),
                          Text(
                            "Edit Profile",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: bookPrimary),
                          ),
                          Icon(
                            Icons.search,
                            size: 20,
                            color: bookPrimary,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(left: 0, right: 0, top: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          _showSelectPhotoOptions(context);
                        },
                        child: _image == null
                            ? Stack(
                                children: [
                                  Container(
                                    width: 150.0,
                                    height: 150.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color:
                                            bookPrimary, // First stroke color
                                        width: 5.0, // First stroke width
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: Image.network(
                                        hostNameMedia +
                                            widget.userData.photo.toString(),
                                        width: 90.0,
                                        height: 90.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      left: 0,
                                      right: 0,
                                      top: 0,
                                      bottom: 0,
                                      child: Icon(
                                        Icons.photo_camera_outlined,
                                        size: 20,
                                        color: Colors.white,
                                      ))
                                ],
                              )
                            : Stack(
                                children: [
                                  Container(
                                    width: 180.0,
                                    height: 180.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: bookDark2, // First stroke color
                                        width: 10.0, // First stroke width
                                      ),
                                    ),
                                    child: Container(
                                      width: 110.0,
                                      height: 110.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color:
                                              bookPrimary, // First stroke color
                                          width: 10.0, // First stroke width
                                        ),
                                      ),
                                      child: ClipOval(
                                        child: Image.file(
                                          _image!,
                                          width: 90.0,
                                          height: 90.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      left: 0,
                                      right: 0,
                                      top: 0,
                                      bottom: 0,
                                      child: Icon(
                                        Icons.photo_camera_outlined,
                                        size: 80,
                                        color: Colors.white,
                                      ))
                                ],
                              ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResetPasswordProfile(
                                      email:
                                          widget.userData.email.toString())));
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(20),
                          //height: 50,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: bookPrimary,
                              borderRadius: BorderRadius.circular(7)),
                          child: Center(
                            child: Text(
                              "Change Password",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                    decoration: InputDecoration(
                                      //hintText: 'Enter Username/Email',

                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.normal),
                                      labelText: "Full name",
                                      labelStyle: TextStyle(
                                          fontSize: 10,
                                          color: Colors.black.withOpacity(0.5)),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 5.0, horizontal: 12.0),
                                      // Add an underline
                                      border: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: bookDark2),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: bookPrimary),
                                      ),
                                    ),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(225),
                                      PasteTextInputFormatter(),
                                    ],
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Full name is required';
                                      }
                                      if (value.length < 3) {
                                        return 'Full name too short';
                                      }
                                    },
                                    initialValue:
                                        widget.userData.fullName.toString(),
                                    textInputAction: TextInputAction.next,
                                    autofocus: false,
                                    onSaved: (value) {
                                      setState(() {
                                        full_name = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Contact Number",
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  IntlPhoneField(
                                    focusNode: focusNode,
                                    style: const TextStyle(
                                        height: 3,
                                        color: Colors.black,
                                        fontSize: 14),
                                    dropdownIcon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.grey,
                                    ),
                                    decoration: InputDecoration(
                                      // Remove labelText as it was commented out in the original code
                                      // Use UnderlineInputBorder instead of OutlineInputBorder
                                      border: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Colors.black.withOpacity(0.4)),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: bookPrimary),
                                      ),
                                      // Remove borderRadius as it's not applicable to UnderlineInputBorder
                                    ),
                                    languageCode: "en",
                                    initialCountryCode: "GH",
                                    validator: (e) {
                                      if (e == null) {
                                        return 'Phone Number required';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      _code = value.countryCode.toString();
                                      _number = value.number.toString();
                                      country = value.countryISOCode.toString();
                                    },
                                    onCountryChanged: (country) {},
                                    onSaved: (value) {
                                      setState(() {
                                        _code = value!.countryCode.toString();
                                        _number = value.number.toString();
                                        country =
                                            value.countryISOCode.toString();
                                      });
                                    },
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black),
                                    decoration: InputDecoration(
                                      hintStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.normal),
                                      labelText: "Email",
                                      labelStyle: TextStyle(
                                          fontSize: 10,
                                          color: Colors.black.withOpacity(0.5)),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 5.0, horizontal: 12.0),

                                      // Add an underline
                                      border: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: bookDark2),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: bookPrimary),
                                      ),
                                    ),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(225),
                                      PasteTextInputFormatter(),
                                    ],
                                    initialValue: widget.userData.email,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Email is required';
                                      }
                                      String pattern =
                                          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                          r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                          r"{0,253}[a-zA-Z0-9])?)*$";
                                      RegExp regex = RegExp(pattern);
                                      if (!regex.hasMatch(value)) {
                                        return 'Enter a valid email address';
                                      }
                                      return null;
                                    },
                                    textInputAction: TextInputAction.next,
                                    autofocus: false,
                                    onSaved: (value) {
                                      setState(() {
                                        email = value;
                                      });
                                    },
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            KeyboardUtil.hideKeyboard(context);

                            phone = _code.toString() + _number.toString();
/*
                                print("##################");
                                print(full_name);
                                print(phone);
                                print(email);
                                print(_code);
                                print(_number);
                                print(country);*/

                            var _data = {
                              "user_id": widget.userData["user_id"],
                              "full_name": full_name,
                              "phone": phone,
                              "email": email,
                              "country": country,
                              "photo": _image != null ? _image!.path : ""
                            };

                            print(_data);

                            _futureUpdateProfile = updateProfile(_data);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(15),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: bookPrimary,
                              borderRadius: BorderRadius.circular(7)),
                          child: Center(
                            child: Text(
                              "Update Profile",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<UserProfileModel> buildFutureBuilder() {
    return FutureBuilder<UserProfileModel>(
        future: _futureUpdateProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingDialogBox(
              text: 'Please Wait..',
            );
          } else if (snapshot.hasData) {
            var data = snapshot.data!;

            print("#########################");
            //print(data.data!.token!);

            if (data.message == "Successful") {
              var _data = {
                "user_id": data.data!.userId,
                "email": data.data!.email,
                "full_name": data.data!.fullName,
                "phone": data.data!.phone,
                "country": data.data!.country,
                "photo": data.data!.photo,
              };

              saveUserData(_data);

              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfile()),
                );

                showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (BuildContext context) {
                      // Show the dialog
                      return SuccessDialogBox(
                          text: "Profile Update Successful");
                    });
              });
            } else if (data.message == "Errors") {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                /*    Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Registration1()),
                      (route) => false,
                );
*/

                showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (BuildContext context) {
                      // Show the dialog
                      return ErrorDialogBox(text: "Unable update info");
                    });
              });
            }
          }

          return LoadingDialogBox(
            text: 'Please Wait..',
          );
        });
  }

  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      img = await _cropImage(imageFile: img);
      setState(() {
        _image = img;
        Navigator.of(context).pop();
      });
    } on PlatformException catch (e) {
      print(e);
      Navigator.of(context).pop();
    }
  }

  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  void _showSelectPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.28,
          maxChildSize: 0.4,
          minChildSize: 0.28,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: SelectPhotoOptionsScreen(
                onTap: _pickImage,
              ),
            );
          }),
    );
  }

  void dispose() {
    super.dispose();
  }
}
