import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'request_bloc.dart';

/// Скоп для блока заявок
abstract class RequestScope {
  static RequestBloc of(BuildContext context) {
    return BlocProvider.of<RequestBloc>(context);
  }

  static void load(BuildContext context, int status) {
    of(context).add(RequestEvent.load(status: status));
  }
}
