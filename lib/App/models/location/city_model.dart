class CitiesResponseModel {
  final List<String> data;

  const CitiesResponseModel({required this.data});

  factory CitiesResponseModel.fromJson(Map<String, dynamic> json) {
    final list = (json['data'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList();
    return CitiesResponseModel(data: list);
  }
}
