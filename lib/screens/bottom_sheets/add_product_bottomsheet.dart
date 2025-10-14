import 'package:flutter/material.dart';
import 'package:proyecto_uno/controllers/product_dao.dart';
import 'package:proyecto_uno/models/product_model.dart';
import '../../style/styles.dart';

class AddProductBottomSheet extends StatefulWidget {
  final int clientId; // ID del cliente para registrar la compra

  const AddProductBottomSheet({
    super.key,
    required this.clientId,
  });

  @override
  State<AddProductBottomSheet> createState() => _AddProductBottomSheetState();
}

class _AddProductBottomSheetState extends State<AddProductBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  //Future<List<ProductModel>>? _filteredProducts;
  //Future<List<ProductModel>>? _futureProducts = ProductDao().getProducts();
  List<ProductModel> _allProducts = [];
  List<ProductModel> _filteredProducts = [];
  final Map<int, int> _quantities = {}; // {productId: quantity}
  List<ProductModel> _selectedProducts = [];

  @override
  void initState() {
    super.initState();
    // Cuando el widget se inicie, la lista filtrada es igual a la lista completa
    // _filteredProducts = _allProducts;

    _loadProducts();
    // ✅ 2. Añade un listener para reaccionar a los cambios de texto
    _searchController.addListener(_filterProducts);
  }
  // CARGAR LISTA DE PROUCTOS
  Future<void> _loadProducts() async {
    final products = await ProductDao().getProducts();
    setState(() {
      _allProducts = products;
      _filteredProducts = products;
    });
  }
  //
  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _allProducts
          .where((p) => p.name.toLowerCase().contains(query))
          .toList();
    });
  }
  //
  void _increaseQuantity(ProductModel product) {
    setState(() {
      _quantities[product.productId] = (_quantities[product.productId] ?? 0) + 1;
      _updateSelectedProducts();
    });
  }

  void _decreaseQuantity(ProductModel product) {
    setState(() {
      final current = _quantities[product.productId] ?? 0;
      if (current > 0) {
        _quantities[product.productId] = current - 1;
        if (_quantities[product.productId] == 0) {
          _quantities.remove(product.productId);
        }
      }
      _updateSelectedProducts();
    });
  }

  void _updateSelectedProducts() {
    _selectedProducts = _allProducts
        .where((p) => (_quantities[p.productId] ?? 0) > 0)
        .toList();
  }

  void _confirmProducts() {
    if (_selectedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona al menos un producto')),
      );
      return;
    }
    // Aquí puedes navegar o devolver los productos seleccionados
    Navigator.pop(context, _selectedProducts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // Obtenemos los paddings de la pantalla
    final EdgeInsets viewInsets = MediaQuery.of(context).viewInsets;
    final EdgeInsets viewPadding = MediaQuery.of(context).viewPadding;
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 20,
        bottom: viewInsets.bottom + viewPadding.bottom +16,
      ),
      child: SingleChildScrollView(
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.background,//Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Selecciona productos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // BUSCADOR
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar producto...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
              //onChanged: (value) {
              //   // Aquí irá la lógica para filtrar la lista de productos
              //   _filterProducts(value);
              //},
            ),

            // LISTA DE PRODUCTOS SELECCIONADOS
            if (_selectedProducts.isNotEmpty) ...[
              const Divider(thickness: 1),
              const Text(
                "Productos seleccionados:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Column(
                children: _selectedProducts.map((p) {
                  final q = _quantities[p.productId] ?? 0;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(p.name)),
                      Text("x$q"),
                      Text("\$${(p.unitPrice * q).toStringAsFixed(2)}"),
                    ],
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 20),

            // LISTA DE PRODUCTOS
            FutureBuilder<List<ProductModel>>(
              future: ProductDao().getProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Text('Error al cargar productos');
                }
                if (_filteredProducts.isEmpty) {
                  return const Text('No se encontraron productos');
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = _filteredProducts[index];
                    final quantity = _quantities[product.productId] ?? 0;

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        title: Text(product.name),
                        subtitle: Text(
                          "${product.unitMeasure} | \$${product.unitPrice}",
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () => _decreaseQuantity(product),
                            ),
                            Text(
                              quantity.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () => _increaseQuantity(product),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 20),

            // BOTONES PRINCIPALES
            ElevatedButton(
              style: AppButtonStyles.primaryButton,
              onPressed: _confirmProducts,
              child: const Text(
                  "Pagar",
                style: AppTextStyles.textButton,
              ),
            ),
            const SizedBox(height: 10),

            // botones CRÉDITO Y PEDIDO
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: AppButtonStyles.secondaryButton,
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Crédito"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: ElevatedButton(
                      style: AppButtonStyles.secondaryButton,
                      onPressed: _confirmProducts,
                      child: const Text("Pedido"),
                    ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
