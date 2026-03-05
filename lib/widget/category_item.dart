import 'package:flutter/material.dart';
import 'package:machine_test_alisons/models/category_model.dart';
import 'package:machine_test_alisons/utils/constants/app_colors.dart';
import 'package:machine_test_alisons/utils/constants/app_constants.dart';
import 'package:machine_test_alisons/utils/constants/app_typography.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CategoryItem extends StatelessWidget {
  final Category category;
  final VoidCallback? onTap;

  const CategoryItem({Key? key, required this.category, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl = category.image.startsWith('http')
        ? category.image
        : '${AppConstants.categoryImageBase}${category.image}';

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 85,
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[100],
                border: Border.all(color: AppColors.lightGrey, width: 1),
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[100],
                    child: const Icon(
                      Icons.category,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[100],
                    child: const Icon(
                      Icons.category,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              category.name,
              style: AppTypography.textXs.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
