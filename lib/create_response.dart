class CreateResponse {
  final bool success;

  CreateResponse({required this.success});

  factory CreateResponse.fromJson(Map<String, dynamic> json) {
    return CreateResponse(success: json['success']);
  }
}
