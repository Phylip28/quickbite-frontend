class ProductModel {
  final String
  id; // Un identificador único para el producto en el frontend (ej. generado por UUID o un contador)
  final String name; // Nombre del producto
  final double price; // Precio unitario del producto
  // No incluimos restaurantId aquí para el MVP simplificado,
  // ya que se manejará a nivel de pedido con genericRestaurantIdForMvp o por el backend.

  ProductModel({required this.id, required this.name, required this.price});

  // Opcional: Si necesitas convertir este modelo a JSON para uso local (no para el payload de pedido simplificado)
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'price': price};
  }

  // Opcional: Si necesitas crear una instancia desde un JSON (ej. si los productos vinieran de alguna fuente)
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }
}
