import 'package:firebase_auth/firebase_auth.dart';
import 'package:parkingtechproject/model/user.dart'  ;


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //creating a user object based on Firebase user
  Client? _userFromFirebaseUser(User? user) {
    // if (user != null){
    //   return Client(uid: user.uid);
    // }
      return user != null ? Client(uid: user.uid) : null;

  }
  //for authenticate user stream
  //if cant , apply USER? instead of Client in the Stream
  Stream<Client?> get user {
    // return _auth.authStateChanges();
    return _auth.authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user!));

  }
  //sign in anonymously
  Future signInAnon() async {
    try {
      UserCredential result =  await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  //register function
  // Future<void> register() async{
  //
  //   final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password).then((value) => {postDetailsToFirestore()});
  //   if (validate()){
  //     if(newUser != null){
  //       Navigator.of(context).pushReplacement(
  //           MaterialPageRoute(builder: (context) => const PagesNavigate()));
  //     }
  //   }
  // }
  //
  //
  // postDetailsToFirestore() async{
  //   //calling Firestore
  //   //calling user model
  //   //sending value
  //   FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  //   User? user = _auth.currentUser;
  //
  //   UserModel userModel = UserModel();
  //
  //   userModel.email = user!.email;
  //   userModel.name = name;
  //   userModel.studentID = studentID;
  //   userModel.phone = phone;
  //   userModel.uid = user.uid;
  //
  //   await firebaseFirestore
  //       .collection("users")
  //       .doc(user.uid)
  //       .set(userModel.toMap());
  //   Fluttertoast.showToast(msg:"Account created Successfully");
  //
  //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context) => const PagesNavigate()), (route) => false);
  // }


  Future registerEmailAndPassword(String email, String password)async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      // create new doc for the user with the uid
      // await DatabaseService(uid: user!.uid).updateUserData('VDX 9000', 'Jefri', '0111313121');
      // return _userFromFirebaseUser(user);

    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
  //sign in function
  Future signInWithEmailAndPassword(String email, String password)async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);


    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
  //sign out function
  Future signOut() async{
    try{
      return await _auth.signOut();
    }
    catch(e) {
      print(e.toString());
      return null;
    }
  }
}


