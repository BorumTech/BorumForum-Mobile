import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Question {
  final int userId;
  final int id;
  final String title;
  final String body;

  const Question(
      {required this.userId,
      required this.id,
      required this.title,
      required this.body});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
        userId: int.parse(json['user_id']),
        id: int.parse(json['id']),
        title: json['subject'],
        body: json['body']);
  }
}

class _QuestionPageState extends State<QuestionPage> {
  late Future<Question> question;

  @override
  void initState() {
    super.initState();
    question = fetchQuestion();
  }

  Future<Question> fetchQuestion() async {
    var uri = Uri.parse(
        "https://api.forum.borumtech.com/questions/${widget.id.toString()}");
    final response = await http.get(uri, headers: {
      HttpHeaders.authorizationHeader: 'Basic f590aaf962d6460fb0218dbf270f1877'
    });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Question.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Question>(
        future: question,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(child: Text(snapshot.data!.id.toString()));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}

class QuestionPage extends StatefulWidget {
  final int id;

  const QuestionPage({Key? key, required this.id}) : super(key: key);

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}
