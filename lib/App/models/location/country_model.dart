class CountryModel {
  final String name;
  final String code;

  const CountryModel({required this.name, required this.code});

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }
}

class CountriesResponseModel {
  final List<CountryModel> data;

  const CountriesResponseModel({required this.data});

  factory CountriesResponseModel.fromJson(Map<String, dynamic> json) {
    final list = (json['data'] as List<dynamic>? ?? [])
        .map((e) => CountryModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return CountriesResponseModel(data: list);
  }
}
