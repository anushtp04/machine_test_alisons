import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:machine_test_alisons/blocs/cart/cart_bloc.dart';
import 'package:machine_test_alisons/blocs/cart/cart_event.dart';
import 'package:machine_test_alisons/blocs/home/home_bloc.dart';
import 'package:machine_test_alisons/blocs/home/home_state.dart';
import 'package:machine_test_alisons/models/product_model.dart';
import 'package:machine_test_alisons/utils/constants/app_colors.dart';
import 'package:machine_test_alisons/utils/constants/app_typography.dart';
import 'package:machine_test_alisons/widget/product_card.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    int discountPercentage = 0;
    try {
      final double currentPrice = double.parse(product.price);
      final double oldP = double.parse(product.oldPrice);
      if (oldP > currentPrice) {
        discountPercentage = ((oldP - currentPrice) / oldP * 100).round();
      }
    } catch (_) {}

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: AppColors.textPrimary,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Section Container
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Stack(
                children: [
                  Center(
                    child: product.image.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: product.image,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary,
                              ),
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                              size: 50,
                            ),
                          )
                        : const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                            size: 50,
                          ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.favorite_border,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Product Information
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTypography.textLg.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.manufacturer,
                    style: AppTypography.textSm.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '₹ ${product.price}',
                        style: AppTypography.textLg.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (product.oldPrice != product.price &&
                          discountPercentage > 0)
                        Text(
                          '₹ ${product.oldPrice}',
                          style: AppTypography.textSm.copyWith(
                            color: AppColors.textSecondary,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      const SizedBox(width: 8),
                      if (discountPercentage > 0)
                        Text(
                          '($discountPercentage% off)',
                          style: AppTypography.textSm.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      const Spacer(),
                      // Share button
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.share_outlined,
                          size: 20,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Description Section
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: AppTypography.textMd.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Bag of Green offers premium Strawberries from South Africa, prized for their vibrant red color, natural sweetness, and juicy texture. Perfect for snacking, desserts, and smoothies, these strawberries are carefully sourced and delivered fresh anywhere in the UAE. Enjoy the delicious taste and quality of South African strawberries at your convenience.',
                    style: AppTypography.textSm.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Related Products Section
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Related Products',
                      style: AppTypography.textMd.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      if (state is HomeLoaded) {
                        final related = state.homeData.newArrivals;
                        return SizedBox(
                          height: 240, // Height for ProductCard
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            scrollDirection: Axis.horizontal,
                            itemCount: related.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 160,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: ProductCard(
                                  product: related[index],
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ProductDetailsScreen(
                                          product: related[index],
                                        ),
                                      ),
                                    );
                                  },
                                  onAddToCart: () {
                                    context.read<CartBloc>().add(
                                      AddToCart(related[index].slug),
                                    );
                                  },
                                  onFavorite: () {},
                                ),
                              );
                            },
                          ),
                        );
                      }
                      return const SizedBox(height: 240);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                context.read<CartBloc>().add(AddToCart(product.slug));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${product.name} added to cart')),
                );
              },
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.white,
              ),
              label: Text(
                'Add To Cart',
                style: AppTypography.textMd.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
