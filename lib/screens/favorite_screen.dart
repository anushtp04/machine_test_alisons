import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_test_alisons/blocs/favorite/favorite_bloc.dart';
import 'package:machine_test_alisons/blocs/favorite/favorite_state.dart';
import 'package:machine_test_alisons/blocs/home/home_bloc.dart';
import 'package:machine_test_alisons/blocs/home/home_state.dart';
import 'package:machine_test_alisons/models/product_model.dart';
import 'package:machine_test_alisons/utils/constants/app_colors.dart';
import 'package:machine_test_alisons/utils/constants/app_typography.dart';
import 'package:machine_test_alisons/widget/product_card.dart';
import 'package:machine_test_alisons/screens/product_details_screen.dart';
import 'package:machine_test_alisons/blocs/cart/cart_bloc.dart';
import 'package:machine_test_alisons/blocs/cart/cart_event.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Favorites',
          style: AppTypography.textLg.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, favState) {
          if (favState is FavoriteUpdated &&
              favState.favoriteSlugs.isNotEmpty) {
            return BlocBuilder<HomeBloc, HomeState>(
              builder: (context, homeState) {
                if (homeState is HomeLoaded) {
                  // Find all products that are favorited from new arrivals
                  List<Product> favoritedProducts = homeState
                      .homeData
                      .newArrivals
                      .where(
                        (product) =>
                            favState.favoriteSlugs.contains(product.slug),
                      )
                      .toList();

                  if (favoritedProducts.isEmpty) {
                    return _buildEmptyState();
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.62,
                        ),
                    itemCount: favoritedProducts.length,
                    itemBuilder: (context, index) {
                      final product = favoritedProducts[index];
                      return ProductCard(
                        product: product,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailsScreen(product: product),
                            ),
                          );
                        },
                        onAddToCart: () {
                          context.read<CartBloc>().add(AddToCart(product));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} added to cart'),
                            ),
                          );
                        },
                        onFavorite: null,
                      );
                    },
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              },
            );
          }

          // Empty state
          return _buildEmptyState();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No favorites yet',
            style: AppTypography.textLg.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
