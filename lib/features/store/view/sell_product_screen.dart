import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'live_posted_screen.dart';

class SellProductScreen extends StatefulWidget {
  const SellProductScreen({super.key});

  @override
  State<SellProductScreen> createState() => _SellProductScreenState();
}

class _SellProductScreenState extends State<SellProductScreen> {
  final _productNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _phoneController = TextEditingController();
  final _categoryController = TextEditingController();
  final _conditionController = TextEditingController();
  final _currencyController = TextEditingController(text: 'AED');

  String _selectedContactMethod = 'Select contact method';
  String _selectedCity = 'Select city';

  final List<XFile> _selectedPhotos = [];
  final ImagePicker _imagePicker = ImagePicker();

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

  Future<void> _pickPhotosFromGallery() async {
    final files = await _imagePicker.pickMultiImage(
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );

    if (files.isEmpty) return;

    setState(() {
      final remaining = 5 - _selectedPhotos.length;
      _selectedPhotos.addAll(files.take(remaining));
    });
  }

  void _removePhoto(int index) {
    setState(() => _selectedPhotos.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 36, 16, 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(context),
                  const SizedBox(height: 58),

                  _label('Product Photos'),
                  const SizedBox(height: 12),
                  _photoUploader(),

                  const SizedBox(height: 30),
                  _label('Product Name'),
                  const SizedBox(height: 15),
                  _input(
                    controller: _productNameController,
                    hint: 'e.g., Specialized Tarmac SL7',
                  ),

                  const SizedBox(height: 30),
                  _label('Category'),
                  const SizedBox(height: 15),
                  _input(
                    controller: _categoryController,
                    hint: 'Select category',
                  ),

                  const SizedBox(height: 30),
                  _label('Condition'),
                  const SizedBox(height: 15),
                  _input(
                    controller: _conditionController,
                    hint: 'Select condition',
                  ),

                  const SizedBox(height: 30),
                  Row(
                    children: [
                      SizedBox(
                        width: 155,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('Currency'),
                            const SizedBox(height: 15),
                            _input(
                              controller: _currencyController,
                              hint: 'AED',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('Price'),
                            const SizedBox(height: 15),
                            _input(
                              controller: _priceController,
                              hint: '0',
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  _label('Description'),
                  const SizedBox(height: 15),
                  _input(
                    controller: _descriptionController,
                    hint:
                        'Describe your item, its condition, and any relevant details...',
                  ),

                  const SizedBox(height: 35),
                  _label('Preferred Contact Method'),
                  const SizedBox(height: 15),
                  _dropdown(
                    value: _selectedContactMethod,
                    items: _contactMethods,
                    onChanged: (value) {
                      setState(() {
                        _selectedContactMethod =
                            value ?? _selectedContactMethod;
                      });
                    },
                  ),

                  const SizedBox(height: 30),
                  _label('Phone Number'),
                  const SizedBox(height: 15),
                  _input(
                    controller: _phoneController,
                    hint: '+971 50 123 4567',
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 30),
                  _label('City'),
                  const SizedBox(height: 15),
                  _dropdown(
                    value: _selectedCity,
                    items: _cities,
                    onChanged: (value) {
                      setState(() {
                        _selectedCity = value ?? _selectedCity;
                      });
                    },
                  ),

                  const SizedBox(height: 50),
                  SizedBox(
                    width: double.infinity,
                    height: 51,
                    child: ElevatedButton(
                      onPressed: _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xFFF9660E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'List Item for Sale',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 24 / 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 19),
                  const Center(
                    child: SizedBox(
                      width: 306,
                      child: Text(
                        'By listing your item, you agree to our terms of service and marketplace guidelines.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 16 / 12,
                          color: Color(0xFF6A7282),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return SizedBox(
      height: 35,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 35,
                height: 35,
                padding: const EdgeInsets.fromLTRB(10, 10, 7.54, 9.46),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(249, 102, 14, 0.4),
                  borderRadius: BorderRadius.circular(53.8462),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  size: 13,
                  color: Color(0xFFF9660E),
                ),
              ),
            ),
          ),
          const Text(
            'Sell your product',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 22,
              fontWeight: FontWeight.w600,
              height: 28 / 22,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Outfit',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 20 / 16,
        color: Color(0xFF1A1C20),
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return SizedBox(
      height: 43,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontFamily: 'Outfit',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 20 / 16,
          color: Color(0xFF1A1C20),
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 20 / 16,
            color: Color(0xFFA0A0A0),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFCACACA)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFCACACA)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFF9660E)),
          ),
        ),
      ),
    );
  }

  Widget _dropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 43,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFCACACA)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            size: 16,
            color: Color(0xFFA0A0A0),
          ),
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 20 / 16,
            color: Color(0xFF1A1C20),
          ),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: item.startsWith('Select')
                      ? const Color(0xFFA0A0A0)
                      : const Color(0xFF1A1C20),
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _photoUploader() {
    if (_selectedPhotos.isNotEmpty) {
      return Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _selectedPhotos.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(_selectedPhotos[index].path),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => _removePhoto(index),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF9660E),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 14,
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
                height: 43,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFCACACA)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '+ Add More (${5 - _selectedPhotos.length} remaining)',
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    color: Color(0xFF6A7282),
                  ),
                ),
              ),
            ),
          ],
        ],
      );
    }

    return GestureDetector(
      onTap: _pickPhotosFromGallery,
      child: Container(
        width: double.infinity,
        height: 159,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFCACACA)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 48,
              color: Color(0xFF6A7282),
            ),
            SizedBox(height: 8),
            Text(
              'Tap to upload photos',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 20 / 14,
                color: Color(0xFF99A1AF),
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Up to 5 photos',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 16 / 12,
                color: Color(0xFF6A7282),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LivePostedScreen(
          title: _productNameController.text,
          price: '${_priceController.text} AED',
          imagePath:
              _selectedPhotos.isNotEmpty ? _selectedPhotos.first.path : null,
        ),
      ),
    );
  }
}