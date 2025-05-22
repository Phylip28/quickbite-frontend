import 'productModel.dart'; // Asegúrate que la ruta a ProductModel sea correcta

class CartItemModel {
  final ProductModel product; // Aquí está la propiedad 'product' que se espera
  int quantity;

  CartItemModel({required this.product, required this.quantity});

  // Métodos útiles (opcionales pero recomendados)
  double get subtotal => product.price * quantity;

  void incrementQuantity() {
    quantity++;
  }

  void decrementQuantity() {
    if (quantity > 1) {
      // O > 0 si quieres permitir 0 y luego eliminarlo
      quantity--;
    }
  }
}
