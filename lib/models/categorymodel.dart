import 'dart:convert';

class CategoryModel {
  final String title;
  final String urlImage;
  final String autocompleteTerm;

  CategoryModel({
    required this.title,
    required this.urlImage,
    required this.autocompleteTerm,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      title: json['title'],
      urlImage: json['urlImage'],
      autocompleteTerm: json['autocompleteTerm'],
    );
  }
}
