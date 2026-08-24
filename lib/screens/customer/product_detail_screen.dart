import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/country_meat_state.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedWeightIndex = 0;
  int _selectedCutIndex = 0;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CountryMeatStateService>();
    final product = state.products.firstWhere(
      (p) => p.id == widget.productId,
      orElse: () => state.products.first,
    );

    final selectedWeight = product.weightOptions[_selectedWeightIndex.clamp(0, product.weightOptions.length - 1)];
    final selectedCut = product.cutOptions[_selectedCutIndex.clamp(0, product.cutOptions.length - 1)];
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Hero Image Banner
            Stack(
              children: [
                Container(
                  height: 240,
                  width: double.infinity,
                  color: Colors.grey.shade800,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.fastfood, size: 64, color: Colors.white54)),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text('${product.rating} (${product.reviewsCount}+ ratings)', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Guarantee Badge
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.green),
                        ),
                        child: const Text(
                          '🌿 100% Antibiotic & Chemical Free',
                          style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          '⚡ 30-Min Delivery',
                          style: TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    product.description,
                    style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyMedium?.color, height: 1.4),
                  ),
                  const SizedBox(height: 24),

                  // Weight Selection Pills
                  const Text('Select Net Weight', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  Row(
                    children: List.generate(product.weightOptions.length, (index) {
                      final option = product.weightOptions[index];
                      final isSelected = _selectedWeightIndex == index;
                      return Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: ChoiceChip(
                          label: Text('${option.label} (₹${option.price.toStringAsFixed(0)})'),
                          selected: isSelected,
                          selectedColor: primary,
                          labelStyle: TextStyle(color: isSelected ? Colors.white : null, fontWeight: FontWeight.bold),
                          onSelected: (_) {
                            setState(() {
                              _selectedWeightIndex = index;
                            });
                          },
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),

                  // Cut Customization Pills
                  const Text('Select Meat Cut Type', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  Column(
                    children: List.generate(product.cutOptions.length, (index) {
                      final cut = product.cutOptions[index];
                      final isSelected = _selectedCutIndex == index;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? primary.withValues(alpha: 0.1) : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? primary : Theme.of(context).dividerColor.withValues(alpha: 0.2),
                          ),
                        ),
                        child: ListTile(
                          onTap: () {
                            setState(() {
                              _selectedCutIndex = index;
                            });
                          },
                          leading: Icon(
                            isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                            color: isSelected ? primary : Colors.grey,
                          ),
                          title: Text(cut.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          subtitle: Text(cut.description, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),

                  // Recommended Recipes
                  if (product.recipes.isNotEmpty) ...[
                    const Text('Recommended Recipes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    ...product.recipes.map((r) => Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.orange,
                              child: Icon(Icons.menu_book_rounded, color: Colors.white, size: 20),
                            ),
                            title: Text(r.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            subtitle: Text('Prep: ${r.prepTime} • Difficulty: ${r.difficulty}'),
                          ),
                        )),
                  ],
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('PRICE', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                Text(
                  '₹${selectedWeight.price.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  state.addToCart(
                    product,
                    weight: selectedWeight,
                    cut: selectedCut,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Added ${product.name} (${selectedWeight.label}, ${selectedCut.name}) to Cart')),
                  );
                },
                icon: const Icon(Icons.shopping_bag_rounded),
                label: const Text('Add to Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
