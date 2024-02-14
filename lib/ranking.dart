import 'package:flutter/material.dart';
//import 'package:flutter_profile_picture/flutter_profile_picture.dart';

class Ranking extends StatefulWidget {
  const Ranking ({Key? key}): super(key: key);

  @override
  State<Ranking> createState() => _RankingView();
}

class _RankingView extends State<Ranking> {
  List userList = [
    'John Doe',
    'Jean Dupont',
    'Tom Cruise',
  ];

  List userImage = [
    'https://picsum.photos/200/300?random=8',
    'https://picsum.photos/200/300?random=8',
    'https://picsum.photos/200/300?random=8',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('LeaderBoard'),
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: Padding( 
                padding: const EdgeInsets.all(15.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: userImage.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder( 
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.purple.shade100,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0
                        ),
                        child: Row(
                          children: [
                            // TO DO : add profile pictures
                            const SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: Text(
                                userList[index],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}