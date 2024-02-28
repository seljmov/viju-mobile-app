import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:collection/collection.dart';

import '../../../../../core/constants/assets_constants.dart';
import '../../../../../core/helpers/message_helper.dart';
import '../../../../../core/models/multi_image.dart';
import '../../../../../core/widgets/button/thesis_button.dart';
import '../../../../../core/widgets/thesis_drop_down_button.dart';
import '../../../../../core/widgets/thesis_sliver_screen.dart';
import '../../../../../core/widgets/thesis_split_screen.dart';
import '../../../../../theme/theme_colors.dart';
import '../../../../../theme/theme_constants.dart';
import '../../../../../theme/theme_extention.dart';
import '../../components/request_data_provider.dart';
import '../../contacts/contractor/address_dto/address_dto.dart';
import '../../contacts/contractor/contractor_dto/contractor_dto.dart';
import '../../contacts/contractor/location_dto/location_dto.dart';
import '../../contacts/removal_dto/removal_dto.dart';
import '../../contacts/request_create_dto/request_create_dto.dart';
import '../../contacts/request_detailed_dto/request_detailed_dto.dart';
import '../../contacts/request_edit_dto/request_edit_dto.dart';
import '../../contacts/request_statuses.dart';
import '../../contacts/waste_dto/waste_dto.dart';
import 'widgets/attach_images_grid.dart';

class RequestPutPage extends StatelessWidget {
  const RequestPutPage({
    super.key,
    required this.contractors,
    required this.wastes,
    required this.removals,
    required this.provider,
    this.request,
  });

  final List<ContractorDto> contractors;
  final List<WasteDto> wastes;
  final List<RemovalDto> removals;
  final RequestDataProvider provider;
  final RequestDetailedDto? request;

  String _volumeToString(double? volume) {
    if (volume == null) return '';

    return volume.toString().replaceAll('.0', '');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('request: $request');

    final contractorController = TextEditingController(
      text: request?.contractor,
    );
    final locationController = TextEditingController(
      text: request?.location,
    );
    final addressController = TextEditingController(
      text: request?.locationAddress,
    );

    var existedContractor = contractors.firstWhereOrNull(
      (element) => element.name == contractorController.text,
    );

    debugPrint('existedContractor: $existedContractor');

    final locationsNotifier = ValueNotifier<List<LocationDto>?>(
      existedContractor != null
          ? existedContractor.locations
          : contractors.length == 1
              ? contractors[0].locations
              : null,
    );

    var existedLocation = locationsNotifier.value?.firstWhereOrNull(
      (element) => element.name == locationController.text,
    );

    final addressesNotifier = ValueNotifier<List<AddressDto>?>(
      existedLocation != null
          ? existedLocation.addresses
          : locationsNotifier.value != null &&
                  locationsNotifier.value?.length == 1
              ? locationsNotifier.value![0].addresses
              : null,
    );

    var existedAddress = addressesNotifier.value?.firstWhereOrNull(
      (element) => element.address == addressController.text,
    );

    final wasteController = TextEditingController(text: request?.wasteType);
    final removalController = TextEditingController(
      text: request?.removalType,
    );
    final countMController = TextEditingController(
      text: _volumeToString(request?.volumeInCubicMeters),
    );
    final countTController = TextEditingController(
      text: _volumeToString(request?.volumeInTons),
    );
    final noteController = TextEditingController(text: request?.note);
    final countMFormKey = GlobalKey<FormFieldState>();
    final countTFormKey = GlobalKey<FormFieldState>();
    final imageFilesNotifier = ValueNotifier<List<MultiImage>>([]);

    bool canCreateRequest() {
      return contractorController.text.isNotEmpty &&
          locationController.text.isNotEmpty &&
          addressController.text.isNotEmpty &&
          wasteController.text.isNotEmpty &&
          removalController.text.isNotEmpty;
    }

    final canCreateRequestNotifier = ValueNotifier<bool>(canCreateRequest());

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: ThesisSplitScreen(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: ThesisSliverScreen(
                title: request == null
                    ? 'Создание заявки'
                    : 'Редактирование заявки',
                leading: IconButton(
                  icon: SvgPicture.asset(AppIcons.close),
                  onPressed: () => Navigator.pop(context),
                ),
                bodyPadding: kThemeDefaultPaddingHorizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Builder(builder: (context) {
                      if (contractors.length == 1) {
                        if (existedAddress == null) {
                          addressController.text = '';
                          addressesNotifier.value = null;
                        }

                        if (existedLocation == null) {
                          locationController.text = '';
                          locationsNotifier.value = null;
                        }

                        contractorController.text = contractors[0].name;
                        locationsNotifier.value = contractors[0].locations;

                        canCreateRequestNotifier.value = canCreateRequest();
                        return const SizedBox.shrink();
                      }

                      return ThesisDropDownButton<ContractorDto>(
                        controller: contractorController,
                        bottomSheepTitle: 'Контрагенты',
                        items: contractors,
                        initialItem: existedContractor,
                        itemBuilder: (item) => Text(
                          item.name,
                          style: context.textTheme.titleLarge,
                        ),
                        onSelected: (item) {
                          existedContractor = item;
                          existedLocation = null;
                          existedAddress = null;
                          addressController.text = '';
                          addressesNotifier.value = null;
                          locationController.text = '';
                          locationsNotifier.value = null;

                          contractorController.text = item.name;

                          locationsNotifier.value = item.locations;
                          if (locationsNotifier.value?.length == 1) {
                            locationController.text =
                                locationsNotifier.value![0].name;
                            addressesNotifier.value =
                                locationsNotifier.value![0].addresses;

                            if (addressesNotifier.value?.length == 1) {
                              addressController.text =
                                  addressesNotifier.value![0].address;
                            }
                          }

                          canCreateRequestNotifier.value = canCreateRequest();
                        },
                        decoration: const InputDecoration(
                          labelText: 'Контрагент',
                          hintText: 'Выберите контрагента',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: Icon(
                            Icons.keyboard_arrow_down,
                            color: kGray1Color,
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 10),
                    ValueListenableBuilder(
                      valueListenable: locationsNotifier,
                      builder: (context, locations, child) {
                        if (locations == null || locations.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        if (locations.length == 1) {
                          if (existedAddress == null) {
                            addressController.text = '';
                            addressesNotifier.value = null;
                          }
                          locationController.text = locations[0].name;
                          addressesNotifier.value = locations[0].addresses;
                          canCreateRequestNotifier.value = canCreateRequest();
                          return const SizedBox.shrink();
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ThesisDropDownButton<LocationDto>(
                            controller: locationController,
                            initialItem: existedLocation ??
                                (locations.length == 1 ? locations[0] : null),
                            bottomSheepTitle: 'Локации',
                            items: locations,
                            itemBuilder: (item) => Text(
                              item.name,
                              style: context.textTheme.titleLarge,
                            ),
                            onSelected: (item) {
                              existedLocation = item;
                              existedAddress = null;
                              addressController.text = '';
                              addressesNotifier.value = null;

                              locationController.text = item.name;

                              addressesNotifier.value = item.addresses;
                              if (addressesNotifier.value?.length == 1) {
                                addressController.text =
                                    addressesNotifier.value![0].address;
                              }

                              canCreateRequestNotifier.value =
                                  canCreateRequest();
                            },
                            decoration: const InputDecoration(
                              labelText: 'Локация',
                              hintText: 'Выберите локацию',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              suffixIcon: Icon(
                                Icons.keyboard_arrow_down,
                                color: kGray1Color,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    ValueListenableBuilder(
                      valueListenable: addressesNotifier,
                      builder: (context, addresses, child) {
                        if (addresses == null || addresses.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        if (addresses.length == 1) {
                          addressController.text = addresses[0].address;
                          canCreateRequestNotifier.value = canCreateRequest();
                          return const SizedBox.shrink();
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ThesisDropDownButton<AddressDto>(
                            controller: addressController,
                            initialItem: existedAddress ??
                                (addresses.length == 1 ? addresses[0] : null),
                            bottomSheepTitle: 'Адреса',
                            items: addresses,
                            itemBuilder: (item) => Text(
                              item.address,
                              style: context.textTheme.titleLarge,
                            ),
                            onSelected: (item) {
                              existedAddress = item;
                              addressController.text = item.address;
                              canCreateRequestNotifier.value =
                                  canCreateRequest();
                            },
                            decoration: const InputDecoration(
                              labelText: 'Адрес',
                              hintText: 'Выберите адрес',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              suffixIcon: Icon(
                                Icons.keyboard_arrow_down,
                                color: kGray1Color,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    ThesisDropDownButton<WasteDto>(
                      controller: wasteController,
                      bottomSheepTitle: 'Тип отхода',
                      items: wastes,
                      itemBuilder: (item) => Text(
                        item.name,
                        style: context.textTheme.titleLarge,
                      ),
                      onSelected: (item) {
                        wasteController.text = item.name;
                        canCreateRequestNotifier.value = canCreateRequest();
                      },
                      decoration: const InputDecoration(
                        labelText: 'Тип отхода',
                        hintText: 'Выберите тип отхода',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: Icon(
                          Icons.keyboard_arrow_down,
                          color: kGray1Color,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ThesisDropDownButton<RemovalDto>(
                      controller: removalController,
                      bottomSheepTitle: 'Тип вывоза',
                      items: removals,
                      itemBuilder: (item) => Text(
                        item.name,
                        style: context.textTheme.titleLarge,
                      ),
                      onSelected: (item) {
                        removalController.text = item.name;
                        canCreateRequestNotifier.value = canCreateRequest();
                      },
                      decoration: const InputDecoration(
                        labelText: 'Тип вывоза',
                        hintText: 'Выберите тип вывоза',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: Icon(
                          Icons.keyboard_arrow_down,
                          color: kGray1Color,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: TextFormField(
                            key: countMFormKey,
                            controller: countMController,
                            style: context.textTheme.titleLarge,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              countMFormKey.currentState?.validate();
                              canCreateRequestNotifier.value =
                                  canCreateRequest();
                            },
                            validator: _doubleValidate,
                            decoration: const InputDecoration(
                              labelText: 'Примерный объем, м³',
                              hintText: '0',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: TextFormField(
                            key: countTFormKey,
                            controller: countTController,
                            style: context.textTheme.titleLarge,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              countTFormKey.currentState?.validate();
                              canCreateRequestNotifier.value =
                                  canCreateRequest();
                            },
                            validator: _doubleValidate,
                            decoration: const InputDecoration(
                              labelText: 'Примерный объем, т',
                              hintText: '0',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: noteController,
                      style: context.textTheme.titleLarge,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Примечание',
                        hintText: 'Введите текст примечания',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    Visibility(
                      visible: request == null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 30),
                          Text(
                            'Фото',
                            textAlign: TextAlign.left,
                            style: context.textTheme.headlineSmall!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Вывод сетки изображений
                          AttachImagesGrid(
                            imagesNotifier: imageFilesNotifier,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            ColoredBox(
              color: context.currentTheme.scaffoldBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(22).copyWith(bottom: 32),
                child: Column(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: canCreateRequestNotifier,
                      builder: (context, canCreate, child) {
                        return ThesisButton.fromText(
                          text: 'Сохранить',
                          isDisabled: !canCreate,
                          onPressed: () async {
                            if (request == null) {
                              final createDto = RequestCreateDto(
                                contractorId: contractors
                                    .firstWhere((element) =>
                                        element.name ==
                                        contractorController.text)
                                    .id,
                                locationAddressId: addressesNotifier.value!
                                    .firstWhere((element) =>
                                        element.address ==
                                        addressController.text)
                                    .id,
                                wasteTypeId: wastes
                                    .firstWhere((element) =>
                                        element.name == wasteController.text)
                                    .id,
                                removalTypeId: removals
                                    .firstWhere((element) =>
                                        element.name == removalController.text)
                                    .id,
                                approximateVolumeInCubicMeters:
                                    double.tryParse(countMController.text),
                                approximateVolumeInTons:
                                    double.tryParse(countTController.text),
                                note: noteController.text,
                              );

                              final images = imageFilesNotifier.value
                                  .map((el) => el.file)
                                  .toList();

                              final result = await provider.createRequest(
                                  createDto, images);
                              MessageHelper.showByStatus(
                                isSuccess: result,
                                successMessage: 'Заявка успешно создана',
                                errorMessage:
                                    'Во время создания заявки что-то пошло не так. Попробуйте снова.',
                              );
                              if (result) {
                                provider.loadRequests([RequestStatuses.New]);
                              }
                              Navigator.pop(context);
                              return;
                            }

                            final editDto = RequestEditDto(
                              id: request!.id,
                              contractorId: contractors
                                  .firstWhere((element) =>
                                      element.name == contractorController.text)
                                  .id,
                              locationAddressId: addressesNotifier.value!
                                  .firstWhere((element) =>
                                      element.address == addressController.text)
                                  .id,
                              wasteTypeId: wastes
                                  .firstWhere((element) =>
                                      element.name == wasteController.text)
                                  .id,
                              removalTypeId: removals
                                  .firstWhere((element) =>
                                      element.name == removalController.text)
                                  .id,
                              approximateVolumeInCubicMeters:
                                  double.tryParse(countMController.text),
                              approximateVolumeInTons:
                                  double.tryParse(countTController.text),
                              note: noteController.text,
                            );

                            final result = await provider.editRequest(editDto);
                            MessageHelper.showByStatus(
                              isSuccess: result,
                              successMessage: 'Заявка успешно отредактирована',
                              errorMessage:
                                  'Во время редактирования заявки что-то пошло не так. Попробуйте снова.',
                            );
                            if (result) {
                              provider.loadRequests([RequestStatuses.New]);
                            }
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _doubleValidate(String? value) {
    if (value == null || value == '') return null;

    if (double.tryParse(value) == null) {
      return 'Введите число';
    }

    return null;
  }
}
