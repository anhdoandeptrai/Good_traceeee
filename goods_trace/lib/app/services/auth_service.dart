import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthService {
  static String ADMIN_PIN = "1925";
  static const String USER_PIN = "0611";
  static const String _currentUserKey = 'current_user';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  String hashPin(String pin) {
    final bytes = utf8.encode(pin + 'goods_trace_salt');
    return sha256.convert(bytes).toString();
  }

  Future<void> initSampleData() async {
    try {
      await _usersCollection.doc('admin').set({
        'id': 'admin',
        'role': 'admin',
        'pin': hashPin(ADMIN_PIN),
        'name': 'Administrator',
        'isAdmin': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await _usersCollection.doc('user').set({
        'id': 'user',
        'role': 'user',
        'pin': hashPin(USER_PIN),
        'name': 'Standard User',
        'isAdmin': false,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print('Initialized sample data successfully');
    } catch (e) {
      print('Error initializing sample data: $e');
    }
  }

  Future<UserModel?> signInWithPin(String pin) async {
    try {
      final hashedPin = hashPin(pin);
      final query = await _usersCollection
          .where('pin', isEqualTo: hashedPin)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final userDoc = query.docs.first;
        final user = UserModel.fromFirestore(userDoc);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_currentUserKey, user.id);
        print("User ID ${user.id} saved to SharedPreferences");

        await _auth.signInAnonymously();
        return user;
      }
      print("No user found with the provided PIN");
      return null;
    } catch (e) {
      print('Error signing in with PIN: $e');
      return null;
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(_currentUserKey);
      if (userId == null) return null;

      final doc = await _usersCollection.doc(userId).get();
      return doc.exists ? UserModel.fromFirestore(doc) : null;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_currentUserKey);
      await _auth.signOut();
    } catch (e) {
      print('Error logging out: $e');
    }
  }

  Future<bool> changePin(String newPin) async {
    try {
      print("Starting changePin process for newPin: $newPin");

      final hashedNewPin = hashPin(newPin);
      print("Generated hashed PIN: $hashedNewPin");

      await _usersCollection.doc('admin').update({
        'pin': hashedNewPin, // THIS WAS MISSING!
        'updatedAt': FieldValue.serverTimestamp(),
      });

      ADMIN_PIN = newPin;
      print(
          "Admin PIN updated successfully in Firestore and locally to: $newPin");

      return true;
    } catch (e) {
      print('Error changing PIN: $e');
      return false;
    }
  }

  Future<bool> emergencyUpdateAdminPin(String newPin) async {
    try {
      print("Starting emergency admin PIN update for: $newPin");

      final hashedNewPin = hashPin(newPin);

      await _usersCollection.doc('admin').update({
        'pin': hashedNewPin,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      ADMIN_PIN = newPin;

      print("Admin PIN updated successfully via emergency method");
      return true;
    } catch (e) {
      print("Error in emergency PIN update: $e");
      return false;
    }
  }
}
