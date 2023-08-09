import 'package:flutter/material.dart';

import '../contacts/request_dto/request_dto.dart';

class RequestList extends StatelessWidget {
  const RequestList({
    super.key,
    required this.requests,
  });

  final List<RequestDto> requests;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
