class CutOption {
  final String id;
  final String name;
  final String description;

  const CutOption({
    required this.id,
    required this.name,
    required this.description,
  });
}

class WeightOption {
  final String label;
  final String weight;
  final double price;
  final double originalPrice;

  const WeightOption({
    required this.label,
    required this.weight,
    required this.price,
    required this.originalPrice,
  });
}

class Recipe {
  final String id;
  final String title;
  final String prepTime;
  final String difficulty;
  final String imageUrl;

  const Recipe({
    required this.id,
    required this.title,
    required this.prepTime,
    required this.difficulty,
    required this.imageUrl,
  });
}

class MeatCategory {
  final String id;
  final String name;
  final String icon;
  final String bannerImage;

  const MeatCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.bannerImage,
  });
}

class Product {
  final String id;
  final String name;
  final String categoryId;
  final String imageUrl;
  final String description;
  final double price;
  final double originalPrice;
  final String weight;
  final double rating;
  final int reviewsCount;
  final bool isBestseller;
  final bool isAntibioticFree;
  final List<WeightOption> weightOptions;
  final List<CutOption> cutOptions;
  final List<Recipe> recipes;

  const Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.weight,
    required this.rating,
    required this.reviewsCount,
    required this.isBestseller,
    required this.isAntibioticFree,
    required this.weightOptions,
    required this.cutOptions,
    required this.recipes,
  });

  int get discountPercent {
    if (originalPrice <= price) return 0;
    return (((originalPrice - price) / originalPrice) * 100).round();
  }
}
