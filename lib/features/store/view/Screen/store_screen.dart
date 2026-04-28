import 'package:adcc/features/store/view/sections/Store%20Screen/marketplace_search_box.dart';
import 'package:adcc/features/store/view/sections/Store%20Screen/store_header.dart';
import 'package:adcc/features/store/view/sections/Store%20Screen/store_product_grid.dart';
import 'package:adcc/features/store/viewmodels/store_view_model.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/category_selector.dart';
import 'store_details_screen.dart';
import '../sell_product_screen.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  int _selectedCategoryIndex = 0;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final StoreViewModel _viewModel = StoreViewModel();

  final List<String> _categories = [
    'All',
    'Cycles',
    'Apparel',
    'Accessories',
  ];


  final List<Map<String, dynamic>> _products = [
    {
      'id': 'product_1',
      'image': 'assets/images/cycling_1.png',
      'title': 'Trek Domane',
      'postedBy': 'Mahmoud shaalan',
      'price': '7500 AED',
      'timePosted': '2 days ago',
      'location': 'Sharjah',
      'category': 'Cycles',
    },
    {
      'id': 'product_2',
      'image': 'assets/images/cycling_1.png',
      'title': 'DMT KR0 Road Shoes',
      'postedBy': 'Mark McEvoy',
      'price': '1300 AED',
      'timePosted': '5 days ago',
      'location': 'Khusab',
      'category': 'Apparel',
    },
    {
      'id': 'product_3',
      'image': 'assets/images/cycling_1.png',
      'title': 'Garmin Edge 1030 Plus',
      'postedBy': 'Khalid Al Nahyan',
      'price': '1800 AED',
      'timePosted': '1 day ago',
      'location': 'Al Ain',
      'category': 'Accessories',
    },
    {
      'id': 'product_4',
      'image': 'assets/images/cycling_1.png',
      'title': 'DMT KR0 Road Shoes',
      'postedBy': 'Mark McEvoy',
      'price': '1300 AED',
      'timePosted': '5 days ago',
      'location': 'Khusab',
      'category': 'Apparel',
    },
    {
      'id': 'product_5',
      'image': 'assets/images/cycling_1.png',
      'title': 'Shimano Pedals & Shoes',
      'postedBy': 'Mark McEvoy',
      'price': '850 AED',
      'timePosted': '2 days ago',
      'location': 'Sharjah',
      'category': 'Accessories',
    },
    {
      'id': 'product_6',
      'image': 'assets/images/cycling_1.png',
      'title': 'Trek Domane',
      'postedBy': 'Mahmoud shaalan',
      'price': '7500 AED',
      'timePosted': '2 days ago',
      'location': 'Sharjah',
      'category': 'Cycles',
    },
    {
      'id': 'product_7',
      'image': 'assets/images/cycling_1.png',
      'title': 'DMT KR0 Road Shoes',
      'postedBy': 'Mark McEvoy',
      'price': '1300 AED',
      'timePosted': '5 days ago',
      'location': 'Khusab',
      'category': 'Apparel',
    },
    {
      'id': 'product_8',
      'image': 'assets/images/cycling_1.png',
      'title': 'Garmin Edge 1030 Plus',
      'postedBy': 'Khalid Al Nahyan',
      'price': '1800 AED',
      'timePosted': '1 day ago',
      'location': 'Al Ain',
      'category': 'Accessories',
    },
    {
      'id': 'product_9',
      'image': 'assets/images/cycling_1.png',
      'title': 'Shimano Pedals & Shoes',
      'postedBy': 'Mark McEvoy',
      'price': '850 AED',
      'timePosted': '2 days ago',
      'location': 'Sharjah',
      'category': 'Accessories',
    },
  ];

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onVmChanged);
    _viewModel.loadItems();
  }

  void _onVmChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onVmChanged);
    _viewModel.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softCream,
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
           padding: const EdgeInsets.symmetric(vertical: 24),
          children: [
       
           StoreHeader(
    imagePath: 'assets/images/store_header_banner.png',
    showBackButton: true,
    showNotificationIcon: true,
    onBackTap: () => Navigator.pop(context),
  ),

            // Main Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 28),

        
                  _buildTitleSection(),

                  const SizedBox(height: 21),

                MarketplaceSearchBox(
  controller: _searchController,
  onChanged: (value) {
    setState(() {
      _searchQuery = value;
    });
  },
),
                  const SizedBox(height: 29),

                 
                  CategorySelector(
                    categories: _categories,
                    selectedIndex: _selectedCategoryIndex,
                    onSelected: (index) {
                      setState(() {
                        _selectedCategoryIndex = index;
                      });
                    },
                  ),

                  const SizedBox(height: 40),

                  _buildResultsHeader(),

                  const SizedBox(height: 20),
                  if (_viewModel.isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else
                    StoreProductGrid(
                      products: _getFilteredProducts(),
                      onTap: (product) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StoreDetailsScreen(
                              productId: product['id'],
                            ),
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          // prevents overflow
          child: Text(
  'Cycling Marketplace',
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 30,
    fontWeight: FontWeight.w600,
    height: 1.0,
    letterSpacing: 0,
    color: AppColors.textDark,
  ),
),
        ),
        const SizedBox(width: 12),
       AppButton(
  label: '+ Sell',
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SellProductScreen(),
      ),
    );
  },
  type: AppButtonType.primary,
  backgroundColor: AppColors.deepRed,
  textColor: Colors.white,
  width: 80,
  height: 36,
  borderRadius: 10,
  textStyle: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.23,
    letterSpacing: 0,
    color: Colors.white,
  ),
),
      ],
    );
  }

  Widget _buildResultsHeader() {
    final filteredProducts = _getFilteredProducts();
    final resultCount = filteredProducts.length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
       Text(
  'Showing $resultCount Result${resultCount != 1 ? 's' : ''}',
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.0,
    letterSpacing: 0,
    color: AppColors.textDark,
  ),
),
        GestureDetector(
          onTap: () {
           
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
             Image.asset(
  "assets/icons/filter.png",
  height: 16,
  width: 16,
  color: AppColors.textDark, 
),
              const SizedBox(width: 6),
              const Text(
  'Filter',
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontFamily: 'Satoshi',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.0,
    letterSpacing: 0,
    color: AppColors.textDark,
  ),
),
            ],
          ),
        ),
      ],
    );
  }


  List<Map<String, dynamic>> _getFilteredProducts() {
    final selectedCategory = _categories[_selectedCategoryIndex];

    final apiProducts = _viewModel
        .filterItems(category: selectedCategory, search: _searchQuery)
        .map((e) => e.toUiMap())
        .toList();

    List<Map<String, dynamic>> filtered =
        apiProducts.isNotEmpty ? apiProducts : List.from(_products);

    // Filter by category
    if (_selectedCategoryIndex > 0) {

      filtered = filtered.where((product) {
        final productCategory = product['category'] ?? '';
        return productCategory == selectedCategory;
      }).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((product) {
        final title = (product['title'] as String).toLowerCase();
        final postedBy = (product['postedBy'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();
        return title.contains(query) || postedBy.contains(query);
      }).toList();
    }

    return filtered;
  }
}
