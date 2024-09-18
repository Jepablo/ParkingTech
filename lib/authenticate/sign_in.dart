import 'package:flutter/material.dart';
import 'package:parkingtechproject/Screens/navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:parkingtechproject/model/parking.dart';



class LoginScreen extends StatefulWidget {

  final Function( String? email, String? password)? onSubmitted;

  const LoginScreen({this.onSubmitted, Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String email, password;
  String? emailError, passwordError;
  Function(String? email, String? password)? get onSubmitted => widget.onSubmitted;


  @override
  void initState() {
    super.initState();
    email = "";
    password = "";

    emailError = null;
    passwordError = null;
  }

  void resetErrorText() {
    setState(() {
      emailError = null;
      passwordError = null;
    });
  }

  bool validate() {
    resetErrorText();

    RegExp emailExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    bool isValid = true;
    if (email.isEmpty || !emailExp.hasMatch(email)) {
      setState(() {
        emailError = "Email is invalid";
      });
      isValid = false;
    }

    if (password.isEmpty) {
      setState(() {
        passwordError = "Please enter a password";
      });
      isValid = false;
    }

    return isValid;
  }


  Future<void> submit() async{

    if (validate()){
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => PagesNavigate()));
        }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;


    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            SizedBox(height: screenHeight * .075),
            const Text(
              "Welcome,",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * .01),
            Text(
              "Sign in to continue!",
              style: TextStyle(
                fontSize: 28,
                color: Colors.black.withOpacity(.6),
              ),
            ),

            SizedBox(height: screenHeight * .05),
            InputField(
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
              labelText: "Email",
              errorText: emailError,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autoFocus: true,
            ),
            SizedBox(height: screenHeight * .025),
            InputField(
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
              onSubmitted: (val) => submit(),
              labelText: "Password",
              errorText: passwordError,
              obscureText: true,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(
              height: screenHeight * .075,
            ),
            FormButton(
                text: "Log In",
                onPressed: submit
            ),
            SizedBox(
              height: screenHeight * .05,
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RegisterScreen(),
                ),
              ),
              child: RichText(
                text: const TextSpan(
                  text: "I'm a new user, ",
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: "Sign Up",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  // Callback for when this form is submitted successfully. Parameters are (email, password)
  final Function(String? name, String? plate, String? phone, String? email, String? password, String? userName, String? geo)? onSubmitted;

  const RegisterScreen({this.onSubmitted, Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String name, email, phone, plate, password, confirmPassword , userName,geo;
  String? nameError,fullnameError,carplateError,phoneError, emailError, passwordError;
  Function(String? fullname, String? plate, String? phone, String? email, String? password, String? userName,String? geo)? get onSubmitted => widget.onSubmitted;

  @override
  void initState() {
    super.initState();
    name = "";
    plate = "";
    email = "";
    phone = "";
    userName = "";
    password = "";
    confirmPassword = "";
    geo = "";

    nameError = null;
    fullnameError = null;
    carplateError = null;
    phoneError = null;
    emailError = null;
    passwordError = null;
  }

  void resetErrorText() {
    setState(() {
      nameError = null;
      fullnameError = null;
      carplateError = null;
      phoneError = null;
      emailError = null;
      passwordError = null;
    });
  }

  bool validate() {
    resetErrorText();

    RegExp emailExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    bool isValid = true;

    if (email.isEmpty || !emailExp.hasMatch(email)) {
      setState(() {
        emailError = "Email is invalid";
      });
      isValid = false;
    }

    if (password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        passwordError = "Please enter a password";
      });
      isValid = false;
    }
    if (password != confirmPassword) {
      setState(() {
        passwordError = "Passwords do not match";
      });
      isValid = false;
    }
    if(phone.isEmpty){
      setState((){
        phoneError = "Please enter phone number";
      });
      isValid = false;
    }
    if(phone.length >11){
      setState((){
        phoneError = "Phone number exceed limits";
      });
    }

    if(plate.isEmpty){
      setState((){
        carplateError = "Please register your car plate number";
      });
      isValid = false;
    }
    if(name.isEmpty ){
      setState((){
        fullnameError = "Please enter your full name";
      });
      isValid = false;
    }
    if(userName.isEmpty){
      setState((){
        nameError = "Please enter a username";
      });
      isValid = false;
    }
    return isValid;
  }


  Future<void> submit() async{
    // final newUser = await _auth.createUserWithEmailAndPassword(email: ema
    // il, password: password).then((value) => {postDetailsToFirestore()});
    if (validate()){
       await _auth.createUserWithEmailAndPassword(email: email, password: password).then((value) => {postDetailsToFirestore()});
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) =>  LoginScreen()));
    
    }
  }


  postDetailsToFirestore() async{
    //calling Firestore
    //calling user model
    //sending value
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    Parking userModel = Parking();

    userModel.name = name;
    userModel.car = plate;
    userModel.uid = user?.uid;
    userModel.num = phone;
    userModel.email = email;
    userModel.userName = userName;
    userModel.geo = "";

    await firebaseFirestore
        .collection("parkingTech")
        .doc(user?.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg:"Account created");

    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context) => PagesNavigate()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            SizedBox(height: screenHeight * .04),
            const Text(
              "Create Account,",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * .01),
            Text(
              "Sign up to get started!",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black.withOpacity(.6),
              ),
            ),
            SizedBox(height: screenHeight * .025),
            InputField(
              onChanged: (value) {
                setState(() {
                  userName = value;
                });
              },
              labelText: "User Name",
              errorText: nameError,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              autoFocus: true,
            ),
            SizedBox(height: screenHeight * .025),
            InputField(
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
              labelText: "Full Name",
              errorText: fullnameError,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              autoFocus: true,
            ),
            SizedBox(height: screenHeight * .025),
            InputField(
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
              labelText: "Email Address",
              errorText: emailError,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autoFocus: true,
            ),
            SizedBox(height: screenHeight * .025),
            InputField(
              onChanged: (value) {
                setState(() {
                  plate = value;
                });
              },
              labelText: "Car Registration Number ",
              errorText: carplateError,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              autoFocus: true,
            ),

            SizedBox(height: screenHeight * .025),
            InputField(
              onChanged: (value) {
                setState(() {
                  phone = value;
                });
              },
              labelText: "Phone Number",
              errorText: phoneError,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              autoFocus: true,
            ),

            SizedBox(height: screenHeight * .025),
            InputField(
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
              labelText: "Password",
              errorText: passwordError,
              obscureText: true,
              textInputAction: TextInputAction.next,
            ),

            SizedBox(height: screenHeight * .025),
            InputField(
              onChanged: (value) {
                setState(() {
                  confirmPassword = value;
                });
              },
              onSubmitted: (value) => submit(),
              labelText: "Confirm Password",
              errorText: passwordError,
              obscureText: true,
              textInputAction: TextInputAction.done,
            ),
            SizedBox(
              height: screenHeight * .025,
            ),
            FormButton(
              text: "Sign Up",
              // onPressed: submit,
              onPressed: submit,
            ),
            SizedBox(
              height: screenHeight * .025,
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: RichText(
                text: const TextSpan(
                  text: "I'm already a member, ",
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: "Sign In",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}



class FormButton extends StatelessWidget {
  final String text;
  final Function? onPressed;
  const FormButton({this.text = "", this.onPressed, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return ElevatedButton(
      onPressed: onPressed as void Function()?,
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: screenHeight * .02),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final String? labelText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autoFocus;
  final bool obscureText;
  const InputField(
      {this.labelText,
        this.onChanged,
        this.onSubmitted,
        this.errorText,
        this.keyboardType,
        this.textInputAction,
        this.autoFocus = false,
        this.obscureText = false,
        Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: autoFocus,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        errorText: errorText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

Widget customSwitch(String text, bool val, Function onChangeMethod) {
  return Padding (
    padding: const EdgeInsets.only (top: 20.0, left: 10.0, right: 150.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text, style: const TextStyle(
            fontSize: 15.0,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            color: Colors.black
        )), // TextStyle, Text
        const Spacer(),
        CupertinoSwitch(
            trackColor: Colors.grey,
            activeColor: Colors.blue,
            value: val,
            onChanged: (newValue) {
              onChangeMethod(newValue);
            }
        )
      ],
    ),
  );
}
