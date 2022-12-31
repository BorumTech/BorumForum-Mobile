import 'dart:convert';
import 'dart:io';

import 'package:borumforum_mobile/question.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class _FeedPageState extends State<FeedPage> {
  late Future<List<Question>> futureQuestions;

  Future<List<Question>> fetchQuestions() async {
    var uri = Uri.parse("https://api.forum.borumtech.com/questions");
    final response = await http.get(uri, headers: {
      HttpHeaders.authorizationHeader: 'Basic f590aaf962d6460fb0218dbf270f1877'
    });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var data = jsonDecode(response.body);
      List<Question> questionList = [];
      for (var question in data) {
        questionList.add(Question.fromJson(question));
      }

      return questionList;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    super.initState();
    futureQuestions = fetchQuestions();
  }

  @override
  Widget build(BuildContext buildContext) {
    return FutureBuilder<List<Question>>(
      future: futureQuestions,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
              decoration: BoxDecoration(color: Colors.yellow.shade50),
              child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  padding: const EdgeInsets.all(25.0),
                  itemCount: snapshot.data!.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                QuestionPage(id: snapshot.data![index].id),
                          ),
                        );
                      },
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(snapshot.data![index].title,
                              style: const TextStyle(fontSize: 24.0)),
                          Text(snapshot.data![index].body,
                              style: const TextStyle(
                                  fontSize: 16.0, overflow: TextOverflow.fade),
                              maxLines: 5)
                        ],
                      ),
                    );
                  }));
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}
