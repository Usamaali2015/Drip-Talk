import 'package:drip_talk/core/utils/app_utils/toast_utils.dart';
import 'package:drip_talk/core/utils/routes/app_routes.dart';
import 'package:drip_talk/features/auth/login/bloc/login_bloc.dart';
import 'package:drip_talk/features/auth/login/bloc/login_event.dart';
import 'package:drip_talk/features/auth/login/bloc/login_state.dart';
import 'package:drip_talk/generated/assets.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';

class DeleteAccountSheet extends StatefulWidget {
  const DeleteAccountSheet({super.key, required this.parentContext});

  final BuildContext parentContext;

  static Future<void> show(BuildContext context) {
    final loginBloc = context.read<LoginBloc>();
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      useRootNavigator: true,
      backgroundColor: AppColors.transparent,
      builder: (_) => BlocProvider.value(
        value: loginBloc,
        child: DeleteAccountSheet(parentContext: context),
      ),
    );
  }

  @override
  State<DeleteAccountSheet> createState() => _DeleteAccountSheetState();
}

class _DeleteAccountSheetState extends State<DeleteAccountSheet> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  String? _emailError;
  String? _passwordError;
  String? _acknowledgementError;
  bool _isAcknowledged = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit(AppLocalizations l10n) {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() {
      _emailError = null;
      _passwordError = null;
      _acknowledgementError = null;
    });

    var hasError = false;

    if (email.isEmpty) {
      _emailError = l10n.deleteAccountEmailRequired;
      hasError = true;
    } else if (!_isValidEmail(email)) {
      _emailError = l10n.invalidEmail;
      hasError = true;
    }

    if (password.trim().isEmpty) {
      _passwordError = l10n.deleteAccountPasswordRequired;
      hasError = true;
    }

    if (!_isAcknowledged) {
      _acknowledgementError = l10n.deleteAccountAcknowledgementRequired;
      hasError = true;
    }

    if (hasError) {
      setState(() {});
      return;
    }

    context.read<LoginBloc>().add(
      DeleteAccountRequested(email: email, password: password),
    );
  }

  bool _isValidEmail(String value) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (previous, current) =>
          current is DeleteAccountSuccess || current is DeleteAccountError,
      listener: (context, state) {
        if (state is DeleteAccountSuccess) {
          Navigator.of(context).pop();
          widget.parentContext.goNamed(
            AppRoutes.login,
            queryParameters: state.message?.trim().isNotEmpty == true
                ? {'message': state.message!.trim()}
                : <String, String>{},
          );
          return;
        }

        if (state is DeleteAccountError) {
          ToastUtils.show(context, state.message, type: ToastType.error);
        }
      },
      child: FractionallySizedBox(
        heightFactor: 0.9,
        child: Container(
          padding: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppRadius.r30),
              topRight: Radius.circular(AppRadius.r30),
            ),

            color: AppColors.secondary,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.lightBg,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppRadius.r30),
                topRight: Radius.circular(AppRadius.r30),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(AppSizes.s28),
                      child: BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          final isLoading = state is DeleteAccountLoading;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: AppSizes.s4),
                              Center(
                                child: AppAssetImage(
                                  assetPath: Assets.deleteAccountIcon,
                                ),
                              ),
                              const SizedBox(height: AppSizes.s16),
                              Center(
                                child: AppText(
                                  text: l10n.deleteAccountSheetTitle
                                      .toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.ts24(
                                    context,
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSizes.s8),
                              Center(
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: AppSizes.s280,
                                  ),
                                  child: AppText(
                                    text: l10n.deleteAccountSheetSubtitle,
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                    style: AppTextStyles.ts14(
                                      context,
                                      color: AppColors.pureWhite,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSizes.s20),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.s18,
                                  vertical: AppSizes.s14,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary.withValues(
                                    alpha: 0.08,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.r16,
                                  ),
                                  border: Border.all(
                                    color: AppColors.secondary.withValues(
                                      alpha: 0.48,
                                    ),
                                  ),
                                ),
                                child: AppText(
                                  text: l10n.deleteAccountWarningMessage,
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  style: AppTextStyles.ts10(
                                    context,
                                    color: AppColors.pureWhite.withValues(
                                      alpha: 0.82,
                                    ),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSizes.s16),
                              AppText(
                                text: l10n.deleteAccountEmailLabel,
                                maxLines: 3,
                                style: AppTextStyles.ts14(
                                  context,
                                  color: AppColors.pureWhite,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: AppSizes.s10),
                              _DeleteAccountFieldTheme(
                                child: AppTextField(
                                  controller: _emailController,
                                  hintText: l10n.deleteAccountEmailHint,
                                  keyboardType: TextInputType.emailAddress,
                                  enabled: !isLoading,
                                  borderRadius: AppRadius.r16,
                                  onChanged: (_) {
                                    if (_emailError != null) {
                                      setState(() => _emailError = null);
                                    }
                                  },
                                ),
                              ),
                              if (_emailError != null) ...[
                                const SizedBox(height: AppSizes.s6),
                                AppText(
                                  text: _emailError!,
                                  style: AppTextStyles.ts12(
                                    context,
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                              const SizedBox(height: AppSizes.s18),
                              AppText(
                                text: l10n.deleteAccountPasswordLabel,
                                style: AppTextStyles.ts14(
                                  context,
                                  color: AppColors.pureWhite,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: AppSizes.s10),
                              _DeleteAccountFieldTheme(
                                child: AppTextField(
                                  controller: _passwordController,
                                  hintText: l10n.deleteAccountPasswordHint,
                                  obscureText: true,
                                  enabled: !isLoading,
                                  borderRadius: AppRadius.r16,
                                  onChanged: (_) {
                                    if (_passwordError != null) {
                                      setState(() => _passwordError = null);
                                    }
                                  },
                                ),
                              ),
                              if (_passwordError != null) ...[
                                const SizedBox(height: AppSizes.s6),
                                AppText(
                                  text: _passwordError!,
                                  style: AppTextStyles.ts12(
                                    context,
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                              const SizedBox(height: AppSizes.s18),
                              InkWell(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.r16,
                                ),
                                onTap: isLoading
                                    ? null
                                    : () {
                                        setState(() {
                                          _isAcknowledged = !_isAcknowledged;
                                          _acknowledgementError = null;
                                        });
                                      },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(AppSizes.s16),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary.withValues(
                                      alpha: 0.12,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.r16,
                                    ),
                                    border: Border.all(
                                      color: AppColors.secondary.withValues(
                                        alpha: 0.3,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 180,
                                        ),
                                        width: AppSizes.s16,
                                        height: AppSizes.s16,
                                        margin: const EdgeInsets.only(
                                          top: AppSizes.s2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _isAcknowledged
                                              ? AppColors.secondary
                                              : AppColors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            AppRadius.r4,
                                          ),
                                          border: Border.all(
                                            color: AppColors.secondary,
                                          ),
                                        ),
                                        child: _isAcknowledged
                                            ? const Icon(
                                                Icons.check_rounded,
                                                size: AppSizes.s12,
                                                color: AppColors.pureWhite,
                                              )
                                            : null,
                                      ),
                                      const SizedBox(width: AppSizes.s10),
                                      Expanded(
                                        child: AppText(
                                          text:
                                              l10n.deleteAccountAcknowledgement,
                                          textAlign: TextAlign.justify,
                                          maxLines: 2,
                                          style: AppTextStyles.ts12(
                                            context,
                                            color: AppColors.pureWhite
                                                .withValues(alpha: 0.84),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (_acknowledgementError != null) ...[
                                const SizedBox(height: AppSizes.s6),
                                AppText(
                                  text: _acknowledgementError!,
                                  style: AppTextStyles.ts12(
                                    context,
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                              const SizedBox(height: AppSizes.s24),
                              Row(
                                children: [
                                  Expanded(
                                    child: AppButton(
                                      text: l10n.cancel,
                                      onPressed: isLoading
                                          ? null
                                          : () => Navigator.of(context).pop(),
                                      height: AppSizes.s56,
                                      fontSize: AppSizes.s16,
                                      fontWeight: FontWeight.w700,
                                      backgroundColor: AppColors.transparent,
                                      borderColor: AppColors.secondary,
                                      borderRadius: AppRadius.r16,
                                    ),
                                  ),
                                  const SizedBox(width: AppSizes.s12),
                                  Expanded(
                                    child: AppButton(
                                      text: l10n.deleteAccountConfirmAction,
                                      onPressed: isLoading
                                          ? null
                                          : () => _submit(l10n),
                                      isLoading: isLoading,
                                      height: AppSizes.s56,
                                      fontSize: AppSizes.s16,
                                      fontWeight: FontWeight.w800,
                                      gradientColors: const [
                                        AppColors.secondary,
                                        AppColors.deleteAccent,
                                      ],
                                      borderRadius: AppRadius.r16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DeleteAccountFieldTheme extends StatelessWidget {
  const _DeleteAccountFieldTheme({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          surface: AppColors.pureWhite,
          onSurface: AppColors.darkBg,
          onSurfaceVariant: AppColors.materialGrey,
          error: AppColors.secondary,
        ),
      ),
      child: child,
    );
  }
}
