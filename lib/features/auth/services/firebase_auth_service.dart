// import 'package:firebase_auth/firebase_auth.dart';
//
// class FirebaseAuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   ///send otp to phone number
//   Future<String> sendOtp(String phoneNumber) async {
//     String verificationId = '';
//
//     await _auth.verifyPhoneNumber(
//       phoneNumber: phoneNumber,
//       timeout: const Duration(seconds: 60),
//       verificationCompleted: (PhoneAuthCredential credential) {
//         // Automatic verification (Android only)
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         print(e.message);
//       },
//       codeSent: (String verId, int? resendToken) {
//         verificationId = verId;
//       },
//       codeAutoRetrievalTimeout: (String verId) {},
//     );
//
//     return verificationId;
//   }
//
//   /// verify otp
//   Future<String> verifyOtp(String verificationId, String otp) async {
//     PhoneAuthCredential credential = PhoneAuthProvider.credential(
//       verificationId: verificationId,
//       smsCode: otp,
//     );
//     final authCredential = await _auth.signInWithCredential(credential);
//     return authCredential.user!.uid;
//   }
//
//   ///create User in backend
// }
