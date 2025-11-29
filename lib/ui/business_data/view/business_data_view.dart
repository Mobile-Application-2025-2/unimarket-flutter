import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../view_model/business_data_viewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:unimarket/routing/routes.dart';
import '../widgets/business_address_field.dart';
import '../widgets/business_category_dropdown.dart';
import 'package:unimarket/core/ui/painters/wave_background_painter.dart';

class BusinessDataView extends StatelessWidget {
  const BusinessDataView({super.key, this.userName});

  final String? userName;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<BusinessDataViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            // Painted wave background
            SizedBox.expand(
              child: CustomPaint(
                painter: WaveBackgroundPainter(),
              ),
            ),
            // Foreground content
            ListenableBuilder(
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
                      40,
                      24,
                      24 + MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header Card with Logo and Input
                        Container(
                          padding: const EdgeInsets.all(24),
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
                                'Before starting, we need your business information',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  height: 1.35,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Business ID field with camera
                              TextField(
                                onChanged: viewModel.setBusinessId,
                                onSubmitted: (_) =>
                                    (!s.canSubmit || s.loading)
                                        ? null
                                        : viewModel.submit(),
                                textInputAction: TextInputAction.next,
                                enabled: !s.loading,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(30),
                                ],
                                decoration: InputDecoration(
                                  hintText: 'Business ID',
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

                        const SizedBox(height: 16),

                        // Address field
                        BusinessAddressField(
                          value: s.address,
                          onChanged: viewModel.setAddress,
                          enabled: !s.loading,
                        ),

                        const SizedBox(height: 16),

                        // Category dropdown
                        BusinessCategoryDropdown(
                          value: s.category.isEmpty ? null : s.category,
                          onChanged: (value) {
                            if (value != null) {
                              viewModel.setCategory(value);
                            }
                          },
                          enabled: !s.loading,
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
          ],
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
                          await viewModel.submit();
                          if (!context.mounted) return;
                          if (viewModel.state.submitted) {
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
                            letterSpacing: 1.0,
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
          'assets/images/student-code-icon.png', // Reuse same icon or create business one
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

