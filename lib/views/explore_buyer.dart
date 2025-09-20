import 'package:flutter/material.dart';

class ExploreBuyerScreen extends StatefulWidget {
  const ExploreBuyerScreen({super.key});

  @override
  State<ExploreBuyerScreen> createState() => _ExploreBuyerScreenState();
}

class _ExploreBuyerScreenState extends State<ExploreBuyerScreen> {
  String selectedCategory = 'Todos';

  // Categorías para el scroll horizontal
  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Todos',
      'icon': Icons.shopping_bag,
      'isSelected': true,
    },
    {
      'name': 'Comida',
      'icon': Icons.restaurant,
      'isSelected': false,
    },
    {
      'name': 'Papelería',
      'icon': Icons.content_cut,
      'isSelected': false,
    },
    {
      'name': 'Tutorías',
      'icon': Icons.school,
      'isSelected': false,
    },
  ];

  // Productos para el grid vertical
  final List<Map<String, dynamic>> products = [
    {
      'title': 'Tutorias IIND-2106',
      'backgroundColor': const Color(0xFFFFF9C4), // Light yellow
    },
    {
      'title': 'Tutorias ISIS-1221',
      'backgroundColor': const Color(0xFFE8F5E8), // Light green
    },
    {
      'title': 'Venta de brownies',
      'backgroundColor': const Color(0xFFFFE4E1), // Light pink
    },
    {
      'title': 'Venta de funkos',
      'backgroundColor': const Color(0xFFF3E5F5), // Light purple
    },
    {
      'title': 'Comida mexicana',
      'backgroundColor': const Color(0xFFE3F2FD), // Light blue
    },
    {
      'title': 'Comida italiana',
      'backgroundColor': const Color(0xFFFFF9C4), // Light yellow
    },
    {
      'title': 'Tutorias IIND-2106',
      'backgroundColor': const Color(0xFFFFF9C4), // Light yellow
    },
    {
      'title': 'Tutorias ISIS-1221',
      'backgroundColor': const Color(0xFFE8F5E8), // Light green
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Logo/Icon
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC436),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  
                  // Title
                  const Text(
                    'Explorar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Icons
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.favorite_border,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.local_shipping,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar en UniMarket',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Categories (Horizontal Scroll)
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = category['name'] == selectedCategory;
                  
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = category['name'] as String;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFFFC436) : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? const Color(0xFFFFC436) : Colors.grey[300]!,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              category['icon'] as IconData,
                              size: 16,
                              color: isSelected ? Colors.white : Colors.grey[600],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              category['name'] as String,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.black : Colors.black,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Products Grid (Vertical Scroll)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    
                    return Container(
                      decoration: BoxDecoration(
                        color: product['backgroundColor'] as Color,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          // Image placeholder
                          Expanded(
                            flex: 3,
                            child: Container(
                              width: double.infinity,
                              margin: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Image.asset(
                                'assets/images/explore-buyer-image.png',
                                
                                width: 40,
                                height: 40,
                              ),
                            ),
                          ),
                          
                          // Title
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                              child: Text(
                                product['title'] as String,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        height: 60,
        decoration: const BoxDecoration(
          color: Color(0xFFFFC436),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Home
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.home,
                color: Colors.white,
                size: 24,
              ),
            ),
            
            // Search (Selected)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.search,
                color: Colors.white,
                size: 24,
              ),
            ),
            
            // Cart
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.shopping_bag,
                color: Colors.white,
                size: 24,
              ),
            ),
            
            // Profile
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.person,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
