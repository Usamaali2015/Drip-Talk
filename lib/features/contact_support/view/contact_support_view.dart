import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/core/utils/app_utils/toast_utils.dart';
import 'package:drip_talk/core/utils/routes/app_routes.dart';
import 'package:drip_talk/features/contact_support/barrels/contact_support_barrels.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSupportView extends StatefulWidget {
  const ContactSupportView({super.key});

  @override
  State<ContactSupportView> createState() => _ContactSupportViewState();
}

class _ContactSupportViewState extends State<ContactSupportView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _orderIdController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _orderIdController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<ContactSupportBloc, ContactSupportState>(
      listenWhen: (previous, current) =>
          previous.name != current.name ||
          previous.email != current.email ||
          previous.orderId != current.orderId ||
          previous.message != current.message ||
          previous.feedbackMessage != current.feedbackMessage ||
          previous.status != current.status,
      listener: (context, state) {
        _syncController(_nameController, state.name);
        _syncController(_emailController, state.email);
        _syncController(_orderIdController, state.orderId);
        _syncController(_messageController, state.message);

        final feedback = state.feedbackMessage?.trim();
        if (feedback == null || feedback.isEmpty) {
          return;
        }

        ToastUtils.show(
          context,
          feedback,
          type: state.status == ContactSupportStatus.success
              ? ToastType.success
              : ToastType.error,
        );
      },
      builder: (context, state) {
        return AppResponsivePageLayout(
          mobileMaxWidth: 420,
          tabletMaxWidth: 560,
          tabletLargeMaxWidth: 640,
          desktopMaxWidth: 720,
          backgroundGradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.supportGradientTop,
              AppColors.supportGradientMiddle,
              AppColors.supportGradientBottom,
            ],
          ),
          headerBuilder: (context, _) => AppPageHeader(
            title: l10n.contactSupport,
            subtitle: l10n.contactSupportSubtitle,
            onBack: () => _handleBack(context),
            backgroundColor: AppColors.supportHeaderBackground,
          ),
          bodyBuilder: (context, _) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ContactSupportSectionHeading(
                    icon: Icons.bolt_rounded,
                    title: l10n.contactSupportQuickContactOptions,
                  ),
                  const AppGap(AppSizes.s16),
                  ContactSupportQuickContactCard(
                    icon: Icons.mail_rounded,
                    title: l10n.contactSupportEmailSupport,
                    subtitle: l10n.contactSupportEmailResponseTime,
                    onTap: () => _launchEmail(context),
                  ),
                  const AppGap(AppSizes.s14),
                  ContactSupportQuickContactCard(
                    icon: Icons.call_rounded,
                    title: l10n.contactSupportPhoneSupport,
                    subtitle: l10n.contactSupportPhoneAvailability,
                    onTap: () => _launchPhone(context),
                  ),
                  const AppGap(AppSizes.s28),
                  ContactSupportSectionHeading(
                    icon: Icons.send_rounded,
                    title: l10n.contactSupportSubmitARequest,
                  ),
                  const AppGap(AppSizes.s18),
                  AppTextField(
                    controller: _nameController,
                    labelText: l10n.contactSupportNameLabel,
                    hintText: l10n.contactSupportNameHint,
                    isRequired: true,
                    borderRadius: AppRadius.r15,
                    errorText: state.nameError,
                    onChanged: (value) {
                      context.read<ContactSupportBloc>().add(
                        ContactSupportNameChanged(value),
                      );
                    },
                  ),
                  const AppGap(AppSizes.s16),
                  AppTextField(
                    controller: _emailController,
                    labelText: l10n.contactSupportEmailLabel,
                    hintText: l10n.contactSupportEmailHint,
                    isRequired: true,
                    keyboardType: TextInputType.emailAddress,
                    borderRadius: AppRadius.r15,
                    errorText: state.emailError,
                    onChanged: (value) {
                      context.read<ContactSupportBloc>().add(
                        ContactSupportEmailChanged(value),
                      );
                    },
                  ),
                  const AppGap(AppSizes.s16),
                  AppTextField(
                    controller: _orderIdController,
                    labelText: l10n.contactSupportOrderIdLabel,
                    hintText: l10n.contactSupportOrderIdHint,
                    borderRadius: AppRadius.r15,
                    errorText: state.orderIdError,
                    onChanged: (value) {
                      context.read<ContactSupportBloc>().add(
                        ContactSupportOrderIdChanged(value),
                      );
                    },
                  ),
                  const AppGap(AppSizes.s16),
                  ContactSupportIssueTypeDropdownField(
                    label: l10n.contactSupportIssueTypeLabel,
                    value: state.issueType,
                    errorText: state.issueTypeError,
                    items: ContactSupportIssueType.values,
                    itemLabelBuilder: (type) => _issueTypeLabel(type, l10n),
                    onChanged: (value) {
                      context.read<ContactSupportBloc>().add(
                        ContactSupportIssueTypeChanged(value),
                      );
                    },
                  ),
                  const AppGap(AppSizes.s16),
                  ContactSupportMessageField(
                    controller: _messageController,
                    label: l10n.contactSupportMessageLabel,
                    hintText: l10n.contactSupportMessageHint,
                    errorText: state.messageError,
                    currentLength: state.messageLength,
                    maxLength: ContactSupportState.messageCharacterLimit,
                    onChanged: (value) {
                      context.read<ContactSupportBloc>().add(
                        ContactSupportMessageChanged(value),
                      );
                    },
                  ),
                  const AppGap(AppSizes.s28),
                  AppButton(
                    text: l10n.contactSupportSubmitAction,
                    isLoading: state.isSubmitting,
                    height: AppSizes.s56,
                    borderRadius: AppRadius.r16,
                    gradientColors: const [
                      AppColors.secondary,
                      AppColors.primary,
                    ],
                    leadingIcon: const Icon(
                      Icons.send_rounded,
                      color: AppColors.pureWhite,
                      size: AppSizes.s18,
                    ),
                    onPressed: state.isSubmitting
                        ? null
                        : () {
                            context.read<ContactSupportBloc>().add(
                              const SubmitContactSupportRequested(),
                            );
                          },
                  ),
                  const AppGap(AppSizes.s24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _syncController(TextEditingController controller, String value) {
    if (controller.text == value) {
      return;
    }

    controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  String _issueTypeLabel(ContactSupportIssueType type, AppLocalizations l10n) {
    switch (type) {
      case ContactSupportIssueType.orderIssue:
        return l10n.contactSupportIssueTypeOrderIssue;
      case ContactSupportIssueType.paymentIssue:
        return l10n.contactSupportIssueTypePaymentIssue;
      case ContactSupportIssueType.shippingDelay:
        return l10n.contactSupportIssueTypeShippingDelay;
      case ContactSupportIssueType.returnRefund:
        return l10n.contactSupportIssueTypeReturnRefund;
      case ContactSupportIssueType.accountIssue:
        return l10n.contactSupportIssueTypeAccountIssue;
      case ContactSupportIssueType.other:
        return l10n.contactSupportIssueTypeOther;
    }
  }

  Future<void> _launchEmail(BuildContext context) async {
    final uri = Uri(scheme: 'mailto', path: AppConstants.supportEmail);
    final didLaunch = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (!didLaunch && context.mounted) {
      ToastUtils.show(
        context,
        AppLocalizations.of(context)!.contactSupportEmailLaunchFailed,
        type: ToastType.info,
      );
    }
  }

  Future<void> _launchPhone(BuildContext context) async {
    final uri = Uri(scheme: 'tel', path: AppConstants.supportPhone);
    final didLaunch = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (!didLaunch && context.mounted) {
      ToastUtils.show(
        context,
        AppLocalizations.of(context)!.contactSupportPhoneLaunchFailed,
        type: ToastType.info,
      );
    }
  }

  void _handleBack(BuildContext context) {
    if (GoRouter.of(context).canPop()) {
      context.pop();
      return;
    }

    context.goNamed(AppRoutes.helpCenter);
  }
}
