import 'package:adcc/features/store/view/sections/Store%20Details/store_safety_secction.dart';
import 'package:adcc/shared/widgets/banner_header.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../models/store_item_model.dart';
import '../../repositories/store_repository.dart';
import '../sections/Store Details/store_product_info_section.dart';
import '../sections/Store Details/store_seller_section.dart';
import '../sections/Store Details/store_description_section.dart';
import '../sections/Store Details/store_product_details_section.dart';
import '../sections/Store Details/store_action_buttons_section.dart';

class StoreDetailsScreen extends StatefulWidget {
  final String productId;

  const StoreDetailsScreen({
    super.key,
    required this.productId,
  });

  @override
  State<StoreDetailsScreen> createState() => _StoreDetailsScreenState();
}

class _StoreDetailsScreenState extends State<StoreDetailsScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _productData;
  final StoreRepository _storeRepository = StoreRepository();

  @override
  void initState() {
    super.initState();
    _loadProductData();
  }

  Future<void> _loadProductData() async {
    final item = await _storeRepository.fetchItemById(widget.productId);

    if (item != null) {
      setState(() {
        _productData = _toScreenMap(item);
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _productData = {
        'id': widget.productId,
        'image': 'assets/images/store_header_banner.png',
        'title': 'Trek Domane',
        'location': 'Sharjah',
        'timePosted': '2 days ago',
        'currentPrice': 'AED 7,500',
        'originalPrice': 'AED 9,000',
        'isNegotiable': true,
        'sellerName': 'Mahmoud shaalan',
        'sellerImage': 'assets/images/profile.png',
        'listingCount': 3,
        'rating': 4.9,
        'description':
            'Professional carbon fiber road bike, barely used. Shimano Ultegra groupset, excellent condition.',
        'productDetails': [
          'Size: 54cm',
          'Disc Brakes',
          'Carbon Fiber Frame',
        ],
      };
      _isLoading = false;
    });
  }

  Map<String, dynamic> _toScreenMap(StoreItemModel item) {
    return {
      'id': item.id,
      'image': item.image,
      'title': item.title,
      'location': item.location,
      'timePosted': item.timePosted,
      'currentPrice': item.price,
      'originalPrice': null,
      'isNegotiable': true,
      'sellerName': item.postedBy,
      'sellerImage': 'assets/images/profile.png',
      'listingCount': 0,
      'rating': 4.8,
      'description': item.description,
      'productDetails': item.details,
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.softCream,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_productData == null) {
      return Scaffold(
        backgroundColor: AppColors.softCream,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Failed to load product details'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.softCream,
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: BannerHeadder(
                imagePath: _productData!['image'] as String,
                title: '',
                subtitle: '',
                onBackTap: () => Navigator.pop(context),
                height: 350,
              ),
            ),

            const SizedBox(height: 16),

            // Product Info Section (title, location, time, price)
            StoreProductInfoSection(
              title: _productData!['title'] as String,
              location: _productData!['location'] as String,
              timePosted: _productData!['timePosted'] as String,
              currentPrice: _productData!['currentPrice'] as String,
              originalPrice: _productData!['originalPrice'] as String?,
              isNegotiable: _productData!['isNegotiable'] as bool? ?? false,
            ),

            const SizedBox(height: 16),

            // Seller Information Section
            StoreSellerSection(
              sellerName: _productData!['sellerName'] as String,
              sellerImage: _productData!['sellerImage'] as String,
              sellerLocation: _productData!['location'] as String,
              listingCount: _productData!['listingCount'] as int,
              rating: _productData!['rating'] as double,
            ),

            const SizedBox(height: 24),

            // Description Section
            StoreDescriptionSection(
              description: _productData!['description'] as String,
            ),

            const SizedBox(height: 40),

            // Product Details Section (tags/pills)
            StoreProductDetailsSection(
              details: _productData!['productDetails'] as List<String>,
            ),

            const SizedBox(height: 30),
            const StoreSafetySection(),
const SizedBox(height: 40),
            // Action Buttons Section
            StoreActionButtonsSection(
              onWhatsApp: () {
              
              },
              onCall: () {
              
              },
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

