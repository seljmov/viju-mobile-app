import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

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
import '../../contacts/request_statuses.dart';
import '../../contacts/waste_dto/waste_dto.dart';
import 'widgets/attach_images_grid.dart';

class RequestAddPage extends StatelessWidget {
  const RequestAddPage({
    super.key,
    required this.contractors,
    required this.wastes,
    required this.removals,
  });

  final List<ContractorDto> contractors;
  final List<WasteDto> wastes;
  final List<RemovalDto> removals;

  @override
  Widget build(BuildContext context) {
    final contractorController = TextEditingController();
    final locationController = TextEditingController();
    final addressController = TextEditingController();
    final locationsNotifier = ValueNotifier<List<LocationDto>?>(
      contractors.length == 1 ? contractors[0].locations : null,
    );
    final addressesNotifier = ValueNotifier<List<AddressDto>?>(
      locationsNotifier.value != null && locationsNotifier.value?.length == 1
          ? locationsNotifier.value![0].addresses
          : null,
    );
    final wasteController = TextEditingController();
    final removalController = TextEditingController();
    final countMController = TextEditingController();
    final countTController = TextEditingController();
    final noteController = TextEditingController();
    final countMFormKey = GlobalKey<FormFieldState>();
    final countTFormKey = GlobalKey<FormFieldState>();
    final imageFilesNotifier = ValueNotifier<List<MultiImage>>([]);

    final canCreateRequestNotifier = ValueNotifier<bool>(false);
    bool canCreateRequest() {
      return contractorController.text.isNotEmpty &&
          locationController.text.isNotEmpty &&
          addressController.text.isNotEmpty &&
          wasteController.text.isNotEmpty &&
          removalController.text.isNotEmpty;
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: ThesisSplitScreen(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: ThesisSliverScreen(
                title: 'Создание заявки',
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
                        addressController.text = '';
                        addressesNotifier.value = null;
                        locationController.text = '';
                        locationsNotifier.value = null;

                        contractorController.text = contractors[0].name;
                        locationsNotifier.value = contractors[0].locations;

                        canCreateRequestNotifier.value = canCreateRequest();
                        return const SizedBox.shrink();
                      }

                      return ThesisDropDownButton<ContractorDto>(
                        controller: contractorController,
                        bottomSheepTitle: 'Контрагенты',
                        items: contractors,
                        itemBuilder: (item) => Text(
                          item.name,
                          style: context.textTheme.titleLarge,
                        ),
                        onSelected: (item) {
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
                          addressController.text = '';
                          addressesNotifier.value = null;
                          locationController.text = locations[0].name;
                          addressesNotifier.value = locations[0].addresses;
                          canCreateRequestNotifier.value = canCreateRequest();
                          return const SizedBox.shrink();
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ThesisDropDownButton<LocationDto>(
                            controller: locationController,
                            initialItem:
                                locations.length == 1 ? locations[0] : null,
                            bottomSheepTitle: 'Локации',
                            items: locations,
                            itemBuilder: (item) => Text(
                              item.name,
                              style: context.textTheme.titleLarge,
                            ),
                            onSelected: (item) {
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
                            initialItem:
                                addresses.length == 1 ? addresses[0] : null,
                            bottomSheepTitle: 'Адреса',
                            items: addresses,
                            itemBuilder: (item) => Text(
                              item.address,
                              style: context.textTheme.titleLarge,
                            ),
                            onSelected: (item) {
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
                            final createDto = RequestCreateDto(
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

                            final images = imageFilesNotifier.value
                                .map((el) => el.file)
                                .toList();

                            final provider =
                                context.read<RequestDataProvider>();
                            final result =
                                await provider.createRequest(createDto, images);
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
