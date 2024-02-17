import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../welcome/login/contracts/user_roles.dart';
import '../components/request_data_provider.dart';
import '../contacts/request_statuses.dart';
import '../repositories/request_repository.dart';
import 'request_screen.dart';

class RequestWrapper extends StatefulWidget {
  const RequestWrapper({
    super.key,
    required this.role,
  });

  final int role;

  @override
  State<RequestWrapper> createState() => _RequestWrapperState();
}

class _RequestWrapperState extends State<RequestWrapper> {
  @override
  Widget build(BuildContext context) {
    final statuses = widget.role == UserRoles.driver
        ? RequestStatuses.relatedStatuses[RequestStatuses.InProgress]
        : RequestStatuses.relatedStatuses[RequestStatuses.New];
    return ChangeNotifierProvider<RequestDataProvider>(
      create: (context) => RequestDataProvider(
        statuses!,
        requestRepository: RequestRepositoryImpl(),
      ),
      child: RequestScreen(role: widget.role),
    );
  }
}
