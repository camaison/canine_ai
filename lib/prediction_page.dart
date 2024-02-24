// ignore_for_file: must_be_immutable

import 'package:canine_ai/FadeAnimation.dart';
import 'package:canine_ai/prediction_score.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PredictionPage extends StatefulWidget {
  final List _heap;
  const PredictionPage(this._heap, {super.key});

  @override
  _PredictionPageState createState() => _PredictionPageState(_heap);
}

class _PredictionPageState extends State<PredictionPage>
    with SingleTickerProviderStateMixin {
  final List _heap;
  _PredictionPageState(this._heap);
  late PageController _pageController;
  int totalPage = 3;

  void _onScroll() {}

  @override
  void initState() {
    _pageController = PageController(
      initialPage: 0,
    )..addListener(_onScroll);

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String url1, url2, url3;
    url1 =
        "https://gist.githubusercontent.com/camaison/740c94ed824b61cb6caf1e2b8c3941d7/raw/${_heap[0]['index']}.json";
    url2 =
        "https://gist.githubusercontent.com/camaison/740c94ed824b61cb6caf1e2b8c3941d7/raw/${_heap[1]['index']}.json";
    url3 =
        "https://gist.githubusercontent.com/camaison/740c94ed824b61cb6caf1e2b8c3941d7/raw/${_heap[2]['index']}.json";

    return Scaffold(
      body: PageView(
          scrollDirection: Axis.vertical,
          controller: _pageController,
          children: <Widget>[
            FutureBuilder(
                future: fetchData(url1),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data['images'] == null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Lottie.asset('assets/lottie/404.json'),
                            Text(
                              snapshot.data["name"],
                              style: const TextStyle(
                                  color: Colors.brown,
                                  fontSize: 50,
                                  height: 1.2,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ConfidenceScoreWidget(
                              confidence: _heap[0]['score'],
                            )
                          ],
                        ),
                      );
                    } else {
                      return PageView(
                        controller: _pageController,
                        children: <Widget>[
                          makePage(
                              page: 1,
                              score: _heap[0]['score'],
                              imageUrl: snapshot.data['images'][0],
                              title: snapshot.data['name'],
                              wikiUrl: snapshot.data['url'],
                              description: snapshot.data['description']),
                          makePage(
                              page: 2,
                              score: _heap[0]['score'],
                              imageUrl: snapshot.data['images'][1],
                              title: snapshot.data['name'],
                              wikiUrl: snapshot.data['url'],
                              description:
                                  "Average Height:\n${snapshot.data['height']}\nAverage Weight:\n${snapshot.data['weight']}"),
                          makePage(
                              page: 3,
                              score: _heap[0]['score'],
                              imageUrl: snapshot.data['images'][2],
                              wikiUrl: snapshot.data['url'],
                              title: snapshot.data['name'],
                              description:
                                  "Average Life Span:\n${snapshot.data['lifespan']}\nAverage Litter Size:\n${snapshot.data['litter_size']}"),
                        ],
                      );
                    }
                  } else {
                    return Center(
                      child: Lottie.asset('assets/lottie/loading.json'),
                      //CircularProgressIndicator(),
                    );
                  }
                }),
            FutureBuilder(
                future: fetchData(url2),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data['images'] == null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Lottie.asset('assets/lottie/404.json'),
                            Text(
                              snapshot.data["name"],
                              style: const TextStyle(
                                  color: Colors.brown,
                                  fontSize: 50,
                                  height: 1.2,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ConfidenceScoreWidget(
                              confidence: _heap[1]['score'],
                            )
                          ],
                        ),
                      );
                    } else {
                      return PageView(
                          controller: _pageController,
                          children: <Widget>[
                            makePage(
                                page: 1,
                                score: _heap[1]['score'],
                                imageUrl: snapshot.data['images'][0],
                                wikiUrl: snapshot.data['url'],
                                title: snapshot.data['name'],
                                description: snapshot.data['description']),
                            makePage(
                                page: 2,
                                score: _heap[1]['score'],
                                imageUrl: snapshot.data['images'][1],
                                title: snapshot.data['name'],
                                wikiUrl: snapshot.data['url'],
                                description:
                                    "Average Height:\n${snapshot.data['height']}\nAverage Weight:\n${snapshot.data['weight']}"),
                            makePage(
                                page: 3,
                                score: _heap[1]['score'],
                                imageUrl: snapshot.data['images'][2],
                                title: snapshot.data['name'],
                                wikiUrl: snapshot.data['url'],
                                description:
                                    "Average Life Span:\n${snapshot.data['lifespan']}\nAverage Litter Size:\n${snapshot.data['litter_size']}"),
                          ]);
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
            FutureBuilder(
                future: fetchData(url3),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data['images'] == null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Lottie.asset('assets/lottie/404.json'),
                            Text(
                              snapshot.data["name"],
                              style: const TextStyle(
                                  color: Colors.brown,
                                  fontSize: 50,
                                  height: 1.2,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ConfidenceScoreWidget(
                              confidence: _heap[2]['score'],
                            )
                          ],
                        ),
                      );
                    } else {
                      return PageView(
                          controller: _pageController,
                          children: <Widget>[
                            makePage(
                                page: 1,
                                score: _heap[2]['score'],
                                imageUrl: snapshot.data['images'][0],
                                title: snapshot.data['name'],
                                wikiUrl: snapshot.data['url'],
                                description: snapshot.data['description']),
                            makePage(
                                page: 2,
                                score: _heap[2]['score'],
                                imageUrl: snapshot.data['images'][1],
                                title: snapshot.data['name'],
                                wikiUrl: snapshot.data['url'],
                                description:
                                    "Average Height:\n${snapshot.data['height']}\nAverage Weight:\n${snapshot.data['weight']}"),
                            makePage(
                                page: 3,
                                score: _heap[2]['score'],
                                imageUrl: snapshot.data['images'][2],
                                title: snapshot.data['name'],
                                wikiUrl: snapshot.data['url'],
                                description:
                                    "Average Life Span:\n${snapshot.data['lifespan']}\nAverage Litter Size:\n${snapshot.data['litter_size']}"),
                          ]);
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ]),
    );
  }

  Widget makePage({imageUrl, title, description, page, score, wikiUrl}) {
    return Container(
      decoration: BoxDecoration(
        image:
            DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
      ),
      child: Container(
        decoration: BoxDecoration(
            gradient:
                LinearGradient(begin: Alignment.bottomRight, stops: const [
          0.3,
          0.9
        ], colors: [
          Colors.black.withOpacity(.9),
          Colors.black.withOpacity(.2),
        ])),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                    FadeAnimation(
                        2,
                        Text(
                          page.toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        )),
                    Text(
                      '/$totalPage',
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    )
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FadeAnimation(
                          1,
                          Text(
                            title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                height: 1.2,
                                fontWeight: FontWeight.bold),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      FadeAnimation(
                        1.5,
                        ConfidenceScoreWidget(
                          confidence: score,
                        ),
                      ),
                      //       ],
                      //     )),
                      const SizedBox(
                        height: 20,
                      ),
                      FadeAnimation(
                          2,
                          Padding(
                            padding: const EdgeInsets.only(right: 50),
                            child: Text(
                              description,
                              style: TextStyle(
                                  color: Colors.white.withOpacity(.7),
                                  height: 1.9,
                                  fontSize: 15),
                            ),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      FadeAnimation(
                        2.5,
                        TextButton(
                          onPressed: () async {
                            final Uri url = Uri.parse(wikiUrl);
                            if (!await launchUrl(url)) {
                              throw Exception('Could not launch $url');
                            }
                          },
                          child: const Text(
                            'READ MORE',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                )
              ]),
        ),
      ),
    );
  }
}

Future<Map<String, dynamic>> fetchData(String gitUrl) async {
  var response = await http.get(Uri.parse(gitUrl));
  if (response.statusCode == 200) {
    var jsonData = jsonDecode(response.body);
    return jsonData;
  } else {
    throw Exception('Failed to load data');
  }
}
