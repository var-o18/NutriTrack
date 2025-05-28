class RegistroModel {
  String? _nombre;
  String? _apellidos;
  String? _correo;
  String? _contrasena;
  String? _sexo;
  int? _edad;
  double? _peso;
  double? _altura;
  String? _objetivoPersonal;
  String? _nivelActividadFisica;
  int? _caloriasDiarias;

  RegistroModel();

  // Getters
  String? get nombre => _nombre;
  String? get apellidos => _apellidos;
  String? get correo => _correo;
  String? get contrasena => _contrasena;
  String? get sexo => _sexo;
  int? get edad => _edad;
  double? get peso => _peso;
  double? get altura => _altura;
  String? get objetivoPersonal => _objetivoPersonal;
  String? get nivelActividadFisica => _nivelActividadFisica;
  int? get caloriasDiarias => _caloriasDiarias;

  // Setters
  set nombre(String? value) => _nombre = value;
  set apellidos(String? value) => _apellidos = value;
  set correo(String? value) => _correo = value;
  set contrasena(String? value) => _contrasena = value;
  set sexo(String? value) => _sexo = value;
  set edad(int? value) => _edad = value;
  set peso(double? value) => _peso = value;
  set altura(double? value) => _altura = value;
  set objetivoPersonal(String? value) => _objetivoPersonal = value;
  set nivelActividadFisica(String? value) => _nivelActividadFisica = value;
  set caloriasDiarias(int? value) => _caloriasDiarias = value;

  Map<String, dynamic> toJson() {
    return {
      'nombre': _nombre,
      'apellidos': _apellidos,
      'correo': _correo,
      'contrasena': _contrasena,
      'sexo': _sexo,
      'edad': _edad,
      'peso': _peso,
      'altura': _altura,
      'objetivoPersonal': _objetivoPersonal,
      'nivelActividadFisica': _nivelActividadFisica,
      'caloriasDiarias': _caloriasDiarias,
    };
  }

  factory RegistroModel.fromJson(Map<String, dynamic> json) {
    return RegistroModel()
      ..nombre = json['nombre']
      ..apellidos = json['apellidos']
      ..correo = json['correo']
      ..contrasena = json['contrasena']
      ..sexo = json['sexo']
      ..edad = json['edad']
      ..peso = (json['peso'] as num?)?.toDouble()
      ..altura = (json['altura'] as num?)?.toDouble()
      ..objetivoPersonal = json['objetivoPersonal']
      ..nivelActividadFisica = json['nivelActividadFisica']
      ..caloriasDiarias = json['caloriasDiarias'];
  }
}
