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
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: ListenableBuilder(
            listenable: viewModel,
            builder: (context, _) {
              final s = viewModel.state;
              
              return LayoutBuilder(
                builder: (context, constraints) {
                  final bottomInset = MediaQuery.of(context).viewInsets.bottom;
                  
                  return SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      24,
                      16,
                      24,
                      (bottomInset > 0 ? bottomInset : 16) + 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header section with background
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 280),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned.fill(
                                child: Image.asset(
                                  'assets/images/student-code-bg.png',
                                  fit: BoxFit.cover,
                                  alignment: Alignment.topCenter,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 20),
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
                                    const SizedBox(height: 20),
                                    Text(
                                      greetingText,
                                      style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    const SizedBox(height: 16),
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
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Student code input
                        Container(
                          width: double.infinity,
                          height: 60,
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
                            onChanged: viewModel.setStudentCodeText,
                            enabled: !s.loading,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontFamily: 'Poppins',
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter your student code',
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
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Camera button or preview
                        s.imageFile == null
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFC436),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                    onPressed: s.loading ? null : viewModel.openCamera,
                                  ),
                                ),
                              )
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Thumbnail (fixed 96x96)
                                  GestureDetector(
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
                                        width: 96,
                                        height: 96,
                                        child: Image.file(
                                          s.imageFile!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Flexible(
                                    child: Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      children: [
                                        OutlinedButton.icon(
                                          icon: const Icon(Icons.visibility, size: 18),
                                          label: const Text(
                                            'Preview',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 14,
                                            ),
                                          ),
                                          onPressed: () => showDialog(
                                            context: context,
                                            builder: (_) => Dialog(
                                              insetPadding: const EdgeInsets.all(16),
                                              child: InteractiveViewer(
                                                clipBehavior: Clip.none,
                                                child: Image.file(s.imageFile!),
                                              ),
                                            ),
                                          ),
                                        ),
                                        TextButton.icon(
                                          icon: const Icon(Icons.delete_outline, size: 18),
                                          label: const Text(
                                            'Remove',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 14,
                                            ),
                                          ),
                                          onPressed: viewModel.removePhoto,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

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

                        const SizedBox(height: 24),

                        // Icon illustration (constrained)
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 220),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Image.asset(
                              'assets/images/student-code-icon.png',
                              width: 200,
                              height: 200,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Submit button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: s.loading || !s.canSubmit
                                ? null
                                : () async {
                                    await viewModel.submitVerification();
                                    if (!context.mounted) return;
                                    if (viewModel.state.isVerified) {
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
                      ],
                    ),
                  );
                },
              );
            },
          ),
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


