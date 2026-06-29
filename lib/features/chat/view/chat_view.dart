import 'package:drip_talk/core/common/constants/constants_barrels.dart';
import 'package:drip_talk/core/common/widgets/widgets_barrels.dart';
import 'package:drip_talk/core/services/get_it/service_locator.dart';
import 'package:drip_talk/core/utils/app_utils/toast_utils.dart';
import 'package:drip_talk/core/utils/responsive/responsive_extensions.dart';
import 'package:drip_talk/core/utils/routes/route_paths.dart';
import 'package:drip_talk/core/utils/routes/auth_guard.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_session_repository.dart';
import 'package:drip_talk/features/chat/barrels/chat_barrels.dart';
import 'package:drip_talk/features/recommendations/view/widgets/recommendations_flow_sheet.dart';
import 'package:drip_talk/features/recommendations/view/widgets/recommendations_photo_upload_sheet.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isRecommendationsFlowOpen = false;

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

    context.go(RoutePaths.wardrobes);
  }

  Future<void> _handlePickImages() async {
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

  Future<void> _handleSelectMode() async {
    final bloc = context.read<ChatBloc>();
    final selectedMode = await showModalBottomSheet<ChatComposerMode>(
      context: context,
      backgroundColor: AppColors.transparent,
      builder: (sheetContext) =>
          _ComposerModeSheet(selectedMode: bloc.state.selectedMode),
    );

    if (!mounted || selectedMode == null) {
      return;
    }

    bloc.add(ChatComposerModeChanged(mode: selectedMode));
  }

  void _resetComposer() {
    _controller.clear();
    _inputFocusNode.unfocus();
    FocusScope.of(context).unfocus();
  }

  void _openSessionsDrawer() {
    final bloc = context.read<ChatBloc>();
    bloc.add(ChatSessionsRequested(silent: bloc.state.hasSessions));
    _scaffoldKey.currentState?.openDrawer();
  }

  void _startNewChat() {
    _resetComposer();
    context.read<ChatBloc>().add(const StartNewChatRequested());
  }

  void _openSession(int sessionId) {
    _resetComposer();
    context.read<ChatBloc>().add(
      ChatSessionOpenedRequested(sessionId: sessionId),
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
      child: MultiBlocListener(
        listeners: [
          BlocListener<ChatBloc, ChatState>(
            listenWhen: (previous, current) =>
                previous.requiresStartupRecommendations !=
                    current.requiresStartupRecommendations &&
                current.requiresStartupRecommendations,
            listener: (context, state) => _showStartupRecommendationsFlow(),
          ),
          BlocListener<ChatBloc, ChatState>(
            listenWhen: (previous, current) =>
                previous.sessionActionErrorMessage !=
                    current.sessionActionErrorMessage &&
                current.sessionActionErrorMessage != null,
            listener: (context, state) => ToastUtils.show(
              context,
              state.sessionActionErrorMessage!,
              type: ToastType.error,
            ),
          ),
        ],
        child: Scaffold(
          key: _scaffoldKey,
          extendBody: true,
          extendBodyBehindAppBar: true,
          backgroundColor: AppColors.transparent,
          drawer: _ChatSessionsDrawer(
            onNewChatRequested: _startNewChat,
            onSessionSelected: _openSession,
          ),
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
                onTap: _openSessionsDrawer,
                enableShadow: false,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                backgroundColor: AppColors.lightBg,
                borderRadius: AppRadius.r12,
                colors: const [AppColors.primary, AppColors.secondary],
                child: const Icon(
                  Icons.menu_rounded,
                  color: AppColors.surface,
                  size: AppSizes.s20,
                ),
              ),
              const AppGap(AppSizes.s8, axis: Axis.horizontal),
            ],
          ),
          body: AppResponsivePageLayout(
            mobileMaxWidth: 460,
            tabletMaxWidth: 760,
            tabletLargeMaxWidth: 900,
            desktopMaxWidth: 980,
            useSafeArea: false,
            showHeaderDivider: false,
            wrapWithScaffold: false,
            pageBuilder: (context, _) => SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Expanded(child: const _ChatMessagesSection()),
                  _InputArea(
                    controller: _controller,
                    focusNode: _inputFocusNode,
                    onSelectMode: _handleSelectMode,
                    onAttachImages: _handlePickImages,
                    onSend: _handleSend,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showStartupRecommendationsFlow() async {
    if (_isRecommendationsFlowOpen || !mounted) {
      return;
    }

    _isRecommendationsFlowOpen = true;
    _inputFocusNode.unfocus();
    FocusScope.of(context).unfocus();

    final action = await showRecommendationsFlowSheet(
      context,
      showCompletionStep: true,
    );
    _isRecommendationsFlowOpen = false;

    if (!mounted || action != RecommendationsFlowAction.openChat) {
      return;
    }

    final authSessionRepository = getIt<AuthSessionRepository>();
    await authSessionRepository.setRecommendationsFlowRequired(false);
    AuthGuard.completeRecommendationsFlow();
    if (!mounted) {
      return;
    }

    _startNewChat();
  }

  Future<void> _handleSend() async {
    final bloc = context.read<ChatBloc>();
    final state = bloc.state;
    final draftMessage = _controller.text.trim();
    final requestMessage =
        draftMessage.isEmpty && state.selectedMode == ChatComposerMode.generate
        ? 'Show me how this looks on me.'
        : draftMessage;
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

    bloc.add(
      SendMessageRequested(
        message: requestMessage,
        mode: state.selectedMode,
      ),
    );
    _controller.clear();
  }
}
