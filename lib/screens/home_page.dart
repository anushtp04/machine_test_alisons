import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_test_alisons/blocs/auth/auth_state.dart';
import 'package:machine_test_alisons/blocs/auth/auth_bloc.dart';
import 'package:machine_test_alisons/blocs/cart/cart_bloc.dart';
import 'package:machine_test_alisons/blocs/cart/cart_event.dart';
import 'package:machine_test_alisons/blocs/home/home_bloc.dart';
import 'package:machine_test_alisons/blocs/home/home_event.dart';
import 'package:machine_test_alisons/blocs/home/home_state.dart';
import 'package:machine_test_alisons/screens/product_details_screen.dart';
import 'package:machine_test_alisons/models/home_response_model.dart';
import 'package:machine_test_alisons/models/product_model.dart';
import 'package:machine_test_alisons/utils/constants/app_colors.dart';
import 'package:machine_test_alisons/widget/banner_widget.dart';
import 'package:machine_test_alisons/widget/category_item.dart';
import 'package:machine_test_alisons/widget/product_card.dart';
import 'package:machine_test_alisons/widget/section_header.dart';
import 'package:machine_test_alisons/gen/assets.gen.dart';
import 'package:machine_test_alisons/screens/favorite_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  void _loadHomeData() {
    final authState = context.read<AuthBloc>().state;
    String id = '';
    String token = '';
    if (authState is Authenticated) {
      id = authState.id;
      token = authState.token;
    }
    context.read<HomeBloc>().add(LoadHome(id: id, token: token));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Assets.png.logo.image(),
          ),
        ),
        actions: [
          _buildTopBarIcon(Icons.search),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoriteScreen()),
              );
            },
            child: _buildTopBarIcon(Icons.favorite_border),
          ),
          const SizedBox(width: 12),
          _buildTopBarIcon(Icons.notifications_none),
          const SizedBox(width: 16),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
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

  Widget _buildTopBarIcon(IconData icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 20, color: Colors.white),
    );
  }

  Widget _buildCategoriesList(HomeResponse data) {
    return SizedBox(
      height: 120,
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProductDetailsScreen(product: products[index]),
                ),
              );
            },
            onAddToCart: () {
              context.read<CartBloc>().add(AddToCart(products[index]));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${products[index].name} added to cart'),
                ),
              );
            },
            onFavorite: () {},
          );
        },
      ),
    );
  }
}
