import 'package:flutter/material.dart';

import '../contacts/request_statuses.dart';

/// Карточка состояния заявок
class RequestStateCard extends StatelessWidget {
  const RequestStateCard({
    super.key,
    required this.statusName,
  });

  final String statusName;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: RequestStatuses.getStatusColor[statusName],
        borderRadius: BorderRadius.circular(100),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Text(
          statusName,
          style: TextStyle(
            color: statusName == RequestStatuses.statusName(RequestStatuses.New)
                ? const Color(0xFF1E1E1E)
                : Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
