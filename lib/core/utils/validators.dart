/// Validadores de formulario para Turnia App.
///
/// Cada función recibe un [String?] y devuelve [String?] con el mensaje de
/// error cuando el valor no es válido, o `null` cuando supera la validación.
/// Este es el patrón estándar para usar en el `validator` de un
/// [TextFormField] de Flutter.

library;

/// Valida que el nombre sea obligatorio y tenga entre 2 y 50 caracteres.
String? validateName(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'El nombre es obligatorio';
  }
  final trimmed = value.trim();
  if (trimmed.length < 2 || trimmed.length > 50) {
    return 'El nombre debe tener entre 2 y 50 caracteres';
  }
  return null;
}

/// Valida el email con una expresión regular estricta.
String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'El email es obligatorio';
  }
  final emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$',
  );
  if (!emailRegex.hasMatch(value.trim())) {
    return 'El email no tiene formato válido';
  }
  return null;
}

/// Valida la contraseña: mínimo 8 caracteres y al menos 1 dígito.
String? validatePassword(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'La contraseña es obligatoria';
  }
  final trimmed = value.trim();
  if (trimmed.length < 8) {
    return 'La contraseña debe tener al menos 8 caracteres';
  }
  if (!RegExp(r'\d').hasMatch(trimmed)) {
    return 'La contraseña debe contener al menos un dígito';
  }
  return null;
}

/// Valida el teléfono: obligatorio y numérico positivo.
String? validatePhone(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'El teléfono es obligatorio';
  }
  final trimmed = value.trim();
  // Solo dígitos y que represente un número mayor a cero (no empieza en 0).
  if (!RegExp(r'^[1-9][0-9]*$').hasMatch(trimmed)) {
    return 'El teléfono debe ser numérico y positivo';
  }
  return null;
}

/// Valida el precio: obligatorio y numérico positivo.
String? validatePrice(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'El precio es obligatorio';
  }
  final trimmed = value.trim();
  final precio = double.tryParse(trimmed);
  if (precio == null || precio <= 0) {
    return 'El precio debe ser numérico y positivo';
  }
  return null;
}