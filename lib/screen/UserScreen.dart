import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kavita_healling_reanaissance/http/http_service.dart';
import 'package:kavita_healling_reanaissance/widgets/CountdownTimerWidget.dart';
import 'package:kavita_healling_reanaissance/screen/CustomWebView.dart';
import 'package:kavita_healling_reanaissance/screen/commonfunction.dart';
import 'package:kavita_healling_reanaissance/widgets/navbar.dart';
// ...existing imports...
import 'package:flutter/services.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    final dWidth = MediaQuery.of(context).size.width;
    final dHeight = MediaQuery.of(context).size.height;

    // Responsive helpers
    bool isWide = dWidth > 900;
    bool isTablet = dWidth > 600 && dWidth <= 900;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HERO SECTION
            Stack(
              children: [
                Container(
                  height: isWide ? 600 : dHeight * 1,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/user1.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: isWide ? 600 : dHeight * 0.7,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.85),
                        Colors.black.withOpacity(0.5),
                        Colors.transparent
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Column(
                    children: [
                      NavBar(),
                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    isWide ? dWidth * 0.18 : dWidth * 0.06),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Transform your life with Manifestation\nTo Recreate the Life of your Dreams",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.cairo(
                                    fontSize: isWide
                                        ? 48
                                        : isTablet
                                            ? 32
                                            : 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.5),
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: isWide ? 32 : 20),
                                Text(
                                  "Do you feel stuck in the same cycle? Are you ready to create a life full of purpose, abundance, and inner peace?",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.cairo(
                                    fontSize: isWide
                                        ? 22
                                        : isTablet
                                            ? 18
                                            : 15,
                                    color: Colors.white70,
                                  ),
                                ),
                                SizedBox(height: isWide ? 32 : 20),
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 18,
                                  runSpacing: 12,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.yellow[600],
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 32, vertical: 18),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        elevation: 8,
                                        shadowColor: Colors.yellow[900],
                                      ),
                                      onPressed: () {
                                        kIsWeb
                                            ? LaunchURL(
                                                HttpService().sWebURL +
                                                    "/enroll")
                                            : Get.to(() => CustomWebViewScreen(
                                                  url:
                                                      HttpService().sWebURL +
                                                    "/enroll",
                                                  title: "Enroll Now",
                                                ));
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Enroll Now",
                                            style: GoogleFonts.cairo(
                                              fontSize: isWide ? 20 : 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Icon(Icons.arrow_forward,
                                              color: Colors.black),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.red[500],
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.red.withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        "Few Days Left",
                                        style: GoogleFonts.cairo(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: isWide ? 32 : 20),
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 10,
                                  children: [
                                    ...List.generate(
                                        4,
                                        (i) => Icon(Icons.star,
                                            color: Colors.yellow[700],
                                            size: isWide ? 32 : 24)),
                                    Icon(Icons.star_half,
                                        color: Colors.yellow[700],
                                        size: isWide ? 32 : 24),
                                    Text("4.9/5 (12,000+ Reviews)",
                                        style: GoogleFonts.cairo(
                                            color: Colors.white,
                                            fontSize: isWide ? 18 : 14)),
                                    Text("100K+ Lives Transformed",
                                        style: GoogleFonts.cairo(
                                            color: Colors.white,
                                            fontSize: isWide ? 18 : 14)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // ABOUT SECTION
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  vertical: isWide ? 64 : 36,
                  horizontal: isWide ? dWidth * 0.18 : dWidth * 0.06),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFB19CD9), Color(0xFF89CFF0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    "About This Masterclass",
                    style: GoogleFonts.cairo(
                      fontSize: isWide ? 36 : 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isWide ? 24 : 16),
                  Text(
                    "Revealing the “4D Success Framework” that will help you get unstuck from an unfulfilling corporate job, restart your career at any age, and find your true calling, happiness & peace! We combine science-backed techniques (visualization, affirmations, neuroscience) with spiritual practices (meditation, energy alignment, intention setting) to activate the Law of Attraction and the Law of Assumption in your favor.",
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.cairo(
                      fontSize: isWide ? 18 : 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: isWide ? 24 : 16),
                  Text(
                    "“At Kavita’s Healing Renaissance, we believe your thoughts shape your reality. Through manifestation, positive thinking, and daily affirmations, you can rewire your mindset, shift your energy, and attract the life you truly desire.”",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(
                      fontSize: isWide ? 18 : 15,
                      color: Colors.white70,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: isWide ? 32 : 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 18),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      elevation: 6,
                    ),
                    onPressed: () {},
                    child: Text(
                      "Let's Make It Happen",
                      style: GoogleFonts.cairo(
                        color: Colors.pink[600],
                        fontWeight: FontWeight.bold,
                        fontSize: isWide ? 18 : 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // CORE MODULES SECTION
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                  vertical: isWide ? 64 : 36,
                  horizontal: isWide ? dWidth * 0.12 : dWidth * 0.04),
              child: Column(
                children: [
                  Text(
                    "Core Modules",
                    style: GoogleFonts.cairo(
                      fontSize: isWide ? 36 : 24,
                      color: Colors.purple[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isWide ? 24 : 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      int columns = isWide
                          ? 4
                          : isTablet
                              ? 2
                              : 1;
                      return GridView.count(
                        crossAxisCount: columns,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 24,
                        crossAxisSpacing: 24,
                        childAspectRatio: 1.1,
                        children: [
                          _featureCard(
                              Icons.emoji_emotions,
                              "Emotional Alignment",
                              "Dive deep into emotional alignment techniques to elevate your manifestation journey."),
                          _featureCard(Icons.psychology, "Reprogramming Mind",
                              "Reprogram your subconscious mind for success."),
                          _featureCard(Icons.flag, "Career & Purpose",
                              "Unlock your passion, strengths, and skills."),
                          _featureCard(Icons.auto_awesome, "Law of Attraction",
                              "Decode the law of attraction for your goals."),
                          _featureCard(Icons.attach_money, "Money Beliefs",
                              "Transform your beliefs about money and abundance."),
                          _featureCard(Icons.refresh, "Mindset Reset",
                              "Reset your mindset for unstoppable willpower."),
                          _featureCard(
                              Icons.flash_on,
                              "Manifestation Accelerator",
                              "Accelerate your results with proven techniques."),
                          _featureCard(Icons.bolt, "Energy Alignment",
                              "Align your energy for daily vitality."),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            // WHY JOIN SECTION
            Container(
              width: double.infinity,
              color: Colors.grey[100],
              padding: EdgeInsets.symmetric(
                  vertical: isWide ? 64 : 36,
                  horizontal: isWide ? dWidth * 0.12 : dWidth * 0.04),
              child: Column(
                children: [
                  Text(
                    "Why You Should Join",
                    style: GoogleFonts.cairo(
                      fontSize: isWide ? 36 : 24,
                      color: Colors.purple[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isWide ? 24 : 16),
                  Text(
                    "Over 100,000 men and women have used this exact formula to transform their careers, health, relationships, and inner peace. Here’s what you’ll gain:",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(
                      fontSize: isWide ? 18 : 15,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: isWide ? 32 : 20),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      int columns = isWide
                          ? 3
                          : isTablet
                              ? 2
                              : 1;
                      return GridView.count(
                        crossAxisCount: columns,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 24,
                        crossAxisSpacing: 24,
                        childAspectRatio: 1.2,
                        children: [
                          _featureCard(Icons.bolt, "Break Free from Burnout",
                              "Eliminate stress, anxiety, and overwhelm — step into calm, clarity, and unstoppable energy."),
                          _featureCard(
                              Icons.rocket_launch,
                              "Skyrocket Your Career",
                              "Attract promotions, salary hikes, or dream‐job offers — no matter your age or background."),
                          _featureCard(Icons.spa, "Deep Healing & Peace",
                              "Use proven meditation & energy tools to heal mind, body, and spirit — instantly."),
                          _featureCard(Icons.auto_awesome, "Manifest Anything",
                              "Program your subconscious to attract wealth, love, health, and happiness — live on your terms."),
                          _featureCard(Icons.video_library, "Video Access",
                              "Rewatch all course content anytime — plus receive all future updates at no extra cost."),
                          _featureCard(Icons.support_agent, "24/7 Support",
                              "Our dedicated team is available around the clock to answer questions and guide you."),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            // HEALTH & WELLNESS HIGHLIGHTS
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                  vertical: isWide ? 64 : 36,
                  horizontal: isWide ? dWidth * 0.12 : dWidth * 0.04),
              child: Column(
                children: [
                  Text(
                    "Health & Wellness Highlights",
                    style: GoogleFonts.cairo(
                      fontSize: isWide ? 36 : 24,
                      color: Colors.purple[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isWide ? 24 : 16),
                  Text(
                    "In addition to powerful manifestation techniques, this masterclass brings you holistic health benefits: improved mental well-being, stress reduction, and energy alignment for a stronger, more vibrant you.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(
                      fontSize: isWide ? 18 : 15,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: isWide ? 32 : 20),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      int columns = isWide ? 3 : 1;
                      return GridView.count(
                        crossAxisCount: columns,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 24,
                        crossAxisSpacing: 24,
                        childAspectRatio: 1.2,
                        children: [
                          _featureCard(Icons.psychology, "Mental Well-being",
                              "Learn mindfulness & meditation to calm a racing mind, reduce anxiety, and boost clarity."),
                          _featureCard(Icons.spa, "Stress Reduction",
                              "Master breathing exercises & guided visualizations that release tension and restore balance."),
                          _featureCard(Icons.bolt, "Energy Alignment",
                              "Align your chakras & life force through simple energy practices to feel more vitality every day."),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            // INSTRUCTOR SECTION
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  vertical: isWide ? 64 : 36,
                  horizontal: isWide ? dWidth * 0.12 : dWidth * 0.04),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFB19CD9), Color(0xFF89CFF0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Expanded(
                        //   flex: 1,
                        //   child: ClipRRect(
                        //     borderRadius: BorderRadius.circular(16),
                        //     child: AspectRatio(
                        //       aspectRatio: 16 / 9,
                        //       child: Container(
                        //         color: Colors.black,
                        //         child: Center(
                        //           child: Icon(Icons.play_circle_fill, color: Colors.white, size: 80),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(width: 32),
                        Expanded(
                          flex: 2,
                          child: _instructorText(isWide),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        // ClipRRect(
                        //   borderRadius: BorderRadius.circular(16),
                        //   child: AspectRatio(
                        //     aspectRatio: 16 / 9,
                        //     child: Container(
                        //       color: Colors.black,
                        //       child: Center(
                        //         child: Icon(Icons.play_circle_fill, color: Colors.white, size: 80),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(height: 24),
                        _instructorText(isWide),
                      ],
                    ),
            ),

            // TESTIMONIALS SECTION
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                  vertical: isWide ? 64 : 36,
                  horizontal: isWide ? dWidth * 0.12 : dWidth * 0.04),
              child: Column(
                children: [
                  Text(
                    "What Our Students Say",
                    style: GoogleFonts.cairo(
                      fontSize: isWide ? 36 : 24,
                      color: Colors.purple[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isWide ? 24 : 16),
                  Text(
                    "Over 10,000+ men and women have already experienced massive success using this formula!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(
                      fontSize: isWide ? 18 : 15,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: isWide ? 32 : 20),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      int columns = isWide ? 3 : 1;
                      return GridView.count(
                        crossAxisCount: columns,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 24,
                        crossAxisSpacing: 24,
                        childAspectRatio: 1.2,
                        children: [
                          _testimonialCard(
                              "Thank you for guiding me on my journey to financial abundance through manifestation. Kavita’s techniques realigned my mindset, and within weeks I saw transformative results in my career and personal life. This course is pure magic!",
                              "Manisha Mane"),
                          _testimonialCard(
                              "Working with Life Coach Kavita transformed my relationships. Her guided meditations and energy exercises healed old wounds. I now feel connected, confident, and deeply content.",
                              "Anjali Sharma"),
                          _testimonialCard(
                              "Kavita’s compassion and expertise were a game‐changer. Her personal insights and practical strategies helped me overcome self-doubt and achieve my goals faster than I ever imagined.",
                              "Rani Singh"),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            // CLIENT FEEDBACK SECTION
            Container(
              width: double.infinity,
              color: Colors.grey[100],
              padding: EdgeInsets.symmetric(
                  vertical: isWide ? 64 : 36,
                  horizontal: isWide ? dWidth * 0.12 : dWidth * 0.04),
              child: Column(
                children: [
                  Text(
                    "Client Feedback",
                    style: GoogleFonts.cairo(
                      fontSize: isWide ? 36 : 24,
                      color: Colors.purple[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isWide ? 24 : 16),
                  Text(
                    "Real stories from our students, in their own words.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(
                      fontSize: isWide ? 18 : 15,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: isWide ? 32 : 20),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      int columns = isWide
                          ? 3
                          : isTablet
                              ? 2
                              : 1;
                      return GridView.count(
                        crossAxisCount: columns,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 24,
                        crossAxisSpacing: 24,
                        childAspectRatio: 1.2,
                        children: List.generate(
                          6,
                          (i) => Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Image.asset(
                                "assets/images/feedBack_${i + 1}.jpeg",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // BONUSES SECTION
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  vertical: isWide ? 64 : 36,
                  horizontal: isWide ? dWidth * 0.12 : dWidth * 0.04),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFB19CD9), Color(0xFF89CFF0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    "Bonuses You’ll Get (Worth ₹20,000+)",
                    style: GoogleFonts.cairo(
                      fontSize: isWide ? 36 : 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isWide ? 24 : 16),
                  Text(
                    "When you enroll today, you unlock these exclusive resources at no extra cost:",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(
                      fontSize: isWide ? 18 : 15,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: isWide ? 32 : 20),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      int columns = isWide ? 2 : 1;
                      return GridView.count(
                        crossAxisCount: columns,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 24,
                        crossAxisSpacing: 24,
                        childAspectRatio: 1.6,
                        children: [
                          _bonusCard("BONUS #1: Affirmation eBook", [
                            "Daily Affirmation Sheet (PDF)",
                            "Relationship Affirmations",
                            "Career & Money Affirmations",
                            "General Affirmations"
                          ]),
                          _bonusCard("BONUS #2: Healing Music & Meditations", [
                            "365 Gratitude Prompts",
                            "432 Hz Healing Music",
                            "528 Hz Success Music",
                            "Access to Liked Mind Community",
                            "Vision Board"
                          ]),
                          _bonusCard("BONUS #3: Additional Bonus", [
                            "One Day Free Mind GYM Pass",
                            "Access to Manifesting Zoom Party",
                            "Chance to get a Free 1:1 Consultation",
                            "Access to Manifestation Mobile Applications"
                          ]),
                          _bonusCard("BONUS #4: Exclusive Community Access", [
                            "Private Telegram/Discord Group",
                            "Weekly Live Q&A Sessions",
                            "Monthly Guest Expert Workshops",
                            "Direct Messaging & Peer Support"
                          ]),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            // COUNTDOWN & PRICING SECTION
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                  vertical: isWide ? 64 : 36,
                  horizontal: isWide ? dWidth * 0.18 : dWidth * 0.06),
              child: Column(
                children: [
                  Text(
                    "Only a Few Seats Left—Act Now!",
                    style: GoogleFonts.cairo(
                      fontSize: isWide ? 36 : 24,
                      color: Colors.purple[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isWide ? 24 : 16),
                  Text(
                    "Secure your spot for this life-transforming masterclass at the special launch price of ₹20,000. This offer expires soon!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(
                      fontSize: isWide ? 18 : 15,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: isWide ? 32 : 20),
                  // CountdownTimerWidget(),
                  SizedBox(height: isWide ? 32 : 20),
                  Container(
                    padding: EdgeInsets.all(isWide ? 32 : 18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFB19CD9), Color(0xFF89CFF0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Lifetime Access Masterclass",
                          style: GoogleFonts.cairo(
                            fontSize: isWide ? 28 : 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: isWide ? 16 : 10),
                        Text(
                          "Get instant access to all modules, guided meditations, downloadable resources, plus all four bonus packs—valued at ₹20,000 +—for just ₹20,000 today.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cairo(
                            color: Colors.white70,
                            fontSize: isWide ? 18 : 15,
                          ),
                        ),
                        SizedBox(height: isWide ? 32 : 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow[400],
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 18),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            elevation: 8,
                          ),
                          onPressed: () {
                            kIsWeb
                                ? LaunchURL("https://rzp.io/rzp/Ch1XJWuD")
                                : Get.to(() => CustomWebViewScreen(
                                      url: "https://rzp.io/rzp/Ch1XJWuD",
                                      title: "Payment",
                                    ));
                          },
                          child: Text(
                            "Reserve My Seat Now",
                            style: GoogleFonts.cairo(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: isWide ? 20 : 16,
                            ),
                          ),
                        ),
                        SizedBox(height: isWide ? 12 : 8),
                        Text(
                          "30-Day Money-Back Guarantee | 100% Secure Checkout",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontSize: isWide ? 14 : 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // FOOTER
            Container(
              width: double.infinity,
              color: Colors.grey[900],
              padding: EdgeInsets.symmetric(
                  vertical: isWide ? 48 : 28,
                  horizontal: isWide ? dWidth * 0.12 : dWidth * 0.04),
              child: isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _footerAbout(isWide)),
                        Expanded(child: _footerLinks(isWide)),
                        Expanded(child: _footerContact(isWide)),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _footerAbout(isWide),
                        SizedBox(height: 24),
                        _footerLinks(isWide),
                        SizedBox(height: 24),
                        _footerContact(isWide),
                      ],
                    ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                "© 2025 LifeHealer+. All rights reserved.",
                style: GoogleFonts.cairo(
                  color: Colors.white54,
                  fontSize: isWide ? 14 : 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _instructorText(bool isWide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Meet Your Unicorn Coach: Kavita Jadhav",
          style: GoogleFonts.cairo(
            fontSize: isWide ? 28 : 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: isWide ? 16 : 10),
        Text(
          "Hello, I’m Kavita Jadhav, your Life Transformation Coach. I use cutting‐edge positive psychology, meditation, and energy healing to help you design your best life.\n\nMy work has been featured in Hindustan Times, Business World, and Business Standard. I founded the “Rise n Shine Morning Manifestation Achievers Club” and have helped over 4,000+ men & women unlock their highest potential.\n\nIn 2025, my mission is to empower 1 million+ people to live happier, healthier, and more successful lives.",
          style: GoogleFonts.cairo(
            fontSize: isWide ? 18 : 15,
            color: Colors.white,
            height: 1.5,
          ),
        ),
        SizedBox(height: isWide ? 24 : 14),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow[700],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 6,
          ),
          onPressed: () {
            kIsWeb
                ? LaunchURL("https://rzp.io/rzp/Ch1XJWuD")
                : Get.to(() => CustomWebViewScreen(
                      url: "https://rzp.io/rzp/Ch1XJWuD",
                      title: "Payment",
                    ));
          },
          child: Text(
            "Claim Your Spot for ₹20,000",
            style: GoogleFonts.cairo(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: isWide ? 18 : 15,
            ),
          ),
        ),
      ],
    );
  }

  Widget _footerAbout(bool isWide) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "LifeHealer+",
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: isWide ? 20 : 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "A premium life-healing & manifestation platform. Transform your life in just 2 hours—anytime, anywhere.",
            style: GoogleFonts.cairo(
              color: Colors.white70,
              fontSize: isWide ? 14 : 12,
            ),
          ),
        ],
      );

  Widget _footerLinks(bool isWide) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Quick Links",
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: isWide ? 16 : 14,
            ),
          ),
          SizedBox(height: 8),
          ...[
            "Home",
            "About",
            "Modules",
            "Benefits",
            "Health",
            "Instructor",
            "Testimonials",
            "Client Feedback",
            "Bonuses",
            "Enroll Now"
          ].map((link) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(
                  link,
                  style: GoogleFonts.cairo(
                    color: Colors.white70,
                    fontSize: isWide ? 14 : 12,
                  ),
                ),
              )),
        ],
      );

  Widget _footerContact(bool isWide) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Contact Us",
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: isWide ? 16 : 14,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Phone: +91-7666692367\nEmail: support@lifehealerkavita.com\nAddress: Narhe Gaon, Pune, Maharashtra",
            style: GoogleFonts.cairo(
              color: Colors.white70,
              fontSize: isWide ? 14 : 12,
            ),
          ),
          SizedBox(height: 8),
          // Row(
          //   children: [
          //     Icon(Icons.facebook, color: Colors.white, size: 24),
          //     SizedBox(width: 8),
          //     Icon(Icons.app, color: Colors.white, size: 24),
          //     SizedBox(width: 8),
          //     Icon(Icons.youtube_searched_for, color: Colors.white, size: 24),
          //     SizedBox(width: 8),
          //     Icon(Icons.telegram, color: Colors.white, size: 24),
          //   ],
          // ),
        ],
      );

  // Feature/benefit card
  Widget _featureCard(IconData icon, String title, String desc) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFFB19CD9), size: 38),
            SizedBox(height: 12),
            Text(title,
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 8),
            Text(desc,
                textAlign: TextAlign.center,
                style:
                    GoogleFonts.cairo(fontSize: 14, color: Colors.grey[800])),
          ],
        ),
      ),
    );
  }

  // Testimonial card
  Widget _testimonialCard(String text, String name) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text,
                textAlign: TextAlign.center,
                style:
                    GoogleFonts.cairo(fontSize: 15, color: Colors.grey[800])),
            SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Text("- $name",
                  style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  // Bonus card
  Widget _bonusCard(String title, List<String> items) {
    final dWidth = MediaQuery.of(context).size.width;
    final isMobile = dWidth < 600;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isMobile ? 12 : 18)),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12.0 : 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                fontSize: isMobile ? 14 : 16,
                letterSpacing: 0.3,
                height: 1.3,
              ),
            ),
            SizedBox(height: isMobile ? 6 : 10),
            ...items.map((e) => Padding(
                  padding: EdgeInsets.symmetric(vertical: isMobile ? 1.0 : 2.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check_circle,
                          color: Colors.green, size: isMobile ? 16 : 18),
                      SizedBox(width: isMobile ? 4 : 6),
                      Expanded(
                        child: Text(
                          e,
                          style: GoogleFonts.cairo(
                            fontSize: isMobile ? 12.5 : 14,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
