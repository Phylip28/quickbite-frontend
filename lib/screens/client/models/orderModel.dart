class OrderItem {
  final int id;
  final String nombreProducto;
  final int cantidad;
  final double precioUnitario;
  final int orderId;

  OrderItem({
    required this.id,
    required this.nombreProducto,
    required this.cantidad,
    required this.precioUnitario,
    required this.orderId,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as int,
      nombreProducto: json['nombre_producto'] as String,
      cantidad: json['cantidad'] as int,
      precioUnitario: (json['precio_unitario'] as num).toDouble(),
      orderId: json['order_id'] as int,
    );
  }
}

class Order {
  final int idCliente;
  final int idRestaurante;
  final double totalPedido;
  final String metodoPago;
  final String direccionEntrega;
  final int idPedido;
  final DateTime fechaPedido;
  final String estadoPedido;
  final int? idRepartidor;
  final List<OrderItem> items;

  Order({
    required this.idCliente,
    required this.idRestaurante,
    required this.totalPedido,
    required this.metodoPago,
    required this.direccionEntrega,
    required this.idPedido,
    required this.fechaPedido,
    required this.estadoPedido,
    this.idRepartidor,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List;
    List<OrderItem> orderItems = itemsList.map((i) => OrderItem.fromJson(i)).toList();

    return Order(
      idCliente: json['id_cliente'] as int,
      idRestaurante: json['id_restaurante'] as int,
      totalPedido: (json['total_pedido'] as num).toDouble(),
      metodoPago: json['metodo_pago'] as String,
      direccionEntrega: json['direccion_entrega'] as String,
      idPedido: json['id_pedido'] as int,
      fechaPedido: DateTime.parse(json['fecha_pedido'] as String),
      estadoPedido: json['estado_pedido'] as String,
      idRepartidor: json['id_repartidor'] as int?,
      items: orderItems,
    );
  }
}
