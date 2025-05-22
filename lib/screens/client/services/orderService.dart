import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/orderModel.dart'; // Asegúrate que la ruta sea correcta
import '../../../auth/auth.dart'; // Para getAuthToken y getUserId

// DEFINE TU URL BASE AQUÍ
const String yourApiBaseUrl = 'http://192.168.1.7:8000'; // REEMPLAZA CON TU URL REAL

class OrderService {
  Future<List<Order>> getOrdersByClientId() async {
    final String? token = await getAuthToken();
    // CORRECCIÓN PARA userId:
    final int? userIdInt = await getUserId();

    if (token == null) {
      throw Exception('User not authenticated: Token not found');
    }
    if (userIdInt == null) {
      throw Exception('User ID not found');
    }
    final String userId = userIdInt.toString(); // Convertir int a String

    final url = Uri.parse('$yourApiBaseUrl/api/orders/client/$userId');

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Order> orders = body.map((dynamic item) => Order.fromJson(item)).toList();
        return orders;
      } else if (response.statusCode == 404) {
        print('No orders found for client $userId.');
        return [];
      } else {
        print('Failed to load orders. Status: ${response.statusCode}, Body: ${response.body}');
        throw Exception('Failed to load orders (Status: ${response.statusCode})');
      }
    } catch (e) {
      print('Error fetching orders: $e');
      throw Exception('Error fetching orders: $e');
    }
  }
}
