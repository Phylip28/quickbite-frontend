class ProductModel {
  final String id;
  final String name;
  final double price;
  final String imageUrl; // NUEVO CAMPO PARA LA URL DE LA IMAGEN

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl, // AÑADIR AL CONSTRUCTOR
  });

  // Opcional: Si necesitas convertir este modelo a JSON para uso local
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl, // AÑADIR A ToJSON SI LO USAS
    };
  }

  // Opcional: Si necesitas crear una instancia desde un JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id_producto'] as String, // Asumiendo que el JSON del backend usa 'id_producto'
      name: json['nombre_producto'] as String, // Asumiendo 'nombre_producto'
      price: (json['precio_producto'] as num).toDouble(), // Asumiendo 'precio_producto'
      imageUrl:
          json['imagen_url']
              as String, // AÑADIR PARSEO DESDE JSON (ajusta 'imagen_url' al nombre real del campo en tu API)
    );
  }
}
