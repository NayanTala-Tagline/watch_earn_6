import 'package:flutter/cupertino.dart';

class PurseCategory {
  final String title;
  final String dbTitle;
  final List<PurseItem> items;

  PurseCategory({required this.title,required this.dbTitle, required this.items});
}

class PurseItem {
  final String title;
  final String dbTitle;
  final Widget icon;
  final Color color;
  final FormPayload formData;

  PurseItem(this.title,this.dbTitle, this.icon, this.color, this.formData);
}

class FormPayload {
  final String title;
  final Widget icon;
  final String regex;

  FormPayload(this.title, this.icon, this.regex); // ✅ Correct
}
