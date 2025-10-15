import 'package:flutter/material.dart';
import 'explore_buyer.dart';

class StudentCodeScreen extends StatelessWidget {

  final String userName;
  
  const StudentCodeScreen({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final greetingText = userName.isNotEmpty ? 'Hi $userName!' : 'Hi there!';
    
    return Scaffold(
      resizeToAvoidBottomInset: false, 
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/student-code-bg.png',
                    fit: BoxFit
                        .cover, 
                    alignment: Alignment.topCenter,
                  ),
                ),

                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/student-code-star.png',
                              width: 30,
                              height: 30,
                            ),
                            const SizedBox(width: 2),

                            const Text(
                              'UNIMARKET',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        Text(
                          greetingText,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            'Before starting, we will need your student ID or identity ID for business outside college',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              height: 1.4,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Container(
                          width: double.infinity,
                          height: 60,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Expanded(
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'ID',
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 18,
                                      fontFamily: 'Poppins',
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 20,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 60,
                                width: 50,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFC436),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  onPressed: () {
                                    // Camera functionality would be implemented here
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 2,
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Person illustration
                  Expanded(
                    child: Center(
                      child: Image.asset(
                        'assets/images/student-code-icon.png',
                        width: 500,
                        height: 500,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  // Get Started button
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 24.0,
                      right: 24.0,
                      bottom: 24.0,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ExploreBuyerScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFB300),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          shadowColor: Colors.black.withValues(alpha: 0.3),
                        ),
                        child: const Text(
                          'GET STARTED',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}