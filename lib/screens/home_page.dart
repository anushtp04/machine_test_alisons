import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_test_alisons/blocs/auth/auth_state.dart';
import 'package:machine_test_alisons/blocs/auth/auth_bloc.dart';
import 'package:machine_test_alisons/blocs/home/home_bloc.dart';
import 'package:machine_test_alisons/blocs/home/home_event.dart';
import 'package:machine_test_alisons/blocs/home/home_state.dart';
import 'package:machine_test_alisons/models/home_response_model.dart';
import 'package:machine_test_alisons/models/product_model.dart';
import 'package:machine_test_alisons/utils/constants/app_colors.dart';
import 'package:machine_test_alisons/utils/constants/app_typography.dart';
import 'package:machine_test_alisons/widget/banner_widget.dart';
import 'package:machine_test_alisons/widget/category_item.dart';
import 'package:machine_test_alisons/widget/product_card.dart';
import 'package:machine_test_alisons/widget/section_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  void _loadHomeData() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<HomeBloc>().add(
        LoadHome(id: authState.id, token: authState.token),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }
            if (state is HomeError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadHomeData,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            if (state is HomeLoaded) {
              return _buildHomeContent(state.homeData);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildHomeContent(HomeResponse data) {
    // Split products for different sections
    final allProducts = data.newArrivals;
    final featuredProducts = allProducts.take(2).toList();
    final bestSelling = allProducts.length > 2
        ? allProducts.sublist(
            2,
            allProducts.length >= 4 ? 4 : allProducts.length,
          )
        : <Product>[];
    final recentlyAdded = allProducts.length > 4
        ? allProducts.sublist(
            4,
            allProducts.length >= 6 ? 6 : allProducts.length,
          )
        : <Product>[];
    final popularProducts = featuredProducts;
    final trendingProducts = bestSelling;

    return CustomScrollView(
      slivers: [
        // Top App Bar
        SliverToBoxAdapter(child: _buildTopBar()),

        // Banner 1
        if (data.banner1.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: BannerWidget(banner: data.banner1.first),
            ),
          ),

        // Categories
        SliverToBoxAdapter(
          child: SectionHeader(
            title: 'Categories',
            onPrevious: () {},
            onNext: () {},
          ),
        ),
        SliverToBoxAdapter(child: _buildCategoriesList(data)),

        // Featured Products
        SliverToBoxAdapter(
          child: SectionHeader(
            title: 'Featured Products',
            onPrevious: () {},
            onNext: () {},
          ),
        ),
        SliverToBoxAdapter(child: _buildProductGrid(featuredProducts)),

        // Daily Best Selling
        if (bestSelling.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Daily Best Selling',
              onPrevious: () {},
              onNext: () {},
            ),
          ),
          SliverToBoxAdapter(child: _buildProductGrid(bestSelling)),
        ],

        // Banner 2
        if (data.banner2.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: BannerWidget(banner: data.banner2.first),
            ),
          ),

        // Recently Added
        if (recentlyAdded.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Recently Added',
              onPrevious: () {},
              onNext: () {},
            ),
          ),
          SliverToBoxAdapter(child: _buildProductGrid(recentlyAdded)),
        ],

        // Popular Products
        SliverToBoxAdapter(
          child: SectionHeader(
            title: 'Popular Products',
            onPrevious: () {},
            onNext: () {},
          ),
        ),
        SliverToBoxAdapter(child: _buildProductGrid(popularProducts)),

        // Trending Products
        if (trendingProducts.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Trending Products',
              onPrevious: () {},
              onNext: () {},
            ),
          ),
          SliverToBoxAdapter(child: _buildProductGrid(trendingProducts)),
        ],

        // Bottom spacing
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
      ],
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Logo area
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.eco, color: AppColors.primary, size: 24),
          ),
          const Spacer(),
          _buildTopBarIcon(Icons.search),
          const SizedBox(width: 12),
          _buildTopBarIcon(Icons.favorite_border),
          const SizedBox(width: 12),
          _buildTopBarIcon(Icons.notifications_none),
        ],
      ),
    );
  }

  Widget _buildTopBarIcon(IconData icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Icon(icon, size: 20, color: AppColors.textPrimary),
    );
  }

  Widget _buildCategoriesList(HomeResponse data) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: data.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return CategoryItem(
            category: data.categories[index].category,
            onTap: () {},
          );
        },
      ),
    );
  }

  Widget _buildProductGrid(List<Product> products) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.62,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductCard(
            product: products[index],
            onTap: () {},
            onAddToCart: () {},
            onFavorite: () {},
          );
        },
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'Home', 0),
              _buildNavItem(Icons.grid_view, 'Categories', 1),
              _buildNavItem(Icons.shopping_cart_outlined, 'Cart', 2),
              _buildNavItem(Icons.person_outline, 'Profile', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentNavIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentNavIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.textXs.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
