import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/core/utils/app_utils/toast_utils.dart';
import 'package:drip_talk/core/utils/responsive/responsive_extensions.dart';
import 'package:drip_talk/core/utils/routes/route_paths.dart';
import 'package:drip_talk/features/chat/barrels/chat_barrels.dart';
import 'package:drip_talk/generated/assets.dart';
import 'package:drip_talk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
part 'widgets/chat_view_widgets.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late final TextEditingController _controller;
  late final FocusNode _inputFocusNode;
  bool _isSessionChoiceSheetOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _inputFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  void _handleBackPressed() {
    final router = GoRouter.of(context);
    if (router.canPop()) {
      router.pop();
      return;
    }

    context.go(RoutePaths.home);
  }

  Future<void> _handleAttachImages() async {
    final bloc = context.read<ChatBloc>();
    if (bloc.state.isBusy) {
      return;
    }

    _inputFocusNode.unfocus();
    FocusScope.of(context).unfocus();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (sheetContext) {
        return AppImagePicker(
          multiple: true,
          onPicked: (files) {
            final attachments = files
                .map(ChatAttachment.fromFile)
                .where((attachment) => attachment.isValid)
                .toList();

            if (attachments.isEmpty || !mounted) {
              return;
            }

            context.read<ChatBloc>().add(
              AddChatAttachmentsRequested(attachments: attachments),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final router = GoRouter.of(context);

    return PopScope(
      canPop: router.canPop(),
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _handleBackPressed();
        }
      },
      child: BlocListener<ChatBloc, ChatState>(
        listenWhen: (previous, current) =>
            previous.launchSheetMode != current.launchSheetMode &&
            current.launchSheetMode != ChatLaunchSheetMode.hidden,
        listener: (context, state) =>
            _showSessionChoiceSheet(state.launchSheetMode),
        child: AppResponsivePageLayout(
          mobileMaxWidth: 460,
          tabletMaxWidth: 760,
          tabletLargeMaxWidth: 900,
          desktopMaxWidth: 980,
          useSafeArea: false,
          showHeaderDivider: false,
          appBar: AppBar(
            backgroundColor: AppColors.transparent,
            centerTitle: true,
            leading: Padding(
              padding: AppPadding.allExtraSmall,
              child: GradientBorder(
                padding: AppPadding.allExtraSmall,
                onTap: _handleBackPressed,
                enableShadow: false,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                backgroundColor: AppColors.lightBg,
                borderRadius: AppRadius.r12,
                colors: const [AppColors.primary, AppColors.secondary],
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.surface,
                  size: AppSizes.s20,
                ),
              ),
            ),
            title: AppText(
              text: l10n.chatAppBarTitle,
              style: AppTextStyles.ts18(context, color: AppColors.pureWhite),
            ),
            actions: [
              GradientBorder(
                padding: AppPadding.allExtraSmall,
                onTap: () {},
                enableShadow: false,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                backgroundColor: AppColors.lightBg,
                borderRadius: AppRadius.r12,
                colors: const [AppColors.primary, AppColors.secondary],
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.surface,
                  size: AppSizes.s20,
                ),
              ),
              const AppGap(AppSizes.s8, axis: Axis.horizontal),
            ],
          ),
          pageBuilder: (context, _) => SafeArea(
            bottom: false,
            child: Column(
              children: [
                Expanded(child: const _ChatMessagesSection()),
                _InputArea(
                  controller: _controller,
                  focusNode: _inputFocusNode,
                  onAttachImages: _handleAttachImages,
                  onSend: _handleSend,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showSessionChoiceSheet(ChatLaunchSheetMode mode) async {
    if (_isSessionChoiceSheetOpen || !mounted) {
      return;
    }

    _isSessionChoiceSheetOpen = true;
    _inputFocusNode.unfocus();
    FocusScope.of(context).unfocus();

    final action = await ChatSessionChoiceSheet.show(context, mode: mode);
    _isSessionChoiceSheetOpen = false;

    if (!mounted || action == null) {
      return;
    }

    switch (action) {
      case ChatSessionChoiceAction.startNewChat:
        context.read<ChatBloc>().add(const StartNewChatRequested());
        break;
      case ChatSessionChoiceAction.continueOldChat:
        context.read<ChatBloc>().add(const ContinueOldChatRequested());
        break;
    }
  }

  Future<void> _handleSend() async {
    final bloc = context.read<ChatBloc>();
    final state = bloc.state;
    final draftMessage = _controller.text.trim();
    if (draftMessage.isEmpty && !state.hasComposerAttachments) {
      ToastUtils.show(
        context,
        AppLocalizations.of(context)!.chatTypeMessageOrAttachImageFirst,
        type: ToastType.error,
      );
      return;
    }

    if (state.isBusy) {
      return;
    }

    _inputFocusNode.unfocus();
    FocusScope.of(context).unfocus();

    final messageHints = const AiChatUserPreferences().withDerivedValues(
      draftMessage,
    );
    final resolvedPreferences = messageHints.mergeFallbacks(
      state.lastUsedPreferences,
    );

    AiChatUserPreferences? selectedPreferences;

    if (state.hasSavedPreferences) {
      selectedPreferences = resolvedPreferences;
    } else {
      selectedPreferences = await ChatPreferencesSheet.show(
        context,
        initialPreferences: resolvedPreferences,
      );
    }

    if (!mounted || selectedPreferences == null) {
      return;
    }

    bloc.add(
      SendMessageRequested(
        message: draftMessage,
        preferences: selectedPreferences,
      ),
    );
    _controller.clear();
  }
}
