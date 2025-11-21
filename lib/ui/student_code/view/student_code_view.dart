import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../view_model/student_code_viewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:unimarket/routing/routes.dart';

class StudentCodeView extends StatelessWidget {
  const StudentCodeView({super.key, required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<StudentCodeViewModel>();
    if (viewModel.state.userName.isEmpty && userName.isNotEmpty) {
      viewModel.setUserName(userName);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFEF7FB),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: viewModel,
          child: const _StaticHeroSection(),
          builder: (context, child) {
            final s = viewModel.state;

            return ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 560),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  24,
                  16,
                  24,
                  16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Card with Logo and Input
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECAB0F),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/sign.png',
                                width: 18,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'UNIMARKET',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Hi ${s.userName.isNotEmpty ? s.userName : 'there'}!',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Before starting, we will need your student ID or identity ID for business outside college',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              height: 1.35,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            onChanged: viewModel.setStudentCodeText,
                            onSubmitted: (_) =>
                                (!s.canSubmit || s.loading)
                                    ? null
                                    : viewModel.submitVerification(),
                            textInputAction: TextInputAction.done,
                            enabled: !s.loading,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(30),
                            ],
                            decoration: InputDecoration(
                              hintText: 'ID',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.camera_alt_rounded,
                                  color: Colors.black87,
                                ),
                                onPressed: s.loading
                                    ? null
                                    : viewModel.openCamera,
                                tooltip: 'Open camera',
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Photo preview (if exists)
                    if (s.hasPhoto)
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Center(
                          child: GestureDetector(
                            onTap: () => showDialog(
                              context: context,
                              builder: (_) => Dialog(
                                insetPadding: const EdgeInsets.all(16),
                                child: InteractiveViewer(
                                  clipBehavior: Clip.none,
                                  child: Image.file(s.imageFile!),
                                ),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: SizedBox(
                                width: 140,
                                height: 100,
                                child: Image.file(
                                  s.imageFile!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    // Error message (if exists)
                    if (s.error != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        s.error!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],

                    const SizedBox(height: 12),

                    // Static hero illustration
                    child!,
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          final s = viewModel.state;
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: (!s.canSubmit || s.loading)
                      ? null
                      : () async {
                          FocusScope.of(context).unfocus();
                          await viewModel.submitVerification();
                          if (!context.mounted) return;
                          if (viewModel.state.isVerified) {
                            context.go(Routes.homeBuyer);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFECAB0F),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: s.loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
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
                            letterSpacing: 1,
                          ),
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StaticHeroSection extends StatelessWidget {
  const _StaticHeroSection();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 320),
      child: AspectRatio(
        aspectRatio: 1,
        child: Image.asset(
          'assets/images/student-code-icon.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}


