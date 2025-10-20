import 'package:flutter/material.dart';
import 'package:proyecto_uno/controllers/product_dao.dart';
import 'package:proyecto_uno/models/product_model.dart';
import '../../style/styles.dart';

class AddProductBottomSheet extends StatefulWidget {
  final int clientId; // ID del cliente para registrar la compra
  final String clientName;

  const AddProductBottomSheet({
    super.key,
    required this.clientId,
    required this.clientName,
  });

  @override
  State<AddProductBottomSheet> createState() => _AddProductBottomSheetState();
}

class _AddProductBottomSheetState extends State<AddProductBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<ProductModel> _allProducts = [];
  List<ProductModel> _filteredProducts = [];
  final Map<int, int> _quantities = {}; // {productId: quantity}
  List<ProductModel> _selectedProducts = [];
  double _totalPrice = 0.0;
  //final TextEditingController _amountController = TextEditingController();


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
      // _filteredProducts = products;
    });
  }
  //
  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if(query.isNotEmpty){
        // Filtra por código
        if (query.length<4){
          _filteredProducts = _allProducts
              .where((p) => p.code.toLowerCase() == query)
              .toList();
        }//Filtra por nombre
        else if(query.length>=4){
          _filteredProducts = _allProducts
              .where((p) => p.name.toLowerCase().contains(query))
              .toList();
        }
      }
    });
  }
  // Aumenta la cantidad seleccionada
  void _increaseQuantity(ProductModel product) {
    setState(() {
      _quantities[product.productId] = (_quantities[product.productId] ?? 0) + 1;
      // Limpiar el texto de la barra de busquda
      _searchController.clear();
      //Quitar la lista de productos filtrados
      _filteredProducts = [];
      _updateSelectedProducts();
    });
  }
// Disminuye la cantidad seleccionada
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
// Actualiza la lista de productos seleccionados con la cantidad seleccionada
  void _updateSelectedProducts() {
    _selectedProducts = _allProducts
        .where((p) => (_quantities[p.productId] ?? 0) > 0)
        .toList();
  }
// COnfirma el pedido
  void _confirmProducts() { //1=compra, 2=credito 3=pedido
    //
    if (_selectedProducts.isEmpty) {
      return;
    }
    // Aquí puedes navegar o devolver los productos seleccionados
    Navigator.pop(context, _selectedProducts);
  }

  // Confirma el credito
  void _confirmCredit() { //1=compra, 2=credito 3=pedido
    //
    if (_selectedProducts.isEmpty) {
      return;
    }
    // Dialogo de confirmación
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Productos a crédito'),
        content: Text(
          '¿Deseas registrar un crédito por \$${_totalPrice} '
              'a ${widget.clientName}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {

              //await _savePayment();

              if (context.mounted) {
                Navigator.of(context).pop(); // cerrar diálogo
                Navigator.of(context).pop(true);
              }
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
    // Aquí puedes navegar o devolver los productos seleccionados
    Navigator.pop(context, _selectedProducts);
  }

  // Función para calcular el valor total del carrito
  double _calculateTotal() {
    double total = 0.0;
    for (var product in _selectedProducts) {
      final quantity = _quantities[product.productId] ?? 0;
      total += product.unitPrice * quantity;
      _totalPrice = total;
    }
    return total;
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
              /*
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
              ),*/
              // LISTA DE PRODUCTOS SELECCIONADOS
              FutureBuilder<List<ProductModel>>(
                future: ProductDao().getProducts(),
                builder: (context, snapshot) {

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _selectedProducts.length,
                    itemBuilder: (context, index) {
                      final product = _selectedProducts[index];
                      final quantity = _quantities[product.productId] ?? 0;

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(product.name),
                          subtitle: Text(
                            "${product.unitMeasure}    \$${product.unitPrice}",
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
                                style: AppTextStyles.subtitle,
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
            ],

            const SizedBox(height: 20),

            // LISTA DE PRODUCTOS FILTRADOS
            FutureBuilder<List<ProductModel>>(
              future: ProductDao().getProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Text('Error al cargar productos');
                }/* Mensaje cuando la barra de busqueda no tiene texto
                if (_filteredProducts.isEmpty) {
                  return const Text('No se encontraron productos');
                }*/

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
                          "${product.unitMeasure}    \$${product.unitPrice}",
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
                              style: AppTextStyles.subtitle,
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

            // Muestra el valor total de los productos seleccionados
            if (_selectedProducts.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.end, // Alinea el contenido a la derecha
                children: [
                  Text(
                    'Total:',
                    style: AppTextStyles.subtitle,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '\$${_calculateTotal().toStringAsFixed(2)}', // Llama a la función de cálculo
                    style: AppTextStyles.subtitle,
                  ),
                ],
              ),
              const SizedBox(height: 20), // Espacio antes del botón principal
            ],


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
