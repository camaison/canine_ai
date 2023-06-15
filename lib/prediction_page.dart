// ignore_for_file: must_be_immutable
import 'package:canine_ai/FadeAnimation.dart';
import 'package:canine_ai/breed_data.dart';
import 'package:canine_ai/prediction_score.dart';
import 'package:flutter/material.dart';

class PredictionPage extends StatefulWidget {
  late List _heap;
  PredictionPage(this._heap);

  @override
  _PredictionPageState createState() => _PredictionPageState(_heap);
}

class _PredictionPageState extends State<PredictionPage>
    with SingleTickerProviderStateMixin {
  late List _heap;
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
    String? pred1, pred2, pred3;
    pred1 = labels[_heap[0]['index']] ?? "rott";
    pred2 = labels[_heap[1]['index']] ?? "rott";
    pred3 = labels[_heap[2]['index']] ?? "rott";

    return Scaffold(
      body: PageView(
          scrollDirection: Axis.vertical,
          controller: _pageController,
          children: <Widget>[
            PageView(
              controller: _pageController,
              children: <Widget>[
                makePage(
                    page: 1,
                    score: _heap[0]['score'],
                    image: 'assets/images/${pred1}_1.jpg',
                    title: breeds[_heap[0]['index']]['name'],
                    description: breeds[_heap[0]['index']]['description']),
                makePage(
                    page: 2,
                    score: _heap[0]['score'],
                    image: 'assets/images/${pred1}_2.jpg',
                    title: breeds[_heap[0]['index']]['name'],
                    description:
                        "Average Height:\n${breeds[_heap[0]['index']]['height']}\nAverage Weight:\n${breeds[_heap[0]['index']]['weight']}"),
                makePage(
                    page: 3,
                    score: _heap[0]['score'],
                    image: 'assets/images/${pred1}_3.jpg',
                    title: breeds[_heap[0]['index']]['name'],
                    description:
                        "Average Life Span:\n${breeds[_heap[0]['index']]['lifespan']}\nAverage Litter Size:\n${breeds[_heap[0]['index']]['litter_size']}"),
              ],
            ),
            PageView(
              controller: _pageController,
              children: <Widget>[
                makePage(
                    page: 1,
                    image: 'assets/images/${pred2}_1.jpg',
                    score: _heap[1]['score'],
                    title: breeds[_heap[1]['index']]['name'],
                    description: breeds[_heap[1]['index']]['description']),
                makePage(
                    page: 2,
                    score: _heap[1]['score'],
                    image: 'assets/images/${pred2}_2.jpg',
                    title: breeds[_heap[1]['index']]['name'],
                    description:
                        "Average Height:\n${breeds[_heap[1]['index']]['height']}\nAverage Weight:\n${breeds[_heap[1]['index']]['weight']}"),
                makePage(
                    page: 3,
                    score: _heap[1]['score'],
                    image: 'assets/images/${pred2}_3.jpg',
                    title: breeds[_heap[1]['index']]['name'],
                    description:
                        "Average Life Span:\n${breeds[_heap[1]['index']]['lifespan']}\nAverage Litter Size:\n${breeds[_heap[1]['index']]['litter_size']}"),
              ],
            ),
            PageView(
              controller: _pageController,
              children: <Widget>[
                makePage(
                    page: 1,
                    score: _heap[2]['score'],
                    image: 'assets/images/${pred3}_1.jpg',
                    title: breeds[_heap[2]['index']]['name'],
                    description: breeds[_heap[2]['index']]['description']),
                makePage(
                    page: 2,
                    score: _heap[2]['score'],
                    image: 'assets/images/${pred3}_2.jpg',
                    title: breeds[_heap[2]['index']]['name'],
                    description:
                        "Average Height:\n${breeds[_heap[2]['index']]['height']}\nAverage Weight:\n${breeds[_heap[2]['index']]['weight']}"),
                makePage(
                    page: 3,
                    score: _heap[2]['score'],
                    image: 'assets/images/${pred3}_3.jpg',
                    title: breeds[_heap[2]['index']]['name'],
                    description:
                        "Average Life Span:\n${breeds[_heap[2]['index']]['lifespan']}\nAverage Litter Size:\n${breeds[_heap[2]['index']]['litter_size']}"),
              ],
            ),
          ]),
    );
  }

  Widget makePage({image, title, description, page, score}) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover)),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.bottomRight, stops: [
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
                      '/' + totalPage.toString(),
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
                          const Text(
                            'READ MORE',
                            style: TextStyle(color: Colors.white),
                          )),
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
