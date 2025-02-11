import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shimmer/shimmer.dart';

class MyDiaLog{
  static Widget loading() {
    return Center(
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.black.withOpacity(0.2),
        ),
        child: LoadingAnimationWidget.threeRotatingDots(
          color: Colors.blue,
          size: 50,
        ),
      ),
    );
  }

  // loading conversation
  static Widget loadingConversation(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Shimmer.fromColors(
      baseColor: Colors.grey[350]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 10, // Adjust the count based on your needs
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              Container(
                width: width * 0.15,
                height: width * 0.15,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // conversation name
                    Container(
                      width: width * 0.2,
                      height: height * 0.01,
                      decoration: const BoxDecoration(color: Colors.white),
                    ),

                    const SizedBox(height: 5),

                    // display last message
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: width * 0.3,
                          height: height * 0.01,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          width: width * 0.1,
                          height: height * 0.01,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    const Divider(),
                  ],
                ),
              ),
            ]),
          );
        },
      ),
    );
  }

  // loading conversation
  static Widget loadingChatBox(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Shimmer.fromColors(
      baseColor: Colors.grey[350]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 30, // Adjust the count based on your needs
        itemBuilder: (context, index) {
          return Align(
            alignment: Random().nextBool()
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container(
              height: height * 0.05,
              width: width * 0.3,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(
                  vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 0,
                    blurRadius: 7,
                    offset: const Offset(2, 3), // changes position of shadow
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          );
        },
      ),
    );
  }
}