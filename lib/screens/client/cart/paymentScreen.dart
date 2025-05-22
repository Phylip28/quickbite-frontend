import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../auth/auth.dart';
import 'shoppingCart.dart';
import '../models/cartItemModel.dart'; // <--- IMPORTANTE: Añade esta línea
import '../homeScreen.dart';
import '../orders/orders.dart';
import '../account/profile.dart';
import '../customBottomNavigationBar.dart';
import './paymentSuccesfull.dart';

// Definición del Enum PaymentMethod
enum PaymentMethod {
  cash,
  visa,
  mastercard,
  // Agrega otros métodos si los necesitas
}

const Color primaryColor = Color(0xFFf05000);
const String yourApiBaseUrl = "http://192.168.246.36:8000"; // Tu URL base
const int genericRestaurantIdForMvp = 1;

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentMethod? _selectedPaymentMethod = PaymentMethod.cash;
  final int _selectedIndex = 0;

  String _userAddress = "Loading address...";
  String _userName = "";
  int? _userId;
  bool _isPlacingOrder = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final address = await getUserAddress();
    final name = await getUserName();
    final id = await getUserId();
    if (mounted) {
      setState(() {
        _userAddress = address ?? "Not available";
        _userName = name ?? "Customer";
        _userId = id;
      });
    }
  }

  Future<bool> _placeOrderOnBackend() async {
    if (_userId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User information not loaded. Cannot place order.')),
        );
      }
      return false;
    }

    if (globalCartItems.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Your cart is empty.')));
      }
      return false;
    }

    // --- OBTENER EL TOKEN DE ACCESO ---
    final String? accessToken = await getAuthToken();
    if (accessToken == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication token not found. Please log in again.')),
        );
      }
      return false;
    }
    // --- FIN DE OBTENER TOKEN ---

    final url = Uri.parse('$yourApiBaseUrl/api/orders/'); // Asegúrate que la URL base sea correcta
    final headers = {"Content-Type": "application/json", "Authorization": "Bearer $accessToken"};

    // --- CONSTRUIR LA LISTA DE ITEMS PARA EL PAYLOAD ---
    List<Map<String, dynamic>> itemsList =
        globalCartItems.map((CartItemModel cartItem) {
          // Asegúrate que CartItemModel y ProductModel (dentro de cartItem.product)
          // tengan los campos 'name' y 'price'
          return {
            "nombre_producto":
                cartItem.product.name, // Coincide con OrderItemCreate.nombre_producto
            "cantidad": cartItem.quantity, // Coincide con OrderItemCreate.cantidad
            "precio_unitario":
                cartItem.product.price, // Coincide con OrderItemCreate.precio_unitario
          };
        }).toList();
    // --- FIN DE CONSTRUIR LISTA DE ITEMS ---

    final orderPayload = {
      "id_cliente": _userId,
      "id_restaurante": genericRestaurantIdForMvp, // ID de restaurante genérico
      "total_pedido": globalCartItems.fold(
        0.0,
        (sum, CartItemModel item) => sum + (item.product.price * item.quantity),
      ),
      "metodo_pago": _selectedPaymentMethod.toString().split('.').last,
      "direccion_entrega": _userAddress,
      "items": itemsList, // <--- USA LA LISTA DE ITEMS AQUÍ
      // "items_descripcion_json": itemsJsonString, // YA NO SE USA ESTA LÍNEA
    };

    try {
      // Imprime el payload que se va a enviar para depuración
      print("Sending order payload: ${json.encode(orderPayload)}");
      print("With headers: $headers");

      final response = await http.post(url, headers: headers, body: json.encode(orderPayload));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        // HTTP 201 Created es común para creación exitosa
        if (mounted) {
          globalCartItems.clear(); // Limpia el carrito global
          // Considera actualizar el estado del carrito en otras pantallas si es necesario
          Navigator.pushReplacement(
            // Usa pushReplacement para no volver a esta pantalla con back
            context,
            MaterialPageRoute(builder: (context) => const PaymentSuccessfulScreen()),
          );
        }
        return true;
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to place order. Status: ${response.statusCode}, Body: ${response.body}',
              ),
            ),
          );
        }
        return false;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error placing order: $e')));
      }
      return false;
    }
  }

  void _finishOrder() async {
    if (_selectedPaymentMethod == null) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please select a payment method.')));
      }
      return;
    }
    if (_isPlacingOrder) return;

    if (mounted) {
      setState(() {
        _isPlacingOrder = true;
      });
    }

    bool orderPlacedSuccessfully = await _placeOrderOnBackend();

    if (orderPlacedSuccessfully) {
      globalCartItems.clear();
      if (shoppingCartScreenKey.currentState != null &&
          shoppingCartScreenKey.currentState!.mounted) {
        shoppingCartScreenKey.currentState!.setState(() {});
      }
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const PaymentSuccessfulScreen()),
          (Route<dynamic> route) => false,
        );
      }
    }

    if (mounted) {
      setState(() {
        _isPlacingOrder = false;
      });
    }
  }

  void _onTabTapped(int index) {
    if (index == _selectedIndex) return;
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ShoppingCartScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OrdersScreen()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileClient()),
        );
        break;
    }
  }

  Widget _buildPaymentOption({
    required String title,
    required String subtitle,
    required String iconAsset,
    required PaymentMethod value, // Ahora está definido
    bool isIconAsset = true,
  }) {
    return Card(
      elevation: 1,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: RadioListTile<PaymentMethod>(
        // Ahora está definido
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        value: value,
        groupValue: _selectedPaymentMethod,
        onChanged: (PaymentMethod? newValue) {
          // Ahora está definido
          setState(() {
            _selectedPaymentMethod = newValue;
          });
        },
        secondary:
            isIconAsset
                ? Image.asset(
                  iconAsset,
                  width: 30,
                  height: 30,
                  errorBuilder:
                      (context, error, stackTrace) => const Icon(Icons.credit_card, size: 30),
                )
                : Icon(Icons.local_atm, color: primaryColor.withOpacity(0.7), size: 30),
        activeColor: primaryColor,
        controlAffinity: ListTileControlAffinity.trailing,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/fondoSemiTransparente.png', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: primaryColor,
                            size: 20,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Confirm Payment',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Delivery address',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Card(
                          elevation: 2,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.person_outline,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _userName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _userAddress,
                                        style: const TextStyle(fontSize: 14, color: Colors.black54),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Payment',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildPaymentOption(
                          title: 'Visa',
                          subtitle: 'Enter information on the card',
                          iconAsset: 'assets/logos/visa.png',
                          value: PaymentMethod.visa,
                        ),
                        _buildPaymentOption(
                          title: 'MasterCard',
                          subtitle: 'Enter information on the card',
                          iconAsset: 'assets/logos/masterCard.png',
                          value: PaymentMethod.mastercard,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Center(
                            child: Text(
                              '- or -',
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ),
                        ),
                        _buildPaymentOption(
                          title: 'Cash on delivery',
                          subtitle: 'Pay when your order arrives',
                          iconAsset: '',
                          value: PaymentMethod.cash,
                          isIconAsset: false,
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _isPlacingOrder ? null : _finishOrder,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: primaryColor,
                        side: const BorderSide(color: primaryColor, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      child:
                          _isPlacingOrder
                              ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                                ),
                              )
                              : const Text('Finish order'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTabChanged: _onTabTapped,
        backgroundColor: Colors.white.withOpacity(0.95),
      ),
    );
  }
}
