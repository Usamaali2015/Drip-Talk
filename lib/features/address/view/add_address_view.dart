import 'package:country_code_picker/country_code_picker.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/core/services/ip_country/ip_country_service.dart';
import 'package:drip_talk/core/utils/app_utils/toast_utils.dart';
import 'package:drip_talk/core/utils/responsive/responsive_extensions.dart';
import 'package:drip_talk/features/address/barrels/address_barrels.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
part 'widgets/add_address_view_widgets.dart';

class AddAddressView extends StatefulWidget {
  const AddAddressView({super.key, this.initialAddress});

  final AddressListItem? initialAddress;

  @override
  State<AddAddressView> createState() => _AddAddressViewState();
}

class _AddAddressViewState extends State<AddAddressView> {
  late final TextEditingController _addressLineController;
  late final FocusNode _addressLineFocusNode;
  late final TextEditingController _cityController;
  late final FocusNode _cityFocusNode;
  String _countryDialCode = '+1';
  final Map<_AddressField, String?> _fieldErrors = <_AddressField, String?>{};
  late final TextEditingController _fullNameController;
  late final FocusNode _fullNameFocusNode;
  late final TextEditingController _phoneController;
  late final FocusNode _phoneFocusNode;
  late final TextEditingController _postalCodeController;
  late final FocusNode _postalCodeFocusNode;
  late final TextEditingController _stateProvinceController;
  late final FocusNode _stateProvinceFocusNode;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressLineController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _stateProvinceController.dispose();

    _fullNameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _addressLineFocusNode.dispose();
    _cityFocusNode.dispose();
    _postalCodeFocusNode.dispose();
    _stateProvinceFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressLineController = TextEditingController();
    _cityController = TextEditingController();
    _postalCodeController = TextEditingController();
    _stateProvinceController = TextEditingController();

    _fullNameFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();
    _addressLineFocusNode = FocusNode();
    _cityFocusNode = FocusNode();
    _postalCodeFocusNode = FocusNode();
    _stateProvinceFocusNode = FocusNode();

    _prefillFormIfNeeded();
    _resolveCountryDialCode();
  }

  void _prefillFormIfNeeded() {
    final initialAddress = widget.initialAddress;
    context.read<AddAddressBloc>().add(
      AddAddressFormInitialized(initialAddress),
    );

    if (initialAddress == null) {
      return;
    }

    _fullNameController.text = initialAddress.fullName?.trim() ?? '';
    _addressLineController.text = initialAddress.addressLine?.trim() ?? '';
    _cityController.text = initialAddress.city?.trim() ?? '';
    _postalCodeController.text = initialAddress.postalCode?.trim() ?? '';
    _stateProvinceController.text = initialAddress.stateProvince?.trim() ?? '';

    final phoneParts = _splitPhoneNumber(initialAddress.phone);
    _countryDialCode = phoneParts.dialCode;
    _phoneController.text = phoneParts.localNumber;
  }

  Future<void> _resolveCountryDialCode() async {
    final initialAddress = widget.initialAddress;
    final initialPhone = initialAddress?.phone?.trim() ?? '';
    final shouldResolveFromIp =
        initialAddress == null ||
        initialPhone.isEmpty ||
        !initialPhone.replaceAll(RegExp(r'\s+'), '').startsWith('+');

    if (!shouldResolveFromIp) {
      return;
    }

    final resolvedDialCode = _normalizeDialCode(
      await IpCountryService.instance.resolveDialCode(),
    );

    if (!mounted || resolvedDialCode == null) {
      return;
    }

    if (initialAddress == null) {
      if (resolvedDialCode == _countryDialCode) {
        return;
      }

      setState(() {
        _countryDialCode = resolvedDialCode;
      });
      return;
    }

    final phoneParts = _splitPhoneNumber(
      initialAddress.phone,
      fallbackDialCode: resolvedDialCode,
    );

    if (phoneParts.dialCode == _countryDialCode &&
        phoneParts.localNumber == _phoneController.text) {
      return;
    }

    setState(() {
      _countryDialCode = phoneParts.dialCode;
      _phoneController.text = phoneParts.localNumber;
    });
  }

  void _clearFieldError(_AddressField field) {
    if (_fieldErrors[field] == null) {
      return;
    }

    setState(() {
      _fieldErrors.remove(field);
    });
  }

  void _submitAddress() {
    final l10n = AppLocalizations.of(context)!;
    final fullName = _fullNameController.text.trim();
    final phone = _phoneController.text.trim();
    final addressLine = _addressLineController.text.trim();
    final city = _cityController.text.trim();
    final postalCode = _postalCodeController.text.trim();
    final stateProvince = _stateProvinceController.text.trim();

    final nextErrors = <_AddressField, String?>{};

    if (fullName.isEmpty) {
      nextErrors[_AddressField.fullName] = l10n.addAddressRequiredName;
    }
    if (phone.isEmpty) {
      nextErrors[_AddressField.phone] = l10n.addAddressRequiredPhone;
    } else if (_normalizedPhone(phone).length < 7) {
      nextErrors[_AddressField.phone] = l10n.addAddressInvalidPhone;
    }
    if (addressLine.isEmpty) {
      nextErrors[_AddressField.addressLine] =
          l10n.addAddressRequiredAddressLine;
    }
    if (city.isEmpty) {
      nextErrors[_AddressField.city] = l10n.addAddressRequiredCity;
    }
    if (postalCode.isEmpty) {
      nextErrors[_AddressField.postalCode] = l10n.addAddressRequiredPostal;
    }
    if (stateProvince.isEmpty) {
      nextErrors[_AddressField.stateProvince] = l10n.addAddressRequiredState;
    }

    if (nextErrors.isNotEmpty) {
      setState(() {
        _fieldErrors
          ..clear()
          ..addAll(nextErrors);
      });
      _focusFirstInvalidField(nextErrors.keys.first);
      ToastUtils.show(
        context,
        l10n.addAddressValidationError,
        type: ToastType.error,
      );
      return;
    }

    FocusScope.of(context).unfocus();

    context.read<AddAddressBloc>().add(
      AddAddressSubmitted(
        AddAddressRequestModel(
          label: context.read<AddAddressBloc>().state.selectedLabel.value,
          fullName: fullName,
          phone: '$_countryDialCode${_normalizedPhone(phone)}',
          addressLine: addressLine,
          city: city,
          stateProvince: stateProvince,
          postalCode: postalCode,
          isDefault: context.read<AddAddressBloc>().state.isDefault,
        ),
      ),
    );
  }

  void _focusFirstInvalidField(_AddressField field) {
    switch (field) {
      case _AddressField.fullName:
        _fullNameFocusNode.requestFocus();
        return;
      case _AddressField.phone:
        _phoneFocusNode.requestFocus();
        return;
      case _AddressField.addressLine:
        _addressLineFocusNode.requestFocus();
        return;
      case _AddressField.city:
        _cityFocusNode.requestFocus();
        return;
      case _AddressField.postalCode:
        _postalCodeFocusNode.requestFocus();
        return;
      case _AddressField.stateProvince:
        _stateProvinceFocusNode.requestFocus();
        return;
    }
  }

  String _normalizedPhone(String value) {
    return value.replaceAll(RegExp(r'[^0-9]'), '');
  }

  _PhoneParts _splitPhoneNumber(String? rawPhone, {String? fallbackDialCode}) {
    final compact = rawPhone?.replaceAll(RegExp(r'\s+'), '') ?? '';
    final resolvedFallbackDialCode =
        _normalizeDialCode(fallbackDialCode) ??
        _normalizeDialCode(_countryDialCode) ??
        '+1';

    if (compact.isEmpty) {
      return _PhoneParts(
        dialCode: resolvedFallbackDialCode,
        localNumber: '',
      );
    }

    if (!compact.startsWith('+')) {
      return _PhoneParts(
        dialCode: resolvedFallbackDialCode,
        localNumber: compact,
      );
    }

    for (int dialDigits = 4; dialDigits >= 1; dialDigits--) {
      final endIndex = dialDigits + 1;
      if (compact.length <= endIndex) {
        continue;
      }

      final candidate = compact.substring(0, endIndex);
      final countryCode = CountryCode.tryFromDialCode(candidate);
      if (countryCode != null) {
        return _PhoneParts(
          dialCode: candidate,
          localNumber: compact.substring(endIndex),
        );
      }
    }

    return _PhoneParts(
      dialCode: resolvedFallbackDialCode,
      localNumber: compact.replaceFirst(RegExp(r'^\+'), ''),
    );
  }

  String? _normalizeDialCode(String? value) {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }

    return normalized.startsWith('+') ? normalized : '+$normalized';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<AddAddressBloc, AddAddressState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == AddAddressStatus.success) {
          ToastUtils.show(
            context,
            state.message?.trim().isNotEmpty == true
                ? state.message!.trim()
                : state.isEditing
                ? l10n.updateAddressSavedSuccess
                : l10n.addAddressSavedSuccess,
            type: ToastType.success,
          );
          context.pop(true);
        } else if (state.status == AddAddressStatus.failure) {
          ToastUtils.show(
            context,
            state.message?.trim().isNotEmpty == true
                ? state.message!.trim()
                : state.isEditing
                ? l10n.updateAddressSaveFailed
                : l10n.addAddressSaveFailed,
            type: ToastType.error,
          );
        }
      },
      builder: (context, state) {
        final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
        final horizontalPadding = context.responsive(
          20.0,
          tablet: 24.0,
          tabletLarge: 28.0,
          desktop: 32.0,
        );
        final topPadding = context.responsive(
          12.0,
          tablet: 16.0,
          tabletLarge: 18.0,
          desktop: 20.0,
        );
        final labelOptions = <_AddressLabelOption>[
          _AddressLabelOption(
            label: l10n.addAddressLabelHome,
            value: AddressLabel.home,
          ),
          _AddressLabelOption(
            label: l10n.addAddressLabelWork,
            value: AddressLabel.work,
          ),
          _AddressLabelOption(
            label: l10n.addAddressLabelOther,
            value: AddressLabel.other,
          ),
        ];

        return AppResponsivePageLayout(
          mobileMaxWidth: 430,
          tabletMaxWidth: 560,
          tabletLargeMaxWidth: 640,
          desktopMaxWidth: 720,
          showHeaderDivider: false,
          pageBuilder: (context, contentWidth) {
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  topPadding,
                  horizontalPadding,
                  keyboardInset + AppSizes.s24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AddressPageHeader(
                      title: state.isEditing
                          ? l10n.editAddressTitle
                          : l10n.addAddressTitle,
                      subtitle: l10n.addAddressSubtitle,
                      onBack: () => context.pop(),
                    ),
                    const AppGap(AppSizes.s24),
                    _SectionTitle(
                      title: state.isEditing
                          ? l10n.editAddressSectionTitle
                          : l10n.addAddressSectionTitle,
                    ),
                    const AppGap(AppSizes.s20),
                    AppTextField(
                      controller: _fullNameController,
                      focusNode: _fullNameFocusNode,
                      nextFocus: _phoneFocusNode,
                      labelText: l10n.addAddressFullNameLabel,
                      hintText: l10n.addAddressFullNameHint,
                      isRequired: true,
                      borderRadius: AppRadius.r12,
                      errorText: _fieldErrors[_AddressField.fullName],
                      onChanged: (_) => _clearFieldError(_AddressField.fullName),
                    ),
                    const AppGap(AppSizes.s16),
                    AppTextField(
                      controller: _phoneController,
                      focusNode: _phoneFocusNode,
                      nextFocus: _addressLineFocusNode,
                      labelText: l10n.addAddressPhoneLabel,
                      hintText: l10n.addAddressPhoneHint,
                      isRequired: true,
                      isPhone: true,
                      countryDialCode: _countryDialCode,
                      keyboardType: TextInputType.phone,
                      borderRadius: AppRadius.r12,
                      errorText: _fieldErrors[_AddressField.phone],
                      onCountryChanged: (code) {
                        setState(() {
                          _countryDialCode = code.dialCode ?? _countryDialCode;
                        });
                      },
                      onChanged: (_) => _clearFieldError(_AddressField.phone),
                    ),
                    const AppGap(AppSizes.s16),
                    AppTextField(
                      controller: _addressLineController,
                      focusNode: _addressLineFocusNode,
                      nextFocus: _cityFocusNode,
                      labelText: l10n.addAddressLineLabel,
                      hintText: l10n.addAddressLineHint,
                      isRequired: true,
                      borderRadius: AppRadius.r12,
                      errorText: _fieldErrors[_AddressField.addressLine],
                      onChanged: (_) =>
                          _clearFieldError(_AddressField.addressLine),
                    ),
                    const AppGap(AppSizes.s16),
                    AppTextField(
                      controller: _cityController,
                      focusNode: _cityFocusNode,
                      nextFocus: _postalCodeFocusNode,
                      labelText: l10n.addAddressCityLabel,
                      hintText: l10n.addAddressCityHint,
                      isRequired: true,
                      borderRadius: AppRadius.r12,
                      errorText: _fieldErrors[_AddressField.city],
                      onChanged: (_) => _clearFieldError(_AddressField.city),
                    ),
                    const AppGap(AppSizes.s16),
                    AppTextField(
                      controller: _postalCodeController,
                      focusNode: _postalCodeFocusNode,
                      nextFocus: _stateProvinceFocusNode,
                      labelText: l10n.addAddressPostalLabel,
                      hintText: l10n.addAddressPostalHint,
                      isRequired: true,
                      borderRadius: AppRadius.r12,
                      errorText: _fieldErrors[_AddressField.postalCode],
                      onChanged: (_) =>
                          _clearFieldError(_AddressField.postalCode),
                    ),
                    const AppGap(AppSizes.s16),
                    AppTextField(
                      controller: _stateProvinceController,
                      focusNode: _stateProvinceFocusNode,
                      textInputAction: TextInputAction.done,
                      labelText: l10n.addAddressStateLabel,
                      hintText: l10n.addAddressStateHint,
                      isRequired: true,
                      borderRadius: AppRadius.r12,
                      errorText: _fieldErrors[_AddressField.stateProvince],
                      onChanged: (_) =>
                          _clearFieldError(_AddressField.stateProvince),
                      onSubmitted: (_) => _submitAddress(),
                    ),
                    const AppGap(AppSizes.s20),
                    AppText(
                      text: l10n.addAddressLabelTitle,
                      style: AppTextStyles.ts16(
                        context,
                        color: AppColors.pureWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const AppGap(AppSizes.s12),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final spacing = context.responsive(
                          AppSizes.s12,
                          tablet: AppSizes.s14,
                          tabletLarge: AppSizes.s16,
                          desktop: AppSizes.s18,
                        );
                        final totalSpacing =
                            spacing * (labelOptions.length - 1);
                        final availableWidth = constraints.maxWidth;
                        final rawChipWidth =
                            (availableWidth - totalSpacing) /
                            labelOptions.length;
                        final maxChipWidth = context.responsive(
                          rawChipWidth,
                          tablet: 168.0,
                          tabletLarge: 186.0,
                          desktop: 208.0,
                        );
                        final chipWidth = rawChipWidth
                            .clamp(0.0, maxChipWidth)
                            .toDouble();

                        return Wrap(
                          spacing: spacing,
                          runSpacing: spacing,
                          children: labelOptions
                              .map(
                                (option) => SizedBox(
                                  width: chipWidth,
                                  child: _AddressLabelChip(
                                    label: option.label,
                                    isSelected:
                                        state.selectedLabel == option.value,
                                    onTap: () {
                                      context.read<AddAddressBloc>().add(
                                        AddAddressLabelChanged(option.value),
                                      );
                                    },
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                    const AppGap(AppSizes.s18),
                    Container(
                      width: AppSizes.fitWidth,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.s16,
                        vertical: AppSizes.s8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(AppRadius.r16),
                        border: Border.all(
                          color: AppColors.secondary.withValues(alpha: 0.45),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: AppText(
                              text: l10n.addAddressDefaultTitle,
                              style: AppTextStyles.ts15(
                                context,
                                color: AppColors.pureWhite,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Switch(
                            value: state.isDefault,
                            onChanged: (value) {
                              context.read<AddAddressBloc>().add(
                                AddAddressDefaultToggled(value),
                              );
                            },
                            activeThumbColor: AppColors.pureWhite,
                            activeTrackColor: AppColors.secondary,
                            inactiveThumbColor: AppColors.pureWhite,
                            inactiveTrackColor: AppColors.pureWhite.withValues(
                              alpha: 0.28,
                            ),
                            trackOutlineColor: const WidgetStatePropertyAll(
                              AppColors.transparent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const AppGap(AppSizes.s12),
                    AppText(
                      text: l10n.addAddressInfoNote,
                      maxLines: 2,
                      style: AppTextStyles.ts14(
                        context,
                        color: AppColors.pureWhite.withValues(alpha: 0.82),
                      ),
                    ),
                    const AppGap(AppSizes.s24),
                    AppButton(
                      text: state.isEditing
                          ? l10n.updateAddressSaveButton
                          : l10n.addAddressSaveButton,
                      isLoading: state.isSubmitting,
                      onPressed: _submitAddress,
                      height: AppSizes.s56,
                      borderRadius: AppRadius.circular,
                      gradientColors: const [
                        AppColors.secondary,
                        AppColors.primary,
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

enum _AddressField {
  fullName,
  phone,
  addressLine,
  city,
  postalCode,
  stateProvince,
}

class _PhoneParts {
  const _PhoneParts({required this.dialCode, required this.localNumber});

  final String dialCode;
  final String localNumber;
}
