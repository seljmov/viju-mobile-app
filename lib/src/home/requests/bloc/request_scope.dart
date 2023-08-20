import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../contacts/request_cancel_dto/request_cancel_dto.dart';
import '../contacts/request_create_dto/request_create_dto.dart';
import 'request_bloc.dart';

/// Скоп для блока заявок
abstract class RequestScope {
  static RequestBloc of(BuildContext context) {
    return BlocProvider.of<RequestBloc>(context);
  }

  static void load(BuildContext context, int status) {
    of(context).add(RequestEvent.load(status: status));
  }

  static void openAddRequestPage(BuildContext context) {
    of(context).add(const RequestEvent.openAddRequestPage());
  }

  static void createRequest(
      BuildContext context, RequestCreateDto createDto, List<File?> images) {
    of(context).add(
      RequestEvent.createRequest(createDto: createDto, images: images),
    );
  }

  static void cancelRequest(BuildContext context, RequestCancelDto cancelDto) {
    of(context).add(RequestEvent.cancelRequest(cancelDto: cancelDto));
  }
}
