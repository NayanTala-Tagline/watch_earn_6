import 'package:cloud_firestore/cloud_firestore.dart';

class HelpRequestModel {
  final String userId;
  final String? userName;
  final String? userEmail;
  final String title;
  final String description;
  final DateTime createdAt;
  final String status;

  const HelpRequestModel({
    required this.userId,
    required this.title,
    required this.description,
    required this.createdAt,
    this.userName,
    this.userEmail,
    this.status = 'open',
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'user_name': userName,
      'user_email': userEmail,
      'title': title,
      'description': description,
      'status': status,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }
}
