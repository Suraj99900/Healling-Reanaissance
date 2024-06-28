import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ImageSlider extends StatefulWidget {
  const ImageSlider({super.key});

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  final List<String> imgList = [
    'web_slider_1.jpg',
    'web_slider_2.jpg',
    'web_slider_3.jpg',
    'web_slider_4.jpg',
  ];

  final List<String> imageText = [
    "Thank you for considering me to assist you on your journey to financial abundance through manifestation. I believe that with the right mindset and manifestation techniques, we can unlock incredible opportunities and transform your relationship with money. Together, we'll harness the power of manifestation to align your thoughts, beliefs, and actions with your financial goals. By tapping into your inner potential and manifesting abundance, we'll pave the way for prosperity and fulfillment in every aspect of your life. I'm excited to embark on this transformative journey with you and witness the magic of manifestation unfold!",
    "I firmly believe that by tapping into the power of manifestation, we can heal, strengthen, and elevate your relationships to new heights. Together, we'll delve into your desires, intentions, and energy to manifest the loving, harmonious relationships you deserve. Through visualization, positive affirmations, and aligned action, we'll clear blockages, release negativity, and cultivate deep connections based on love, trust, and understanding. With manifestation as our tool, we'll navigate through challenges, manifesting the fulfilling relationships you desire. Let's embark on this transformative journey together, awakening the magic of manifestation to create the love and connection you've always envisioned.",
    "Working with Life Coach Kavita has been an absolute game-changer for me. Her guidance, support, and expertise have helped me overcome obstacles and achieve my goals in ways I never thought possible. Kavita's compassionate approach, combined with her deep understanding of human behavior and motivation, has empowered me to make positive changes in my life. She listens attentively, provides invaluable insights, and offers practical strategies that yield tangible results. Kavita's dedication to her clients' success is truly inspiring, and I feel incredibly fortunate to have her as my coach. If you're ready to transform your life and unlock your full potential, I wholeheartedly recommend working with Kavita.",
    "Life Coach Kavita is an absolute gem! Her wisdom, empathy, and unwavering support have been instrumental in guiding me through some of the toughest challenges in my life. Kavita has a unique ability to see the potential in people and empower them to reach new heights. Her coaching style is both nurturing and results-driven, and she goes above and beyond to ensure her clients' success. With Kavita's guidance, I've gained clarity, confidence, and a renewed sense of purpose. She truly cares about her clients' well-being and is committed to helping them thrive in all areas of life. If you're looking for a life coach who will inspire, motivate, and transform your life, look no further than Kavita!",
  ];

  @override
  Widget build(BuildContext context) {
    var dWidth = Get.width;
    var dHeight = Get.height;

    return Padding(
      padding: EdgeInsets.all(dWidth > 850 ?10.0:5.0),
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        child: CarouselSlider.builder(
          itemCount: imgList.length,
          options: CarouselOptions(
            height: dWidth > 850? 400.0 : 200.0,
            enlargeCenterPage: true,
            autoPlay: true,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
          ),
          itemBuilder: (context, index, realIndex) {
            return Container(
              margin: EdgeInsets.all(5.0),
              child: Card(
                elevation: 0,
                color: Colors.transparent,
                child: Row(
                  children: <Widget>[
                    ClipOval(
                      child: Container(
                        child: Image.asset(
                        'assets/images/${imgList[index]}',
                        width: dWidth >= 850 ? dWidth * 0.2 : dWidth * 0.2,
                        fit: BoxFit.fill,
                      ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          imageText[index],
                          style: GoogleFonts.cairo(
                            textStyle: TextStyle(
                              fontSize:
                                  dWidth >= 850 ? dWidth * 0.01 : dWidth * 0.02,
                              color: const Color.fromARGB(173, 34, 13, 2),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
