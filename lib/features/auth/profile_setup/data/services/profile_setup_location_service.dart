import 'package:drip_talk/features/auth/profile_setup/domain/models/profile_setup_selection_option.dart';
import 'package:uni_country_city_picker/uni_country_city_picker.dart';

class ProfileSetupLocationService {
  ProfileSetupLocationService._();

  static final ProfileSetupLocationService instance =
      ProfileSetupLocationService._();

  final UniCountryServices _uniCountryServices = UniCountryServices.instance;

  List<Country>? _countries;
  Future<void>? _loadFuture;

  bool get hasCachedData => (_countries?.isNotEmpty ?? false);

  Future<void> ensureLoaded() {
    return _loadFuture ??= _loadCountries();
  }

  List<ProfileSetupOption> countryOptions({required bool isArabic}) {
    final countries = _countries ?? const <Country>[];
    return countries
        .map(
          (country) => ProfileSetupOption(
            value: country.nameEn.trim(),
            label:
                '${country.flag} ${isArabic ? country.name.trim() : country.nameEn.trim()}',
          ),
        )
        .toList(growable: false);
  }

  List<ProfileSetupOption> cityOptions({
    required String countryValue,
    required bool isArabic,
  }) {
    final countries = _countries ?? const <Country>[];
    Country? selectedCountry;

    for (final country in countries) {
      if (_matches(country.nameEn, countryValue) ||
          _matches(country.name, countryValue)) {
        selectedCountry = country;
        break;
      }
    }

    if (selectedCountry == null) {
      return const <ProfileSetupOption>[];
    }

    return selectedCountry.cities
        .map(
          (city) => ProfileSetupOption(
            value: city.nameEn.trim(),
            label: isArabic ? city.name.trim() : city.nameEn.trim(),
          ),
        )
        .toList(growable: false);
  }

  Future<void> _loadCountries() async {
    final countries = await _uniCountryServices.getCountriesAndCities();
    countries.sort((left, right) => left.nameEn.compareTo(right.nameEn));
    _countries = countries;
  }

  bool _matches(String left, String right) {
    return left.trim().toLowerCase() == right.trim().toLowerCase();
  }
}
