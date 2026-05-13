import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/auth/Services/auth_services.dart';
import 'package:adcc/features/home/view/home_screen.dart';
import 'package:flutter/material.dart';

class SetupProfileScreen extends StatefulWidget {
  const SetupProfileScreen({super.key});

  @override
  State<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends State<SetupProfileScreen> {
  DateTime? _selectedBirthDate;
  String? _selectedGender;
  String? _selectedCountry;

  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.deepRed,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedBirthDate = picked;
      });
    }
  }

  Future<void> _pickGender() async {
    final value = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        const options = ['Male', 'Female'];
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options
                .map(
                  (option) => ListTile(
                    title: Text(
                      option,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onTap: () => Navigator.pop(context, option),
                  ),
                )
                .toList(),
          ),
        );
      },
    );

    if (value != null) {
      setState(() {
        _selectedGender = value;
      });
    }
  }

  Future<void> _pickCountry() async {
    final value = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        const options = ['UAE', 'India', 'Saudi Arabia', 'Oman'];
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options
                .map(
                  (option) => ListTile(
                    title: Text(
                      option,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onTap: () => Navigator.pop(context, option),
                  ),
                )
                .toList(),
          ),
        );
      },
    );

    if (value != null) {
      setState(() {
        _selectedCountry = value;
      });
    }
  }

  String _birthDateText() {
    if (_selectedBirthDate == null) {
      return 'Choose your birth date';
    }
    final d = _selectedBirthDate!;
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    return '$day/$month/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    const screenBg = Color(0xFFFFF9EF);
    return Scaffold(
      backgroundColor: screenBg,
      body: ColoredBox(
        color: screenBg,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 14),
                child: SizedBox(
                  height: 35,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                          },
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F0F0),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0x1A000000),
                              ),
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              size: 22,
                              color: Color(0xFF2B2B2B),
                            ),
                          ),
                        ),
                      ),
                      const Center(
                        child: Text(
                          'Set up your Profile',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            height: 23 / 18,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: Text(
                            '1/2',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      _buildProfileField(
                        icon: Icons.person_outline,
                        label: 'Enter your full name',
                        child: TextFormField(
                          controller: _nameController,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                            letterSpacing: -0.1,
                            color: Color(0xFF333333),
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isCollapsed: true,
                            hintText: 'Enter your full name',
                            hintStyle: TextStyle(
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                              letterSpacing: -0.1,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildProfileField(
                        icon: Icons.calendar_month_outlined,
                        label: _birthDateText(),
                        onTap: _pickBirthDate,
                      ),
                      const SizedBox(height: 12),
                      _buildProfileField(
                        icon: Icons.wc_outlined,
                        label: _selectedGender ?? 'Choose your Gender',
                        onTap: _pickGender,
                        showChevron: true,
                      ),
                      const SizedBox(height: 12),
                      _buildProfileField(
                        icon: Icons.public,
                        label: _selectedCountry ?? 'Country',
                        onTap: _pickCountry,
                      ),
                      const SizedBox(height: 18),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 39,
                            height: 39,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(60),
                              border: Border.all(
                                color: Colors.black.withValues(alpha: 0.08),
                              ),
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 17,
                              color: Color(0xFF000000),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    fontFamily: 'Outfit',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    height: 18 / 14,
                                    color: Color(0xFF333333),
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "I've read and agreed to ",
                                    ),
                                    TextSpan(
                                      text: 'User Agreement',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF000000),
                                      ),
                                    ),
                                    TextSpan(text: ' and '),
                                    TextSpan(
                                      text: 'Privacy Policy',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF000000),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 51,
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  if (_nameController.text.trim().isEmpty ||
                                      _selectedBirthDate == null ||
                                      _selectedGender == null ||
                                      _selectedCountry == null) {
                                    ScaffoldMessenger.of(
                                      context,
                                    ).showSnackBar(
                                      const SnackBar(
                                        content: Text('Please fill all fields'),
                                      ),
                                    );
                                    return;
                                  }

                                  setState(() => _isLoading = true);

                                  final navigator = Navigator.of(context);
                                  final messenger =
                                      ScaffoldMessenger.of(context);

                                  final dob = _selectedBirthDate!;
                                  final dobString =
                                      '${dob.year.toString().padLeft(4, '0')}-'
                                      '${dob.month.toString().padLeft(2, '0')}-'
                                      '${dob.day.toString().padLeft(2, '0')}';

                                  try {
                                    final response =
                                        await AuthService.registerUser(
                                      fullName: _nameController.text.trim(),
                                      gender: _selectedGender!,
                                      dob: dobString,
                                      country: _selectedCountry,
                                    );

                                    if (!mounted) return;

                                    if (response.success) {
                                      navigator.pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (_) => const HomeScreen(),
                                        ),
                                        (route) => false,
                                      );
                                    } else {
                                      messenger.showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            response.message ??
                                                'Registration failed',
                                          ),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    if (!mounted) return;
                                    messenger.showSnackBar(
                                      SnackBar(content: Text(e.toString())),
                                    );
                                  } finally {
                                    if (mounted) {
                                      setState(() => _isLoading = false);
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0359E8),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Continue',
                                  style: TextStyle(
                                    fontFamily: 'Outfit',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    height: 24 / 16,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 26),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField({
    required IconData icon,
    required String label,
    Widget? child,
    VoidCallback? onTap,
    bool showChevron = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0x3303A4D1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0x4D5D9CA7),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 39,
              height: 39,
              decoration: BoxDecoration(
                color: const Color(0xFF05B484),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(icon, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: child ??
                  Text(
                    label,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                      letterSpacing: -0.1,
                      color: Color(0xFF333333),
                    ),
                  ),
            ),
            if (showChevron)
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 20,
                color: Color(0xFF7A7979),
              ),
          ],
        ),
      ),
    );
  }
}
