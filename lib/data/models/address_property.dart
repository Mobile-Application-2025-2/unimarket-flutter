class AddressProperty {
  String direccion;
  String edificio;
  String local;
  String piso;
  String salon;

  AddressProperty({
    required this.direccion,
    required this.edificio,
    required this.local,
    required this.piso,
    required this.salon,
  });

  Map<String, dynamic> toMap() {
    return {
      'direccion': direccion,
      'edificio': edificio,
      'local': local,
      'piso': piso,
      'salon': salon,
    };
  }
}
