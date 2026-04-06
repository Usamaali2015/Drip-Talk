import 'package:drip_talk/core/services/storage/secure_storage.dart';

class ProductPreferencesRepository {
  ProductPreferencesRepository(this._secureStorage);

  final SecureStorage _secureStorage;

  static const String _sizePreferencePrefix = 'product_selected_size_';

  Future<int?> getSelectedSizeId(int productId) async {
    final value = await _secureStorage.readString(
      _keyForProductSize(productId),
    );
    return int.tryParse(value ?? '');
  }

  Future<void> saveSelectedSizeId({
    required int productId,
    required int sizeId,
  }) {
    return _secureStorage.writeString(
      _keyForProductSize(productId),
      sizeId.toString(),
    );
  }

  String _keyForProductSize(int productId) {
    return '$_sizePreferencePrefix$productId';
  }
}
