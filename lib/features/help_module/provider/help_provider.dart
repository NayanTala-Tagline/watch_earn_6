import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_cash/db/app_db.dart';
import 'package:daily_cash/di/injector.dart';
import 'package:daily_cash/extension/ext_string_alert.dart';
import 'package:daily_cash/features/help_module/model/help_request_model.dart';
import 'package:daily_cash/utils/logger_ex.dart';
import 'package:flutter/material.dart';

class HelpProvider extends ChangeNotifier {
  final AppDB _db = Injector.instance<AppDB>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  /// Validates the form and writes a new doc to the `support` collection.
  /// Returns `true` on success so the screen can pop.
  Future<bool> submit() async {
    if (_isSubmitting) return false;

    final form = formKey.currentState;
    if (form == null || !form.validate()) {
      return false;
    }

    final user = _db.userModel;
    if (user == null) {
      'Something went wrong. Please try again.'.showErrorAlert();
      return false;
    }

    _isSubmitting = true;
    notifyListeners();

    try {
      final request = HelpRequestModel(
        userId: user.userId,
        userName: user.name,
        userEmail: user.email,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        createdAt: DateTime.now(),
      );

      await _firestore.collection('support').add(request.toMap());

      titleController.clear();
      descriptionController.clear();
      'Support request submitted. We will get back to you soon!'
          .showSuccessAlert();
      return true;
    } catch (e) {
      e.logE;
      'Could not submit your request. Please try again.'.showErrorAlert();
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
