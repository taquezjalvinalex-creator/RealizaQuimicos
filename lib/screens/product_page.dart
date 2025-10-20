import 'package:flutter/material.dart';
import 'package:proyecto_uno/style/styles.dart'; //  importar estilos
import '../widgets/app_drawer.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

/*
  void _abrirFormulario(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final TextEditingController montoController = TextEditingController();

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 20,
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Selecciona productos", style: AppTextStyles.title),
                  const SizedBox(height: 10),

                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _productos.length,
                    itemBuilder: (context, index) {
                      final producto = _productos[index];
                      return ListTile(
                        title: Text(producto["nombre"], style: AppTextStyles.subtitle),
                        subtitle: Text("\$${producto["precio"]}", style: AppTextStyles.subtitle),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline, color: AppColors.dangerColor),
                              onPressed: () {
                                if (producto["cantidad"] > 0) {
                                  setModalState(() {
                                    producto["cantidad"]--;
                                  });
                                }
                              },
                            ),
                            Text("${producto["cantidad"]}", style: AppTextStyles.title),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                              onPressed: () {
                                setModalState(() {
                                  producto["cantidad"]++;
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),
                  TextField(
                    controller: montoController,
                    keyboardType: TextInputType.number,
                    decoration: AppInputStyles.inputDecoration("Monto a cancelar"),
                  ),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: AppButtonStyles.outlinedButton,
                        child: Text("Cancelar", style: AppButtonStyles.buttonTextStyle),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final monto = double.tryParse(montoController.text) ?? 0;
                          final total = _productos.fold(0.0, (sum, item) =>
                          sum + (item["precio"] * item["cantidad"]));

                          debugPrint("Monto digitado: $monto");
                          debugPrint("Total calculado: $total");

                          if (monto < total) {     if (monto < total) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("El monto es menor al total de la compra")),
                            );
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        style: AppButtonStyles.primaryButton,
                        child: Text("Guardar", style: AppButtonStyles.buttonTextStyle),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
                ],
              );
            },
          ),
        );
      },
    );
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Clientes"),
        centerTitle: true,
      ),

      drawer: const AppDrawer(), // 👈 aquí heredas el widget del menú

    );
  }
}
