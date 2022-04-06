import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:tmcmerchant/resources/auth_methods.dart';
import 'package:tmcmerchant/screens/login_screen.dart';
import 'package:tmcmerchant/utils/colors.dart';
import 'package:tmcmerchant/utils/utils.dart';
import 'package:tmcmerchant/widgets/text_field_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _merchantnameController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  double _latitude = 0.0;
  double _longitude = 0.0;
  Uint8List? _image;
  bool _isLoading = false;
  bool _islocationLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _descriptionController.dispose();
    _merchantnameController.dispose();
    super.dispose();
  }

  void signUpMerchant() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().signUpMerchant(
        email: _emailController.text,
        password: _passController.text,
        merchantname: _merchantnameController.text,
        description: _descriptionController.text,
        latitude: _latitude.toString(),
        longitude: _longitude.toString(),
        file: _image!);
    // if string returned is sucess, user has been created
    if (res == "success") {
      setState(() {
        _isLoading = false;
        showSnackBar(context, "Id is created, Navigating to Login page");
      });
      // navigate to the home screen
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginScreen())));
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      showSnackBar(context, res);
    }
  }

  void uploadLocation() async {
    _islocationLoading = true;
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    _latitude = _locationData.latitude!;
    _longitude = _locationData.longitude!;
    Timer(const Duration(seconds: 5), () {});
    print(_latitude);
    _islocationLoading = false;
    showSnackBar(context, "Location is updated");
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  int _activeStepIndex = 0;
  List<Step> stepList() => [
        Step(
          state: _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 0,
          title: const Text("My Info"),
          content: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //circular widget to accept and show our selected file
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : const CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(
                                "https://t4.ftcdn.net/jpg/02/15/84/43/240_F_215844325_ttX9YiIIyeaR7Ne6EaLLjMAmy4GvPC69.jpg")),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                //text field for username
                TextFieldInput(
                    textEditingController: _merchantnameController,
                    hintText: 'Enter your username',
                    textInputType: TextInputType.text),
                const SizedBox(
                  height: 3,
                ),
              ],
            ),
          ),
        ),
        Step(
            state:
                _activeStepIndex <= 1 ? StepState.editing : StepState.complete,
            isActive: _activeStepIndex >= 1,
            title: const Text("Credentials"),
            content: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFieldInput(
                      textEditingController: _emailController,
                      hintText: 'Enter your email',
                      textInputType: TextInputType.emailAddress),
                  const SizedBox(
                    height: 24,
                  ),
                  //text field input for pass
                  TextFieldInput(
                    textEditingController: _passController,
                    hintText: 'Enter your password',
                    textInputType: TextInputType.text,
                    isPass: true,
                  ),
                ],
              ),
            )),
        Step(
            state:
                _activeStepIndex <= 2 ? StepState.editing : StepState.complete,
            isActive: _activeStepIndex >= 2,
            title: const Text("Cart Info"),
            content: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    child: Container(
                      child: !_islocationLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                Text(
                                  'Upload Cart Location',
                                ),
                                Icon(Icons.location_on)
                              ],
                            )
                          : const CircularProgressIndicator(
                              color: primaryColor,
                            ),
                      width: MediaQuery.of(context).size.width * 0.5,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        color: Colors.lightGreen,
                      ),
                    ),
                    onTap: uploadLocation,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextField(
                    maxLines: 10,
                    controller: _descriptionController,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.none,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: Divider.createBorderSide(context)),
                      hintText: "Enter about your Cart items",
                    ),
                    onSubmitted: (value) {
                      if (value == '') {
                        _focusNode.requestFocus();
                      }
                    },
                  ),
                ],
              ),
            ))
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 10,
                child: Stepper(
                  steps: stepList(),
                  currentStep: _activeStepIndex,
                  type: StepperType.vertical,
                  onStepContinue: () {
                    if (_activeStepIndex < stepList().length - 1) {
                      _activeStepIndex += 1;
                    }
                    setState(() {});
                    final isLastStep =
                        _activeStepIndex == stepList().length - 1;
                    if (isLastStep) {
                      signUpMerchant();
                    }
                  },
                  onStepCancel: () {
                    if (_activeStepIndex > 0) {
                      _activeStepIndex -= 1;
                    }
                    setState(() {});
                  },
                  controlsBuilder:
                      (BuildContext context, ControlsDetails controls) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: ElevatedButton(
                              onPressed: controls.onStepContinue,
                              child: Text(
                                  (_activeStepIndex == stepList().length - 1)
                                      ? 'Sign Up'
                                      : 'Next'),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          if (_activeStepIndex != 0)
                            Expanded(
                              child: ElevatedButton(
                                onPressed: controls.onStepCancel,
                                child: const Text('Back'),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: const Text("Already have an account?"),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      ),
                      child: Container(
                        child: const Text(
                          'Log In.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
