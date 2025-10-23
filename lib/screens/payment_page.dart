import 'package:flutter/material.dart';
import 'package:proyecto_uno/controllers/product_dao.dart';
import 'package:proyecto_uno/controllers/sale_dao.dart';
import 'package:proyecto_uno/models/item_model.dart';
import 'package:proyecto_uno/models/product_model.dart';
import '../../style/styles.dart';
import '../controllers/payment_dao.dart';
import '../models/payment_model.dart';
import '../models/sale_model.dart';
import 'package:intl/intl.dart'; //Formato de fecha

class PaymentPage extends StatefulWidget {
  final int? clientId; // ID del cliente para registrar la compra
  final String? clientName;
  final Map<int, int> quantities;
  final List<ProductModel> selectedProducts;

  const PaymentPage({
    super.key,
    required this.clientId,
    required this.clientName,
    required this.quantities,
    required this.selectedProducts,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  // Declara las variables de estado que necesitas
  late final int _clientId; // 'late final' porque se inicializará en initState y no cambiará
  late final String _clientName;
  late Map<int, int> _quantities = {};
  late List<ProductModel> _selectedProducts = [];

  final TextEditingController _observationController = TextEditingController();
  int _selectedOption = 1; // opción por defecto
  final saleDao = SaleDao();
  final _paymentDao = PaymentDao();
  final TextEditingController _searchController = TextEditingController();
  double _totalPrice = 0.0;

    //TAREAS DE INICILIZACIÓN
    @override
    void initState() {
      super.initState();

      _clientId = widget.clientId!;
      _clientName = widget.clientName!;
      _quantities = widget.quantities;
      _selectedProducts = widget.selectedProducts;
    }


    // Confirma el pago
    void _confirmSale() {
      if (_selectedProducts.isEmpty) {
        return;
      }
      // Dialogo de confirmación
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Pagar'),
          content: Text(
            '¿Deseas registrar un pago por \$$_totalPrice '
                'a $_clientName',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _saveSale();
                // ✅ 3. Cierra el diálogo y el BottomSheet en la secuencia correcta.
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop(); // Primero, cierra el diálogo.
                  //Navigator.of(context).pop(true);
                }
                if (mounted) {
                  Navigator.of(context).pop(true); // Segundo, cierra el BottomSheet.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Venta registrada correctamente.'),
                      backgroundColor: Colors.green, // Un color más apropiado para éxito
                    ),
                  );
                }

              },
              child: const Text('Confirmar'),
            ),
          ],
        ),
      );
    }
    //Guardar
    Future<void> _saveSale() async{
      final String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      List<ItemModel> items = _itemsModel();
      //INSERTAR VENTA
      SaleModel saleModel = await saleDao.insertSale(
        clientId: _clientId,
        paymentType: 1,
        status: 'PAGADO',
        totalPrice: _totalPrice,
        totalSurcharge: 0.0,
        orderId: null,
        items: items,
      );

      // Crea el objeto PaymentModel
      final newPayment = PaymentModel(
        paymentId: null,
        creditId: null,
        saleId: saleModel.saleId,
        sellerId: saleModel.sellerId,
        remaining: 0,
        amount: _totalPrice,
        observation: _observationController.text,
        methodId: 1,
        receipt: null, // De momento no tienes la foto, se deja en null
        paymentDate: formattedDate, // Guarda la fecha y hora actual
      );

      // Usa el DAO para insertar en la base de datos
      await _paymentDao.insertPayment(
          payment: newPayment,
          clientId: _clientId,
          //routeId: 1
      );
    }
    //CREAR LISTA DE ITEM_MODEL
    List<ItemModel> _itemsModel() {
      // Si no hay productos seleccionados, devuelve una lista vacía.
      if (_selectedProducts.isEmpty) {
        return [];
      }

      return _selectedProducts.map((product) {
        // Obtiene la cantidad para el producto actual.
        final int quantity = _quantities[product.productId] ?? 0;

        // Crea y devuelve un objeto ItemModel para este producto.
        return ItemModel(
          itemId: null, // Autoincremental en la DB
          saleId: null, // Se asignará después de crear la venta
          productId: product.productId,
          quantity: quantity,
          unitPrice: product.unitPrice,
          surcharge: product.surcharge,
          totalPrice: product.unitPrice * quantity,
          totalSurcharge: product.surcharge * quantity,
        );
      }).toList(); // Convierte el resultado de .map en una List<ItemModel>
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

    //LIBERAR TAREAS Y PROCESOS ANTES DE ABANDONAR EL WIDGET
    @override
    void dispose() {
    _searchController.dispose();
    super.dispose();
    }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // ESPERAMOS EL RESULTADO DE LA CONSULTA PARA OBTENER EL NOMBRE DE LA RUTA
        title: const Text("Pago"),
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

        body: Column(
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

            // LISTA DE PRODUCTOS SELECCIONADOS
            if (_selectedProducts.isNotEmpty) ...[

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
                              Text(
                                quantity.toString(),
                                style: AppTextStyles.subtitle,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],//Fin de lista

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
            // Opciones de medio de pago
            const Text(
              'Medio de pago:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Column(
              children: [
                RadioListTile<int>(
                  title: const Text('Efectivo'),
                  value: 1,
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    setState(() => _selectedOption = value!);
                  },
                ),
                RadioListTile<int>(
                  title: const Text('Transferencia'),
                  value: 2,
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    setState(() => _selectedOption = value!);
                  },
                ),
                RadioListTile<int>(
                  title: const Text('Efectivo y transferencia'),
                  value: 3,
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    setState(() => _selectedOption = value!);
                  },
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Botones adicionales
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Aquí puedes abrir la cámara o galería
                  },
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Comprobante'),
                  style: AppButtonStyles.iconButton2,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Mostrar QR (por ejemplo, con showDialog o Image.asset)
                  },
                  icon: const Icon(Icons.qr_code),
                  label: const Text('Ver QR'),
                  style: AppButtonStyles.iconButton1,
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              'Observaciones:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Campo de Observaciones
            TextField(
              controller: _observationController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Agregar observaciones',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // BOTONES PRINCIPALES
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: AppButtonStyles.secondaryButton,
                    onPressed: () => Navigator.of(context).pop(), //Cancelar pago
                    child: const Text("Cancelar"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: AppButtonStyles.primaryButton,
                    onPressed: _confirmSale,
                    child: const Text("Pagar"),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
  }
}