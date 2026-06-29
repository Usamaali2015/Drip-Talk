import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/features/auth/profile_setup/view/widgets/profile_setup_shared_widgets.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileSetupDatePickerSheet extends StatefulWidget {
  const ProfileSetupDatePickerSheet({
    super.key,
    required this.title,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  final String title;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  State<ProfileSetupDatePickerSheet> createState() =>
      _ProfileSetupDatePickerSheetState();
}

class _ProfileSetupDatePickerSheetState
    extends State<ProfileSetupDatePickerSheet> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2D1747), Color(0xFF1A1230)],
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.pureWhite.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(AppRadius.circular),
              ),
            ),
            const AppGap(AppSizes.s18),
            ProfileSetupSheetHeader(title: widget.title),
            const AppGap(AppSizes.s8),
            AppText(
              text: DateFormat('MMMM d, yyyy').format(_selectedDate),
              style: AppTextStyles.ts14(
                context,
                color: AppColors.pureWhite.withValues(alpha: 0.72),
                fontWeight: FontWeight.w500,
              ),
            ),
            const AppGap(AppSizes.s16),
            Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: AppColors.secondary,
                  onPrimary: AppColors.pureWhite,
                  surface: AppColors.lightBg,
                  onSurface: AppColors.pureWhite,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.secondary,
                  ),
                ),
                iconButtonTheme: IconButtonThemeData(
                  style: IconButton.styleFrom(
                    foregroundColor: AppColors.secondary,
                  ),
                ),
              ),
              child: CalendarDatePicker(
                initialDate: _selectedDate,
                firstDate: widget.firstDate,
                lastDate: widget.lastDate,
                onDateChanged: (value) {
                  setState(() => _selectedDate = value);
                },
              ),
            ),
            const AppGap(AppSizes.s16),
            AppButton(
              text: l10n.profileSetupApplyAction,
              width: double.infinity,
              borderRadius: AppRadius.circular,
              gradientColors: const [AppColors.secondary, AppColors.primary],
              onPressed: () => Navigator.of(context).pop(_selectedDate),
            ),
          ],
        ),
      ),
    );
  }
}
