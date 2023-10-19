import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class MySlider extends StatelessWidget {
   MySlider({Key? key}) : super(key: key);

  final List<Widget> imageItems = [
     ClipRRect(borderRadius: BorderRadius.circular(16),child: Image.asset('assets/images/spa.png',fit: BoxFit.fill,)),
     ClipRRect(borderRadius: BorderRadius.circular(16),child: Image.asset('assets/images/spa.png',fit: BoxFit.fill,)),
     ClipRRect(borderRadius: BorderRadius.circular(16),child: Image.asset('assets/images/spa.png',fit: BoxFit.fill,)),
     ClipRRect(borderRadius: BorderRadius.circular(16),child: Image.asset('assets/images/spa.png',fit: BoxFit.fill,)),
    // Add more images as needed
  ];

  @override
  Widget build(BuildContext context) {
    return
      CarouselSlider(
          items: imageItems,
          options: CarouselOptions(
            height: 200,
            aspectRatio: 16/9,
            viewportFraction: .5,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 500),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
          )
      );
  }
}
