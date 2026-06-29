part of '../chat_view.dart';

class _ChatMessagesSection extends StatelessWidget {
  const _ChatMessagesSection();

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = context.responsive(
      16.0,
      tablet: 20.0,
      tabletLarge: 24.0,
      desktop: 28.0,
    );

    return BlocBuilder<ChatBloc, ChatState>(
      buildWhen: (previous, current) =>
          previous.messages != current.messages ||
          previous.isLoadingHistory != current.isLoadingHistory ||
          previous.isSending != current.isSending,
      builder: (context, state) {
        final hasLoadingBubble = state.isLoadingHistory || state.isSending;

        return ListView.builder(
          reverse: true,
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            AppSizes.s12,
            horizontalPadding,
            AppSizes.s20,
          ),
          itemCount: state.messages.length + (hasLoadingBubble ? 1 : 0),
          itemBuilder: (context, index) {
            if (hasLoadingBubble && index == 0) {
              return const TypingIndicator();
            }

            final messageIndex = hasLoadingBubble ? index - 1 : index;
            return ChatBubble(message: state.messages[messageIndex]);
          },
        );
      },
    );
  }
}

class _InputArea extends StatelessWidget {
  const _InputArea({
    required this.controller,
    required this.focusNode,
    required this.onSelectMode,
    required this.onAttachImages,
    required this.onSend,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final Future<void> Function() onSelectMode;
  final Future<void> Function() onAttachImages;
  final Future<void> Function() onSend;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final horizontalPadding = context.responsive(
      AppSizes.s16.toDouble(),
      tablet: 20.0,
      tabletLarge: 24.0,
      desktop: 28.0,
    );

    return BlocBuilder<ChatBloc, ChatState>(
      buildWhen: (previous, current) =>
          previous.isBusy != current.isBusy ||
          previous.selectedMode != current.selectedMode ||
          previous.composerAttachments != current.composerAttachments,
      builder: (context, state) {
        final modeHint = state.selectedMode == ChatComposerMode.generate
            ? 'Describe the look you want to generate'
            : l10n.chatSearchHint;

        return Container(
          padding: EdgeInsets.only(
            left: horizontalPadding,
            right: horizontalPadding,
            top: AppSizes.s12,
            bottom: MediaQuery.of(context).padding.bottom + AppSizes.s12,
          ),
          decoration: const BoxDecoration(
            color: AppColors.lightBg,
            border: Border(top: BorderSide(color: AppColors.pureWhite10)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (state.hasComposerAttachments) ...[
                _ComposerAttachmentsStrip(
                  attachments: state.composerAttachments,
                  onRemove: state.isBusy
                      ? null
                      : (attachmentId) {
                          context.read<ChatBloc>().add(
                            RemoveChatAttachmentRequested(
                              attachmentId: attachmentId,
                            ),
                          );
                        },
                ),
                const AppGap(AppSizes.s12),
              ],
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: AppSizes.s56,
                      ),
                      clipBehavior: Clip.antiAlias,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.s16,
                        vertical: AppSizes.s8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.pureWhite.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(AppRadius.r28),
                        border: Border.all(
                          color: AppColors.secondary.withValues(alpha: 0.45),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller,
                              focusNode: focusNode,
                              enabled: !state.isLoadingHistory,
                              minLines: 1,
                              maxLines: 4,
                              textAlignVertical: TextAlignVertical.center,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              style: AppTextStyles.ts14(
                                context,
                                color: AppColors.pureWhite,
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: InputDecoration(
                                hintText: modeHint,
                                hintStyle: AppTextStyles.ts14(
                                  context,
                                  color: AppColors.pureWhite.withValues(
                                    alpha: 0.35,
                                  ),
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: AppSizes.s10,
                                ),
                              ),
                            ),
                          ),
                          const AppGap(AppSizes.s10, axis: Axis.horizontal),
                          _ComposerInlineButton(
                            icon: Icons.camera_alt_outlined,
                            tooltip: l10n.chatAttachImages,
                            highlighted: state.hasComposerAttachments,
                            onTap: state.isBusy ? null : onAttachImages,
                          ),
                          const AppGap(AppSizes.s4, axis: Axis.horizontal),
                          _ComposerModeSelectorButton(
                            mode: state.selectedMode,
                            onTap: state.isBusy ? null : onSelectMode,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const AppGap(AppSizes.s12, axis: Axis.horizontal),
                  _ComposerActionButton(
                    assetPath: Assets.iconsSend,
                    tooltip: l10n.chatSendMessage,
                    gradient: const LinearGradient(
                      colors: [AppColors.secondary, AppColors.primary],
                    ),
                    onTap: state.isBusy ? null : onSend,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ComposerModePill extends StatelessWidget {
  const _ComposerModePill({required this.mode});

  final ChatComposerMode mode;

  @override
  Widget build(BuildContext context) {
    final accentColor = mode == ChatComposerMode.generate
        ? AppColors.secondary
        : AppColors.cyan;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.s12,
        vertical: AppSizes.s6,
      ),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadius.r20),
        border: Border.all(color: accentColor.withValues(alpha: 0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            mode == ChatComposerMode.generate
                ? Icons.auto_awesome_rounded
                : Icons.checkroom_rounded,
            size: AppSizes.s14,
            color: accentColor,
          ),
          const AppGap(AppSizes.s6, axis: Axis.horizontal),
          AppText(
            text: mode.label,
            variant: AppTextVariant.ts12,
            textColor: AppColors.pureWhite,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }
}

class _ComposerModeSelectorButton extends StatelessWidget {
  const _ComposerModeSelectorButton({required this.mode, this.onTap});

  final ChatComposerMode mode;
  final Future<void> Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final accentColor = mode == ChatComposerMode.generate
        ? AppColors.secondary
        : AppColors.cyan;
    final icon = mode == ChatComposerMode.generate
        ? Icons.auto_awesome_rounded
        : Icons.checkroom_rounded;
    final iconColor = onTap == null
        ? AppColors.pureWhite.withValues(alpha: 0.35)
        : accentColor;

    return Tooltip(
      message: 'Select mode',
      child: GestureDetector(
        onTap: onTap == null ? null : () => onTap!(),
        child: Container(
          width: AppSizes.s34,
          height: AppSizes.s34,
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(AppRadius.r16),
            border: Border.all(color: accentColor.withValues(alpha: 0.45)),
          ),
          child: Icon(icon, size: AppSizes.s20, color: iconColor),
        ),
      ),
    );
  }
}

class _ComposerAttachmentsStrip extends StatelessWidget {
  const _ComposerAttachmentsStrip({required this.attachments, this.onRemove});

  final List<ChatAttachment> attachments;
  final ValueChanged<String>? onRemove;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.s80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: attachments.length,
        separatorBuilder: (context, index) =>
            const AppGap(AppSizes.s10, axis: Axis.horizontal),
        itemBuilder: (context, index) {
          final attachment = attachments[index];
          return ChatAttachmentThumbnail(
            attachment: attachment,
            size: AppSizes.s80,
            onRemove: onRemove == null ? null : () => onRemove!(attachment.id),
          );
        },
      ),
    );
  }
}

class _ComposerInlineButton extends StatelessWidget {
  const _ComposerInlineButton({
    required this.icon,
    required this.tooltip,
    this.highlighted = false,
    this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final bool highlighted;
  final Future<void> Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final accentColor = highlighted ? AppColors.secondary : AppColors.pureWhite;
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap == null ? null : () => onTap!(),
        child: Container(
          width: AppSizes.s34,
          height: AppSizes.s34,
          decoration: BoxDecoration(
            color: AppColors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.r16),
          ),
          child: Icon(
            icon,
            size: AppSizes.s20,
            color: onTap == null
                ? AppColors.pureWhite.withValues(alpha: 0.35)
                : accentColor,
          ),
        ),
      ),
    );
  }
}

class _ComposerActionButton extends StatelessWidget {
  const _ComposerActionButton({
    this.icon,
    this.assetPath,
    required this.tooltip,
    this.gradient,
    this.onTap,
  }) : assert(icon != null || assetPath != null);

  final IconData? icon;
  final String? assetPath;
  final String tooltip;
  final Gradient? gradient;
  final Future<void> Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Opacity(
        opacity: onTap == null ? 0.72 : 1,
        child: GestureDetector(
          onTap: onTap == null ? null : () => onTap!(),
          child: Container(
            width: AppSizes.s50,
            height: AppSizes.s50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: gradient,
              color: gradient == null
                  ? AppColors.pureWhite.withValues(alpha: 0.05)
                  : null,
              border: gradient == null
                  ? Border.all(
                      color: AppColors.secondary.withValues(alpha: 0.45),
                    )
                  : null,
            ),
            child: Center(
              child: assetPath != null
                  ? AppAssetImage(
                      assetPath: assetPath!,
                      width: AppSizes.s18,
                      height: AppSizes.s18,
                    )
                  : Icon(icon, color: AppColors.pureWhite, size: AppSizes.s20),
            ),
          ),
        ),
      ),
    );
  }
}

class _ComposerModeSheet extends StatelessWidget {
  const _ComposerModeSheet({required this.selectedMode});

  final ChatComposerMode selectedMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.lightBg,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.r30),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSizes.s20,
        AppSizes.s16,
        AppSizes.s20,
        MediaQuery.of(context).padding.bottom + AppSizes.s20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: AppSizes.s56,
              height: AppSizes.s4,
              decoration: BoxDecoration(
                color: AppColors.pureWhite.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppRadius.circular),
              ),
            ),
          ),
          const AppGap(AppSizes.s18),
          AppText(
            text: 'Select chat mode',
            variant: AppTextVariant.ts18,
            textColor: AppColors.pureWhite,
            fontWeight: FontWeight.w800,
          ),
          const AppGap(AppSizes.s8),
          AppText(
            text:
                'Switch between wardrobe advice and image generation before you send the message.',
            style: AppTextStyles.ts14(
              context,
              color: AppColors.pureWhite.withValues(alpha: 0.72),
              fontWeight: FontWeight.w400,
            ),
            maxLines: 3,
          ),
          const AppGap(AppSizes.s20),
          _ComposerModeOption(
            mode: ChatComposerMode.wardrobe,
            selectedMode: selectedMode,
            title: 'Wardrobe',
            subtitle:
                'Use chat for outfit advice, wardrobe analysis, and product suggestions.',
            icon: Icons.checkroom_rounded,
          ),
          const AppGap(AppSizes.s12),
          _ComposerModeOption(
            mode: ChatComposerMode.generate,
            selectedMode: selectedMode,
            title: 'Generate',
            subtitle:
                'Send a prompt with images and receive progress updates while results are rendered.',
            icon: Icons.auto_awesome_rounded,
          ),
        ],
      ),
    );
  }
}

class _ComposerModeOption extends StatelessWidget {
  const _ComposerModeOption({
    required this.mode,
    required this.selectedMode,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final ChatComposerMode mode;
  final ChatComposerMode selectedMode;
  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final isSelected = mode == selectedMode;
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: () => Navigator.of(context).pop(mode),
        borderRadius: BorderRadius.circular(AppRadius.r24),
        child: Ink(
          padding: const EdgeInsets.all(AppSizes.s16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.r24),
            border: Border.all(
              color: isSelected
                  ? AppColors.secondary
                  : AppColors.pureWhite.withValues(alpha: 0.12),
            ),
            color: isSelected
                ? AppColors.secondary.withValues(alpha: 0.12)
                : AppColors.pureWhite.withValues(alpha: 0.03),
          ),
          child: Row(
            children: [
              Container(
                width: AppSizes.s44,
                height: AppSizes.s44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.pureWhite.withValues(alpha: 0.06),
                ),
                child: Icon(
                  icon,
                  color: AppColors.pureWhite,
                  size: AppSizes.s22,
                ),
              ),
              const AppGap(AppSizes.s12, axis: Axis.horizontal),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: title,
                      variant: AppTextVariant.ts16,
                      textColor: AppColors.pureWhite,
                      fontWeight: FontWeight.w700,
                    ),
                    const AppGap(AppSizes.s4),
                    AppText(
                      text: subtitle,
                      style: AppTextStyles.ts12(
                        context,
                        color: AppColors.pureWhite.withValues(alpha: 0.72),
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.secondary,
                  size: AppSizes.s22,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatSessionsDrawer extends StatelessWidget {
  const _ChatSessionsDrawer({
    required this.onNewChatRequested,
    required this.onSessionSelected,
  });

  final VoidCallback onNewChatRequested;
  final ValueChanged<int> onSessionSelected;

  @override
  Widget build(BuildContext context) {
    final drawerWidth = (MediaQuery.of(context).size.width * 0.86)
        .clamp(0.0, 360.0)
        .toDouble();
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      width: drawerWidth,
      child: Drawer(
        elevation: 0,
        backgroundColor: AppColors.transparent,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.responsiveGradientTop,
                AppColors.responsiveGradientMiddle,
                AppColors.responsiveGradientBottom,
              ],
            ),
            border: Border(
              right: BorderSide(
                color: AppColors.pureWhite.withValues(alpha: 0.08),
              ),
            ),
          ),
          child: SafeArea(
            child: BlocBuilder<ChatBloc, ChatState>(
              buildWhen: (previous, current) =>
                  previous.sessions != current.sessions ||
                  previous.sessionId != current.sessionId ||
                  previous.isLoadingSessions != current.isLoadingSessions ||
                  previous.deletingSessionId != current.deletingSessionId ||
                  previous.isLoadingHistory != current.isLoadingHistory ||
                  previous.isSending != current.isSending,
              builder: (context, state) {
                final canInteract =
                    !state.isBusy && state.deletingSessionId == null;

                return Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.s16,
                    AppSizes.s18,
                    AppSizes.s16,
                    AppSizes.s12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: AppSizes.s44,
                            height: AppSizes.s44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.pureWhite.withValues(
                                alpha: 0.08,
                              ),
                              border: Border.all(
                                color: AppColors.secondary.withValues(
                                  alpha: 0.28,
                                ),
                              ),
                            ),
                            child: const Icon(
                              Icons.history_rounded,
                              color: AppColors.pureWhite,
                              size: AppSizes.s22,
                            ),
                          ),
                          const AppGap(AppSizes.s12, axis: Axis.horizontal),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  text: l10n.chatAppBarTitle,
                                  style: AppTextStyles.ts18(
                                    context,
                                    color: AppColors.pureWhite,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 1,
                                ),
                                const AppGap(AppSizes.s4),
                                AppText(
                                  text:
                                      'Open previous conversations or start a fresh chat.',
                                  style: AppTextStyles.ts12(
                                    context,
                                    color: AppColors.pureWhite.withValues(
                                      alpha: 0.64,
                                    ),
                                  ),
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(
                              Icons.close_rounded,
                              color: AppColors.pureWhite70,
                            ),
                          ),
                        ],
                      ),
                      const AppGap(AppSizes.s18),
                      AppButton(
                        text: l10n.chatStartNewChat,
                        onPressed: canInteract
                            ? () {
                                Navigator.of(context).pop();
                                onNewChatRequested();
                              }
                            : null,
                        height: AppSizes.s55,
                        borderRadius: AppRadius.r20,
                        gradientColors: const [
                          AppColors.secondary,
                          AppColors.primary,
                        ],
                        leadingIcon: const Icon(
                          Icons.add_comment_rounded,
                          color: AppColors.pureWhite,
                          size: AppSizes.s18,
                        ),
                      ),
                      const AppGap(AppSizes.s16),
                      if (state.isLoadingSessions)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSizes.s12),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              AppRadius.circular,
                            ),
                            child: const LinearProgressIndicator(
                              minHeight: AppSizes.s4,
                              color: AppColors.secondary,
                              backgroundColor: AppColors.pureWhite12,
                            ),
                          ),
                        ),
                      Expanded(
                        child: state.sessions.isEmpty
                            ? _ChatSessionsEmptyState(
                                isLoading: state.isLoadingSessions,
                              )
                            : ListView.separated(
                                padding: EdgeInsets.zero,
                                physics: const BouncingScrollPhysics(),
                                itemCount: state.sessions.length,
                                separatorBuilder: (_, index) =>
                                    const AppGap(AppSizes.s10),
                                itemBuilder: (context, index) {
                                  final session = state.sessions[index];
                                  final sessionId = session.id;
                                  final isActive =
                                      sessionId != null &&
                                      sessionId == state.sessionId;
                                  final isDeleting =
                                      sessionId != null &&
                                      sessionId == state.deletingSessionId;

                                  return _ChatSessionTile(
                                    session: session,
                                    isActive: isActive,
                                    isDeleting: isDeleting,
                                    enabled: canInteract,
                                    onTap: sessionId == null
                                        ? null
                                        : () {
                                            Navigator.of(context).pop();
                                            if (!isActive) {
                                              onSessionSelected(sessionId);
                                            }
                                          },
                                    onDelete: sessionId == null || isDeleting
                                        ? null
                                        : () => _confirmDeleteSession(
                                            context,
                                            session,
                                          ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDeleteSession(
    BuildContext context,
    ChatSessionSummary session,
  ) async {
    final sessionId = session.id;
    if (sessionId == null) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AppDialog(
        title: 'Delete chat',
        description: 'This conversation will be removed from your history.',
        primaryButtonText: l10n.deleteAction,
        onPrimaryPressed: () => Navigator.of(dialogContext).pop(true),
        secondaryButtonText: l10n.cancel,
        onSecondaryPressed: () => Navigator.of(dialogContext).pop(false),
        icon: Icons.delete_outline_rounded,
        iconColor: AppColors.materialRedAccent,
      ),
    );

    if (shouldDelete != true || !context.mounted) {
      return;
    }

    context.read<ChatBloc>().add(
      ChatSessionDeletedRequested(sessionId: sessionId),
    );
  }
}

class _ChatSessionsEmptyState extends StatelessWidget {
  const _ChatSessionsEmptyState({required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.s16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppSizes.s72,
              height: AppSizes.s72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.pureWhite.withValues(alpha: 0.06),
                border: Border.all(
                  color: AppColors.secondary.withValues(alpha: 0.2),
                ),
              ),
              child: isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(AppSizes.s20),
                      child: CircularProgressIndicator(
                        strokeWidth: AppSizes.s2,
                        color: AppColors.secondary,
                      ),
                    )
                  : const Icon(
                      Icons.forum_outlined,
                      color: AppColors.pureWhite54,
                      size: AppSizes.s30,
                    ),
            ),
            const AppGap(AppSizes.s16),
            AppText(
              text: isLoading ? 'Loading chats...' : 'No chat history yet',
              variant: AppTextVariant.ts18,
              textColor: AppColors.pureWhite,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
            const AppGap(AppSizes.s8),
            AppText(
              text: isLoading
                  ? 'Fetching your saved conversations.'
                  : 'Your previous conversations will appear here after you start chatting.',
              style: AppTextStyles.ts12(
                context,
                color: AppColors.pureWhite.withValues(alpha: 0.64),
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatSessionTile extends StatelessWidget {
  const _ChatSessionTile({
    required this.session,
    required this.isActive,
    required this.isDeleting,
    required this.enabled,
    this.onTap,
    this.onDelete,
  });

  final ChatSessionSummary session;
  final bool isActive;
  final bool isDeleting;
  final bool enabled;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final preview = session.resolvedPreview;
    final meta = _formatSessionMeta(session);

    return Opacity(
      opacity: enabled || isDeleting ? 1 : 0.72,
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.r20),
          onTap: enabled ? onTap : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(AppSizes.s14),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.pureWhite.withValues(alpha: 0.1)
                  : AppColors.pureWhite.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(AppRadius.r20),
              border: Border.all(
                color: isActive
                    ? AppColors.secondary.withValues(alpha: 0.55)
                    : AppColors.pureWhite.withValues(alpha: 0.08),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AppSizes.s40,
                  height: AppSizes.s40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: isActive
                        ? const LinearGradient(
                            colors: [AppColors.secondary, AppColors.primary],
                          )
                        : null,
                    color: isActive
                        ? null
                        : AppColors.pureWhite.withValues(alpha: 0.06),
                  ),
                  child: Icon(
                    isActive
                        ? Icons.chat_bubble_rounded
                        : Icons.chat_bubble_outline_rounded,
                    color: AppColors.pureWhite,
                    size: AppSizes.s18,
                  ),
                ),
                const AppGap(AppSizes.s12, axis: Axis.horizontal),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: session.resolvedTitle,
                        style: AppTextStyles.ts14(
                          context,
                          color: AppColors.pureWhite,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                      ),
                      if (preview != null) ...[
                        const AppGap(AppSizes.s6),
                        AppText(
                          text: preview,
                          style: AppTextStyles.ts12(
                            context,
                            color: AppColors.pureWhite.withValues(alpha: 0.68),
                          ),
                          maxLines: 2,
                        ),
                      ],
                      if (meta != null) ...[
                        const AppGap(AppSizes.s8),
                        AppText(
                          text: meta,
                          style: AppTextStyles.ts10(
                            context,
                            color: AppColors.pureWhite.withValues(alpha: 0.48),
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ],
                  ),
                ),
                const AppGap(AppSizes.s8, axis: Axis.horizontal),
                SizedBox(
                  width: AppSizes.s32,
                  height: AppSizes.s32,
                  child: isDeleting
                      ? const Padding(
                          padding: EdgeInsets.all(AppSizes.s6),
                          child: CircularProgressIndicator(
                            strokeWidth: AppSizes.s2,
                            color: AppColors.secondary,
                          ),
                        )
                      : IconButton(
                          padding: EdgeInsets.zero,
                          tooltip: AppLocalizations.of(context)!.deleteAction,
                          onPressed: enabled ? onDelete : null,
                          icon: Icon(
                            Icons.delete_outline_rounded,
                            color: AppColors.pureWhite.withValues(alpha: 0.72),
                            size: AppSizes.s18,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String? _formatSessionMeta(ChatSessionSummary session) {
  final parts = <String>[];
  final relativeTime = _formatRelativeSessionTime(session.sortDate);
  if (relativeTime != null) {
    parts.add(relativeTime);
  }

  final messagesCount = session.messagesCount;
  if (messagesCount != null && messagesCount > 0) {
    parts.add('$messagesCount ${messagesCount == 1 ? 'message' : 'messages'}');
  }

  return parts.isEmpty ? null : parts.join(' • ');
}

String? _formatRelativeSessionTime(DateTime? dateTime) {
  if (dateTime == null) {
    return null;
  }

  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inMinutes < 1) {
    return 'Just now';
  }

  if (difference.inHours < 1) {
    return '${difference.inMinutes}m ago';
  }

  if (difference.inDays < 1) {
    return '${difference.inHours}h ago';
  }

  if (difference.inDays == 1) {
    return 'Yesterday';
  }

  if (difference.inDays < 7) {
    return '${difference.inDays}d ago';
  }

  return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
}
