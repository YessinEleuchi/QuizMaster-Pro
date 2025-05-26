import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuizHistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  Stream<List<Map<String, dynamic>>> getUserScores() {
    return _firestore
        .collection("quiz_scores")
        .where("userId", isEqualTo: userId)
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
