import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_button.dart';
import 'live_posted_screen.dart';

class SellProductScreen extends StatefulWidget {
  const SellProductScreen({super.key});

  @override
  State<SellProductScreen> createState() => _SellProductScreenState();
}

class _SellProductScreenState extends State<SellProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _phoneController = TextEditingController();
final _categoryController = TextEditingController();
final _conditionController = TextEditingController();
final _currencyController = TextEditingController();
  String _selectedCategory = 'Select category';
  String _selectedCondition = 'Select condition';
  String _selectedCurrency = 'AED';
  String _selectedContactMethod = 'Select contact method';
  String _selectedCity = 'Select city';

  // Real-time validation error states
  String? _productNameError;
  String? _priceError;
  String? _descriptionError;
  String? _phoneError;
  String? _categoryError;
  String? _conditionError;
  String? _contactMethodError;
  String? _cityError;

  // Track if form has been submitted
  bool _formSubmitted = false;

  // Track selected photos
  final List<XFile> _selectedPhotos = [];
  final ImagePicker _imagePicker = ImagePicker();

  final List<String> _categories = [
    'Select category',
    'Cycles',
    'Apparel',
    'Accessories',
  ];

  final List<String> _conditions = [
    'Select condition',
    'New',
    'Like New',
    'Good',
    'Fair',
  ];

  final List<String> _currencies = ['AED', 'USD', 'EUR'];

  final List<String> _contactMethods = [
    'Select contact method',
    'Call',
    'WhatsApp',
    'Email',
  ];

  final List<String> _cities = [
    'Select city',
    'Dubai',
    'Abu Dhabi',
    'Sharjah',
    'Al Ain',
    'Khusab',
    'Fujairah',
    'Ras Al Khaimah',
    'Umm Al Quwain',
  ];

  @override
  void initState() {
    super.initState();
    // Add real-time validation listeners
    _productNameController.addListener(_validateProductName);
    _priceController.addListener(_validatePrice);
    _descriptionController.addListener(_validateDescription);
    _phoneController.addListener(_validatePhone);
  }

 @override
void dispose() {
  _productNameController.dispose();
  _priceController.dispose();
  _descriptionController.dispose();
  _phoneController.dispose();
  _categoryController.dispose();
  _conditionController.dispose();
  _currencyController.dispose();
  super.dispose();
}

  // Photo picker method
  Future<void> _pickPhotosFromGallery() async {
    try {
      final List<XFile> pickedFiles = await _imagePicker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFiles.isNotEmpty) {
        setState(() {
          // Limit to 5 photos maximum
          if (_selectedPhotos.length + pickedFiles.length > 5) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Maximum 5 photos allowed. You can add ${5 - _selectedPhotos.length} more.',
                ),
                backgroundColor: AppColors.deepRed,
              ),
            );
            // Add only the amount that fits
            int remaining = 5 - _selectedPhotos.length;
            _selectedPhotos.addAll(pickedFiles.take(remaining));
          } else {
            _selectedPhotos.addAll(pickedFiles);
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Error picking images'),
          backgroundColor: AppColors.deepRed,
        ),
      );
    }
  }

  // Remove photo method
  void _removePhoto(int index) {
    setState(() {
      _selectedPhotos.removeAt(index);
    });
  }

  // Real-time validation methods (only update if form has been submitted)
  void _validateProductName() {
    if (!_formSubmitted) return;
    setState(() {
      final value = _productNameController.text.trim();
      if (value.isEmpty) {
        _productNameError = 'Please enter a product name';
      } else if (value.length < 3) {
        _productNameError = 'Product name must be at least 3 characters';
      } else {
        _productNameError = null;
      }
    });
  }

  void _validatePrice() {
    if (!_formSubmitted) return;
    setState(() {
      final value = _priceController.text.trim();
      if (value.isEmpty) {
        _priceError = 'Please enter a price';
      } else if (double.tryParse(value) == null) {
        _priceError = 'Please enter a valid number';
      } else if (double.parse(value) <= 0) {
        _priceError = 'Price must be greater than 0';
      } else {
        _priceError = null;
      }
    });
  }

  void _validateDescription() {
    if (!_formSubmitted) return;
    setState(() {
      final value = _descriptionController.text.trim();
      if (value.isEmpty) {
        _descriptionError = 'Please enter a description';
      } else if (value.length < 10) {
        _descriptionError = 'Description must be at least 10 characters';
      } else {
        _descriptionError = null;
      }
    });
  }

  void _validatePhone() {
    if (!_formSubmitted) return;
    setState(() {
      final value = _phoneController.text.trim();
      if (value.isEmpty) {
        _phoneError = 'Please enter a phone number';
      } else if (value.length < 7) {
        _phoneError = 'Please enter a valid phone number';
      } else {
        _phoneError = null;
      }
    });
  }

  void _validateCategory() {
    if (!_formSubmitted) return;
    setState(() {
      if (_selectedCategory == 'Select category') {
        _categoryError = 'Please select a category';
      } else {
        _categoryError = null;
      }
    });
  }

  void _validateCondition() {
    if (!_formSubmitted) return;
    setState(() {
      if (_selectedCondition == 'Select condition') {
        _conditionError = 'Please select a condition';
      } else {
        _conditionError = null;
      }
    });
  }

  void _validateContactMethod() {
    if (!_formSubmitted) return;
    setState(() {
      if (_selectedContactMethod == 'Select contact method') {
        _contactMethodError = 'Please select a contact method';
      } else {
        _contactMethodError = null;
      }
    });
  }

  void _validateCity() {
    if (!_formSubmitted) return;
    setState(() {
      if (_selectedCity == 'Select city') {
        _cityError = 'Please select a city';
      } else {
        _cityError = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softCream,
      appBar: AppBar(
        backgroundColor: AppColors.softCream,
        elevation: 0,
        leading: Align(
          alignment: Alignment.center,
          child: InkWell(
            onTap: Navigator.of(context).canPop() ? () => Navigator.of(context).pop() : null,
            borderRadius: BorderRadius.circular(999),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.deepRed.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: AppColors.deepRed,
                size: 20,
              ),
            ),
          ),
        ),
        title: const Text(
  "Sell your product",
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.0, // 100% line height
    letterSpacing: 0,
    color: Colors.black,
  ),
),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Photos Section
                _buildProductPhotosSection(),
                const SizedBox(height: 24),

                // Product Name
                _buildSectionLabel('Product Name'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _productNameController,
                  placeholder: 'e.g., Specialized Tarmac SL7',
                  errorText: _productNameError,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter a product name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Category
                _buildSectionLabel('Category'),
                const SizedBox(height: 8),
              _buildTextField(
  controller: _categoryController,
  placeholder: 'Select category',
),
                const SizedBox(height: 20),

                // Condition
                _buildSectionLabel('Condition'),
                const SizedBox(height: 8),
_buildTextField(
  controller: _conditionController,
  placeholder: 'Select condition',
),
                const SizedBox(height: 20),

                // Currency and Price
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionLabel('Currency'),
                          const SizedBox(height: 8),
                       _buildTextField(
  controller: _currencyController,
  placeholder: 'AED',
),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionLabel('Price'),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 50,
                            child: _buildTextFieldWithoutError(
                              controller: _priceController,
                              placeholder: '0',
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Please enter a price';
                                }
                                return null;
                              },
                            ),
                          ),
                          if (_priceError != null && _priceError!.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              _priceError!,
                              style: const TextStyle(
                                color: AppColors.deepRed,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Description
                _buildSectionLabel('Description'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _descriptionController,
                  placeholder: 'Describe your item, its condition, a...',
                  maxLines: 1,
                  errorText: _descriptionError,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Preferred Contact Method
                _buildSectionLabel('Preferred Contact Method'),
                const SizedBox(height: 8),
                _buildDropdown(
                  value: _selectedContactMethod,
                  items: _contactMethods,
                  errorText: _contactMethodError,
                  onChanged: (value) {
                    setState(() => _selectedContactMethod =
                        value ?? _selectedContactMethod);
                    _validateContactMethod();
                  },
                ),
                const SizedBox(height: 20),

                // Phone Number
                _buildSectionLabel('Phone Number'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _phoneController,
                  placeholder: '+971 50 123 4567',
                  keyboardType: TextInputType.phone,
                  errorText: _phoneError,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter a phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // City
                _buildSectionLabel('City'),
                const SizedBox(height: 8),
                _buildDropdown(
                  value: _selectedCity,
                  items: _cities,
                  errorText: _cityError,
                  onChanged: (value) {
                    setState(() => _selectedCity = value ?? _selectedCity);
                    _validateCity();
                  },
                ),
                const SizedBox(height: 32),

                // List Item for Sale Button
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
  label: 'List Item for Sale',
  onPressed: _handleSubmit,
  type: AppButtonType.primary,
  backgroundColor: AppColors.deepRed,
  textColor: Colors.white,
  height: 50,
  borderRadius: 10,
  textStyle: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5, // 24px line height
    letterSpacing: 0,
  ),
),
                ),

                const SizedBox(height: 12),

                // Terms Notice
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
  'By listing your item, you agree to our terms of service and marketplace guidelines.',
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33, // 16px line height
    letterSpacing: 0,
    color: Color(0xFF6A7282),
  ),
),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductPhotosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('Product Photos'),
        const SizedBox(height: 12),
        if (_selectedPhotos.isEmpty)
          GestureDetector(
            onTap: _pickPhotosFromGallery,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.charcoal.withValues(alpha: 0.2),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                child: Column(
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      size: 48,
                      color: AppColors.charcoal.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 12),
                   Text(
  'Tap to upload photos',
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43, // 20px line height
    letterSpacing: 0,
    color: Color(0xFF99A1AF),
  ),
),
                    const SizedBox(height: 4),
                  Text(
  'Up to 5 photos',
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33, // 16px line height
    letterSpacing: 0,
    color: Color(0xFF6A7282),
  ),
),
                  ],
                ),
              ),
            ),
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display selected photos in a grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _selectedPhotos.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.charcoal.withValues(alpha: 0.1),
                            width: 1.5,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child: Image.file(
                            File(_selectedPhotos[index].path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removePhoto(index),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: AppColors.deepRed,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              if (_selectedPhotos.length < 5) ...[
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: _pickPhotosFromGallery,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.charcoal.withValues(alpha: 0.2),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.softCream,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          '+ Add More (${5 - _selectedPhotos.length} remaining)',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.charcoal.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
      ],
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
  label,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.0, // 100% line height
    letterSpacing: 0,
    color: AppColors.textDark,
  ),
);
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String placeholder,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
    String? errorText,
  }) {
    final hasError = errorText != null && errorText.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
           hintText: placeholder,
hintStyle: const TextStyle(
  fontFamily: "Outfit",
  fontSize: 16,
  fontWeight: FontWeight.w400,
  height: 1.0, // 100% line height
  letterSpacing: 0,
  color: Color(0xFFA0A0A0),
),
            filled: true,
            fillColor: hasError
                ? AppColors.deepRed.withValues(alpha: 0.05)
                : AppColors.softCream,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: hasError
                    ? AppColors.deepRed
                    : AppColors.charcoal.withValues(alpha: 0.1),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: hasError
                    ? AppColors.deepRed
                    : AppColors.charcoal.withValues(alpha: 0.1),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: hasError ? AppColors.deepRed : AppColors.deepRed,
                width: 1.5,
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        if (hasError) ...
          [
            const SizedBox(height: 6),
            Text(
              errorText,
              style: const TextStyle(
                color: AppColors.deepRed,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
      ],
    );
  }

  Widget _buildTextFieldWithoutError({
    required TextEditingController controller,
    required String placeholder,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    final hasError = _priceError != null && _priceError!.isNotEmpty;
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: TextStyle(
          color: AppColors.charcoal.withValues(alpha: 0.5),
        ),
        filled: true,
        fillColor: hasError
            ? AppColors.deepRed.withValues(alpha: 0.05)
            : AppColors.softCream,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: hasError
                ? AppColors.deepRed
                : AppColors.charcoal.withValues(alpha: 0.1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: hasError
                ? AppColors.deepRed
                : AppColors.charcoal.withValues(alpha: 0.1),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: hasError ? AppColors.deepRed : AppColors.deepRed,
            width: 1.5,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    String? errorText,
  }) {
    final hasError = errorText != null && errorText.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(
              color: hasError
                  ? AppColors.deepRed
                  : AppColors.charcoal.withValues(alpha: 0.1),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(10),
            color: hasError
                ? AppColors.deepRed.withValues(alpha: 0.05)
                : Colors.transparent,
          ),
          child: DropdownButton<String>(
            value: value,
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
            isExpanded: true,
            underline: const SizedBox(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 14,
            ),
            hint: Text(
  value,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.0, // 100% line height
    letterSpacing: 0,
    color: Color(0xFFA0A0A0),
  ),
),
          ),
        ),
        if (hasError) ...
          [
            const SizedBox(height: 6),
            Text(
              errorText,
              style: const TextStyle(
                color: AppColors.deepRed,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
      ],
    );
  }

  void _handleSubmit() {
    // Mark form as submitted to enable error display
    setState(() => _formSubmitted = true);

    // // Validate all fields
    // _validateProductName();
    // _validatePrice();
    // _validateDescription();
    // _validatePhone();
    // _validateCategory();
    // _validateCondition();
    // _validateContactMethod();
    // _validateCity();

    // Check if there are any errors
    if (_productNameError == null &&
        _priceError == null &&
        _descriptionError == null &&
        _phoneError == null &&
        _categoryError == null &&
        _conditionError == null &&
        _contactMethodError == null &&
        _cityError == null) {
  

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product listed successfully!'),
          backgroundColor: AppColors.deepRed,
        ),
      );

                                                          
      Future.delayed(const Duration(milliseconds: 400), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LivePostedScreen(
              title: _productNameController.text,
              price: '${_priceController.text} $_selectedCurrency',
              imagePath: _selectedPhotos.isNotEmpty ? _selectedPhotos.first.path : null,
            ),
          ),
        );
      });
    }
  }
}
