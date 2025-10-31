import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/student_code_viewmodel.dart';
 
import 'package:unimarket/utils/not_implemented_snackbar.dart';
import 'package:go_router/go_router.dart';
import 'package:unimarket/routing/routes.dart';

class StudentCodeView extends StatelessWidget {
  const StudentCodeView({super.key, required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    final greetingText = userName.isNotEmpty ? 'Hi $userName!' : 'Hi there!';

    final viewModel = context.read<StudentCodeViewModel>();
    if (viewModel.state.userName.isEmpty && userName.isNotEmpty) {
      viewModel.setUserName(userName);
    }

    try {
      return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          final s = viewModel.state;
          return Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/student-code-bg.png',
                    fit: BoxFit.cover,
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

                        Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 60,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
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
                    child: TextField(
                                    onChanged: (_) {},
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'ID',
                                      hintStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 18,
                                        fontFamily: 'Poppins',
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 20,
                                      ),
                                      suffixIcon: Container(
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
                                          onPressed: s.loading ? null : viewModel.openCamera,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                if (s.imageFile != null)
                                  GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => Dialog(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    AppBar(
                                                      backgroundColor: const Color(0xFFFFC436),
                                                      title: const Text('Image Preview'),
                                                      leading: IconButton(
                                                        icon: const Icon(Icons.close),
                                                        onPressed: () => Navigator.of(context).pop(),
                                                      ),
                                                    ),
                                                    if (s.imageFile != null)
                                                      Image.file(s.imageFile!),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        top: 10,
                                        left: 20,
                                        right: 20,
                                      ),
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: const Color(0xFFFFC436),
                                          width: 2,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(
                                          s.imageFile!,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                              ]
                          ),
                          const SizedBox(height: 20),
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
                            onPressed: s.loading || !s.canSubmit
                                ? null
                                : () async {
                                    await viewModel.submitVerification();
                                    if (viewModel.state.isVerified && context.mounted) {
                                      context.go(Routes.homeBuyer);
                                    }
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
                            child: s.loading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
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
      );
        },
      ),
    );
    } catch (_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notImplementedFunctionalitySnackbar(context);
      });
      return const SizedBox.shrink();
    }
  }
}


