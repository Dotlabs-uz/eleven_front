// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/services.dart';

import 'package:flutter/src/material/button_style.dart';
import 'package:flutter/src/material/color_scheme.dart';
import 'package:flutter/src/material/colors.dart';
import 'package:flutter/src/material/constants.dart';
import 'package:flutter/src/material/divider.dart';
import 'package:flutter/src/material/divider_theme.dart';
import 'package:flutter/src/material/icon_button.dart';
import 'package:flutter/src/material/icons.dart';
import 'package:flutter/src/material/ink_well.dart';
import 'package:flutter/src/material/input_border.dart';
import 'package:flutter/src/material/input_decorator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/material_state.dart';
import 'package:flutter/src/material/search_bar_theme.dart';
import 'package:flutter/src/material/search_view_theme.dart';
import 'package:flutter/src/material/text_field.dart';
import 'package:flutter/src/material/text_theme.dart';
import 'package:flutter/src/material/theme.dart';
import 'package:flutter/src/material/theme_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/management/presentation/cubit/customer/customer_cubit.dart';

const int _kOpenViewMilliseconds = 500;
const Duration _kOpenViewDuration =
Duration(milliseconds: _kOpenViewMilliseconds);
const Duration _kAnchorFadeDuration = Duration(milliseconds: 150);
const Curve _kViewFadeOnInterval = Interval(0.0, 1 / 2);
const Curve _kViewIconsFadeOnInterval = Interval(1 / 6, 2 / 6);
const Curve _kViewDividerFadeOnInterval = Interval(0.0, 1 / 6);
const Curve _kViewListFadeOnInterval =
Interval(133 / _kOpenViewMilliseconds, 233 / _kOpenViewMilliseconds);

/// Signature for a function that creates a [Widget] which is used to open a search view.
///
/// The `controller` callback provided to [SearchAnchor.builder] can be used
/// to open the search view and control the editable field on the view.
typedef SearchAnchorChildBuilder = Widget Function(
    BuildContext context, SearchController controller);

/// Signature for a function that creates a [Widget] to build the suggestion list
/// based on the input in the search bar.
///
/// The `controller` callback provided to [SearchAnchor.suggestionsBuilder] can be used
/// to close the search view and control the editable field on the view.
typedef SuggestionsBuilder = FutureOr<Widget> Function(
    BuildContext context, SearchController controller);

/// Signature for a function that creates a [Widget] to layout the suggestion list.
///
/// Parameter `suggestions` is the content list that this function wants to lay out.
typedef ViewBuilder = Widget Function(Iterable<Widget> suggestions);



class SearchAnchor extends StatefulWidget {
  /// Creates a const [SearchAnchor].
  ///
  /// The [builder] and [suggestionsBuilder] arguments are required.
  const SearchAnchor({
    super.key,
    this.isFullScreen,
    this.searchController,
    this.viewBuilder,
    this.viewLeading,
    this.viewTrailing,
    this.viewHintText,
    this.viewBackgroundColor,
    this.viewElevation,
    this.viewSurfaceTintColor,
    this.viewSide,
    this.viewShape,
    this.headerTextStyle,
    this.headerHintStyle,
    this.dividerColor,
    this.viewConstraints,
    this.textCapitalization,
    required this.inputFormatters,
    required this.builder,
    required this.suggestionsBuilder,
  });


  factory SearchAnchor.bar({
    Widget? barLeading,
    Iterable<Widget>? barTrailing,
    String? barHintText,
    GestureTapCallback? onTap,
    MaterialStateProperty<double?>? barElevation,
    MaterialStateProperty<Color?>? barBackgroundColor,
    MaterialStateProperty<Color?>? barOverlayColor,
    MaterialStateProperty<BorderSide?>? barSide,
    MaterialStateProperty<OutlinedBorder?>? barShape,
    MaterialStateProperty<EdgeInsetsGeometry?>? barPadding,
    MaterialStateProperty<TextStyle?>? barTextStyle,
    MaterialStateProperty<TextStyle?>? barHintStyle,
    Widget? viewLeading,
    Iterable<Widget>? viewTrailing,
    String? viewHintText,
    Color? viewBackgroundColor,
    double? viewElevation,
    BorderSide? viewSide,
    OutlinedBorder? viewShape,
    TextStyle? viewHeaderTextStyle,
    TextStyle? viewHeaderHintStyle,
    Color? dividerColor,
    BoxConstraints? constraints,
    BoxConstraints? viewConstraints,
    bool? isFullScreen,
    SearchController searchController,
    TextCapitalization textCapitalization,
    required List<TextInputFormatter> inputFormatters,
    required SuggestionsBuilder suggestionsBuilder,
  }) = _SearchAnchorWithSearchBar;

  /// Whether the search view grows to fill the entire screen when the
  /// [SearchAnchor] is tapped.
  ///
  /// By default, the search view is full-screen on mobile devices. On other
  /// platforms, the search view only grows to a specific size that is determined
  /// by the anchor and the default size.
  final bool? isFullScreen;

  /// An optional controller that allows opening and closing of the search view from
  /// other widgets.
  ///
  /// If this is null, one internal search controller is created automatically
  /// and it is used to open the search view when the user taps on the anchor.
  final SearchController? searchController;

  /// Optional callback to obtain a widget to lay out the suggestion list of the
  /// search view.
  ///
  /// Default view uses a [ListView] with a vertical scroll direction.
  final ViewBuilder? viewBuilder;

  /// An optional widget to display before the text input field when the search
  /// view is open.
  ///
  /// Typically the [viewLeading] widget is an [Icon] or an [IconButton].
  ///
  /// Defaults to a back button which pops the view.
  final Widget? viewLeading;

  /// An optional widget list to display after the text input field when the search
  /// view is open.
  ///
  /// Typically the [viewTrailing] widget list only has one or two widgets.
  ///
  /// Defaults to an icon button which clears the text in the input field.
  final Iterable<Widget>? viewTrailing;

  /// Text that is displayed when the search bar's input field is empty.
  final String? viewHintText;

  /// The search view's background fill color.
  ///
  /// If null, the value of [SearchViewThemeData.backgroundColor] will be used.
  /// If this is also null, then the default value is [ColorScheme.surface].
  final Color? viewBackgroundColor;

  /// The elevation of the search view's [Material].
  ///
  /// If null, the value of [SearchViewThemeData.elevation] will be used. If this
  /// is also null, then default value is 6.0.
  final double? viewElevation;

  /// The surface tint color of the search view's [Material].
  ///
  /// See [Material.surfaceTintColor] for more details.
  ///
  /// If null, the value of [SearchViewThemeData.surfaceTintColor] will be used.
  /// If this is also null, then the default value is [ColorScheme.surfaceTint].
  final Color? viewSurfaceTintColor;

  /// The color and weight of the search view's outline.
  ///
  /// This value is combined with [viewShape] to create a shape decorated
  /// with an outline. This will be ignored if the view is full-screen.
  ///
  /// If null, the value of [SearchViewThemeData.side] will be used. If this is
  /// also null, the search view doesn't have a side by default.
  final BorderSide? viewSide;

  /// The shape of the search view's underlying [Material].
  ///
  /// This shape is combined with [viewSide] to create a shape decorated
  /// with an outline.
  ///
  /// If null, the value of [SearchViewThemeData.shape] will be used.
  /// If this is also null, then the default value is a rectangle shape for full-screen
  /// mode and a [RoundedRectangleBorder] shape with a 28.0 radius otherwise.
  final OutlinedBorder? viewShape;

  /// The style to use for the text being edited on the search view.
  ///
  /// If null, defaults to the `bodyLarge` text style from the current [Theme].
  /// The default text color is [ColorScheme.onSurface].
  final TextStyle? headerTextStyle;

  /// The style to use for the [viewHintText] on the search view.
  ///
  /// If null, the value of [SearchViewThemeData.headerHintStyle] will be used.
  /// If this is also null, the value of [headerTextStyle] will be used. If this is also null,
  /// defaults to the `bodyLarge` text style from the current [Theme]. The default
  /// text color is [ColorScheme.onSurfaceVariant].
  final TextStyle? headerHintStyle;

  /// The color of the divider on the search view.
  ///
  /// If this property is null, then [SearchViewThemeData.dividerColor] is used.
  /// If that is also null, the default value is [ColorScheme.outline].
  final Color? dividerColor;


  final BoxConstraints? viewConstraints;

  final TextCapitalization? textCapitalization;


  final SearchAnchorChildBuilder builder;


  final SuggestionsBuilder suggestionsBuilder;

  final List<TextInputFormatter> inputFormatters;

  @override
  State<SearchAnchor> createState() => _SearchAnchorState();
}

class _SearchAnchorState extends State<SearchAnchor> {
  Size? _screenSize;
  bool _anchorIsVisible = true;
  final GlobalKey _anchorKey = GlobalKey();
  bool get _viewIsOpen => !_anchorIsVisible;
  late SearchController? _internalSearchController;
  SearchController get _searchController =>
      widget.searchController ?? _internalSearchController!;

  @override
  void initState() {
    intialize();
    super.initState();
  }

  intialize() {
    if (widget.searchController == null) {
      _internalSearchController = SearchController();
    }
    _searchController._attach(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Size updatedScreenSize = MediaQuery.of(context).size;
    if (_screenSize != null && _screenSize != updatedScreenSize) {
      if (_searchController.isOpen && !getShowFullScreenView()) {
        _closeView(null);
      }
    }
    _screenSize = updatedScreenSize;
  }

  @override
  void dispose() {
    super.dispose();
    _searchController._detach(this);
    _internalSearchController = null;
  }

  void _openView() {
    final NavigatorState navigator = Navigator.of(context);
    navigator.push(_SearchViewRoute(
      inputFormatters: widget.inputFormatters,
      viewLeading: widget.viewLeading,
      viewTrailing: widget.viewTrailing,
      viewHintText: widget.viewHintText,
      viewBackgroundColor: widget.viewBackgroundColor,
      viewElevation: widget.viewElevation,
      viewSurfaceTintColor: widget.viewSurfaceTintColor,
      viewSide: widget.viewSide,
      viewShape: widget.viewShape,
      viewHeaderTextStyle: widget.headerTextStyle,
      viewHeaderHintStyle: widget.headerHintStyle,
      dividerColor: widget.dividerColor,
      viewConstraints: widget.viewConstraints,
      showFullScreenView: getShowFullScreenView(),
      toggleVisibility: toggleVisibility,
      textDirection: Directionality.of(context),
      viewBuilder: widget.viewBuilder,
      anchorKey: _anchorKey,
      searchController: _searchController,
      suggestionsBuilder: widget.suggestionsBuilder,
      textCapitalization: widget.textCapitalization,
      capturedThemes:
      InheritedTheme.capture(from: context, to: navigator.context),
    ));
  }

  void _closeView(String? selectedText) {
    if (selectedText != null) {
      _searchController.text = selectedText;
    }
    Navigator.of(context).pop();
  }

  bool toggleVisibility() {
    setState(() {
      _anchorIsVisible = !_anchorIsVisible;
    });
    return _anchorIsVisible;
  }

  bool getShowFullScreenView() {
    if (widget.isFullScreen != null) {
      return widget.isFullScreen!;
    }

    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return true;
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      key: _anchorKey,
      opacity: _anchorIsVisible ? 1.0 : 0.0,
      duration: _kAnchorFadeDuration,
      child: GestureDetector(
        onTap: _openView,
        child: widget.builder(context, _searchController),
      ),
    );
  }
}

class _SearchViewRoute extends PopupRoute<_SearchViewRoute> {

  _SearchViewRoute({
    this.toggleVisibility,
    this.textDirection,
    required this.inputFormatters,
    this.viewBuilder,
    this.viewLeading,
    this.viewTrailing,
    this.viewHintText,
    this.viewBackgroundColor,
    this.viewElevation,
    this.viewSurfaceTintColor,
    this.viewSide,
    this.viewShape,
    this.viewHeaderTextStyle,
    this.viewHeaderHintStyle,
    this.dividerColor,
    this.viewConstraints,
    this.textCapitalization,
    required this.showFullScreenView,
    required this.anchorKey,
    required this.searchController,
    required this.suggestionsBuilder,
    required this.capturedThemes,
  });

  final ValueGetter<bool>? toggleVisibility;
  final TextDirection? textDirection;
  final ViewBuilder? viewBuilder;
  final Widget? viewLeading;
  final Iterable<Widget>? viewTrailing;
  final List<TextInputFormatter> inputFormatters;
  final String? viewHintText;
  final Color? viewBackgroundColor;
  final double? viewElevation;
  final Color? viewSurfaceTintColor;
  final BorderSide? viewSide;
  final OutlinedBorder? viewShape;
  final TextStyle? viewHeaderTextStyle;
  final TextStyle? viewHeaderHintStyle;
  final Color? dividerColor;
  final BoxConstraints? viewConstraints;
  final TextCapitalization? textCapitalization;
  final bool showFullScreenView;
  final GlobalKey anchorKey;
  final SearchController searchController;
  final SuggestionsBuilder suggestionsBuilder;
  final CapturedThemes capturedThemes;

  @override
  Color? get barrierColor => Colors.transparent;

  @override
  bool get barrierDismissible => true;

  @override
  bool get allowSnapshotting => true;

  @override
  String? get barrierLabel => 'Dismiss';

  late final SearchViewThemeData viewDefaults;
  late final SearchViewThemeData viewTheme;
  final RectTween _rectTween = RectTween();

  Rect? getRect() {
    final BuildContext? context = anchorKey.currentContext;
    if (context != null) {
      final RenderBox searchBarBox = context.findRenderObject()! as RenderBox;
      final Size boxSize = searchBarBox.size;
      final NavigatorState navigator = Navigator.of(context);
      final Offset boxLocation = searchBarBox.localToGlobal(Offset.zero,
          ancestor: navigator.context.findRenderObject());
      return boxLocation & boxSize;
    }
    return null;
  }

  @override
  TickerFuture didPush() {
    assert(anchorKey.currentContext != null);
    updateViewConfig(anchorKey.currentContext!);
    updateTweens(anchorKey.currentContext!);
    toggleVisibility?.call();
    return super.didPush();
  }

  @override
  bool didPop(_SearchViewRoute? result) {
    assert(anchorKey.currentContext != null);
    updateTweens(anchorKey.currentContext!);
    toggleVisibility?.call();
    return super.didPop(result);
  }

  void updateViewConfig(BuildContext context) {
    viewDefaults =
        _SearchViewDefaultsM3(context, isFullScreen: showFullScreenView);
    viewTheme = SearchViewTheme.of(context);
    updateTweens(anchorKey.currentContext!);
  }

  void updateTweens(BuildContext context) {
    final RenderBox navigator =
    Navigator.of(context).context.findRenderObject()! as RenderBox;
    final Size screenSize = navigator.size;
    final Rect anchorRect = getRect() ?? Rect.zero;

    BoxConstraints effectiveConstraints =
        viewConstraints ?? viewTheme.constraints ?? viewDefaults.constraints!;
    _rectTween.begin = anchorRect;
    // effectiveConstraints = BoxConstraints(minWidth:  viewConstraints?.minWidth ?? 100 ,maxWidth:  viewConstraints?.maxWidth ?? 100, maxHeight: 50 + ( listItemInMenu.length * 50) );

    final double viewWidth = clampDouble(anchorRect.width,
        effectiveConstraints.minWidth, effectiveConstraints.maxWidth);
    final double viewHeight = clampDouble(screenSize.height * 2 / 3,
        effectiveConstraints.minHeight, effectiveConstraints.maxHeight);

    switch (textDirection ?? TextDirection.ltr) {
      case TextDirection.ltr:
        final double viewLeftToScreenRight = screenSize.width - anchorRect.left;
        final double viewTopToScreenBottom = screenSize.height - anchorRect.top;

        // Make sure the search view doesn't go off the screen. If the search view
        // doesn't fit, move the top-left corner of the view to fit the window.
        // If the window is smaller than the view, then we resize the view to fit the window.
        Offset topLeft = anchorRect.topLeft;
        if (viewLeftToScreenRight < viewWidth) {
          topLeft = Offset(
              screenSize.width - math.min(viewWidth, screenSize.width),
              topLeft.dy);
        }
        if (viewTopToScreenBottom < viewHeight) {
          topLeft = Offset(topLeft.dx,
              screenSize.height - math.min(viewHeight, screenSize.height));
        }
        final Size endSize = Size(viewWidth, viewHeight);
        _rectTween.end =
        showFullScreenView ? Offset.zero & screenSize : (topLeft & endSize);
        return;
      case TextDirection.rtl:
        final double viewRightToScreenLeft = anchorRect.right;
        final double viewTopToScreenBottom = screenSize.height - anchorRect.top;

        // Make sure the search view doesn't go off the screen.
        Offset topLeft =
        Offset(math.max(anchorRect.right - viewWidth, 0.0), anchorRect.top);
        if (viewRightToScreenLeft < viewWidth) {
          topLeft = Offset(0.0, topLeft.dy);
        }
        if (viewTopToScreenBottom < viewHeight) {
          topLeft = Offset(topLeft.dx,
              screenSize.height - math.min(viewHeight, screenSize.height));
        }
        final Size endSize = Size(viewWidth, viewHeight);
        _rectTween.end =
        showFullScreenView ? Offset.zero & screenSize : (topLeft & endSize);
    }
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Directionality(
      textDirection: textDirection ?? TextDirection.ltr,
      child: AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget? child) {
            final Animation<double> curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubicEmphasized,
              reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
            );

            final Rect viewRect = _rectTween.evaluate(curvedAnimation)!;
            final double topPadding = showFullScreenView
                ? lerpDouble(0.0, MediaQuery.paddingOf(context).top,
                curvedAnimation.value)!
                : 0.0;

            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: _kViewFadeOnInterval,
                reverseCurve: _kViewFadeOnInterval.flipped,
              ),
              child: capturedThemes.wrap(
                _ViewContent(
                  viewLeading: viewLeading,
                  viewTrailing: viewTrailing,
                  inputFormatters: inputFormatters,
                  viewHintText: viewHintText,
                  viewBackgroundColor: viewBackgroundColor,
                  viewElevation: viewElevation,
                  viewSurfaceTintColor: viewSurfaceTintColor,
                  viewSide: viewSide,
                  viewShape: viewShape,
                  viewHeaderTextStyle: viewHeaderTextStyle,
                  viewHeaderHintStyle: viewHeaderHintStyle,
                  dividerColor: dividerColor,
                  showFullScreenView: showFullScreenView,
                  animation: curvedAnimation,
                  topPadding: topPadding,
                  viewMaxWidth: _rectTween.end!.width,
                  viewRect: viewRect,
                  viewBuilder: viewBuilder,
                  searchController: searchController,
                  suggestionsBuilder: suggestionsBuilder,
                  textCapitalization: textCapitalization,
                ),
              ),
            );
          }),
    );
  }

  @override
  Duration get transitionDuration => _kOpenViewDuration;
}

class _ViewContent extends StatefulWidget {
  const _ViewContent({
    this.viewBuilder,
    this.viewLeading,
    this.viewTrailing,
    this.viewHintText,
    this.viewBackgroundColor,
    this.viewElevation,
    this.viewSurfaceTintColor,
    this.viewSide,
    this.viewShape,
    this.viewHeaderTextStyle,
    this.viewHeaderHintStyle,
    this.dividerColor,
    this.textCapitalization,
    required this.showFullScreenView,
    required this.topPadding,
    required this.animation,
    required this.viewMaxWidth,
    required this.viewRect,
    required this.searchController,
    required this.suggestionsBuilder,
    required this.inputFormatters,
  });

  final ViewBuilder? viewBuilder;
  final Widget? viewLeading;
  final Iterable<Widget>? viewTrailing;
  final String? viewHintText;
  final Color? viewBackgroundColor;
  final double? viewElevation;
  final Color? viewSurfaceTintColor;
  final BorderSide? viewSide;
  final OutlinedBorder? viewShape;
  final TextStyle? viewHeaderTextStyle;
  final TextStyle? viewHeaderHintStyle;
  final Color? dividerColor;
  final TextCapitalization? textCapitalization;
  final bool showFullScreenView;
  final double topPadding;
  final Animation<double> animation;
  final double viewMaxWidth;
  final Rect viewRect;
  final SearchController searchController;
  final SuggestionsBuilder suggestionsBuilder;
  final List<TextInputFormatter> inputFormatters;

  @override
  State<_ViewContent> createState() => _ViewContentState();
}

class _ViewContentState extends State<_ViewContent> {
  Size? _screenSize;
  late Rect _viewRect;
  late final SearchController _controller;
  Widget result = const SizedBox();
  final FocusNode _focusNode = FocusNode();
  final double maxMenuHeight = 680;
  final double minMenuHeight = 320;

  @override
  void initState() {
    _viewRect =   Rect.fromLTRB(
        widget.viewRect.left, widget.viewRect.top, widget.viewRect.right, minMenuHeight);
    if(mounted) {
      Future.delayed(Duration.zero, () {
        setState(() {

        });
      },);

    }

    _controller = widget.searchController;
    if (!_focusNode.hasFocus) {
      _focusNode.requestFocus();
    }
    super.initState();

    BlocProvider.of<CustomerCubit>(context).stream.listen((state) {
      if (state is CustomerLoaded) {
        final listItems = state.data;

        final double calc = minMenuHeight + listItems.length * 50;

        final double bottom = calc > maxMenuHeight ? maxMenuHeight : calc;

        if (mounted) {
          Future.delayed(
            Duration.zero,
            () {
              setState(() {
                  _viewRect = Rect.fromLTRB(
                      widget.viewRect.left, _viewRect.top, _viewRect.right, bottom);
                  log("View rect calculated  ${bottom} left right ${_viewRect.left} ${_viewRect.right} elements count ${listItems.length} ${_viewRect.width}");


              });
            },
          );
        }
      }
      if(state is InitialSize) {
        if(mounted) {
          Future.delayed(Duration.zero,() {
            setState(() {
              _viewRect =   Rect.fromLTRB(
                  widget.viewRect.left, widget.viewRect.top, widget.viewRect.right, minMenuHeight);
            });
          },);
        }
      }
    });
  }

  @override
  void didUpdateWidget(covariant _ViewContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.viewRect != oldWidget.viewRect) {
      _viewRect = widget.viewRect;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Size updatedScreenSize = MediaQuery.of(context).size;

    if (_screenSize != updatedScreenSize) {
      _screenSize = updatedScreenSize;
      if (widget.showFullScreenView) {
        _viewRect = Offset.zero & _screenSize!;
      }
    }
    unawaited(updateSuggestions());
  }

  Widget viewBuilder(Iterable<Widget> suggestions) {
    if (widget.viewBuilder == null) {
      return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(children: suggestions.toList()),
      );
    }
    return widget.viewBuilder!(suggestions);
  }

  Future<void> updateSuggestions() async {
    final Widget suggestions =
    await widget.suggestionsBuilder(context, _controller);
    if (mounted) {
      setState(() {
        result = suggestions;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget defaultLeading = IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.of(context).pop();
      },
      style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
    );

    final List<Widget> defaultTrailing = <Widget>[
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          _controller.clear();
          updateSuggestions();
        },
      ),
    ];

    final SearchViewThemeData viewDefaults =
    _SearchViewDefaultsM3(context, isFullScreen: widget.showFullScreenView);
    final SearchViewThemeData viewTheme = SearchViewTheme.of(context);
    final DividerThemeData dividerTheme = DividerTheme.of(context);

    final Color effectiveBackgroundColor = widget.viewBackgroundColor ??
        viewTheme.backgroundColor ??
        viewDefaults.backgroundColor!;
    final Color effectiveSurfaceTint = widget.viewSurfaceTintColor ??
        viewTheme.surfaceTintColor ??
        viewDefaults.surfaceTintColor!;
    final double effectiveElevation =
        widget.viewElevation ?? viewTheme.elevation ?? viewDefaults.elevation!;
    final BorderSide? effectiveSide =
        widget.viewSide ?? viewTheme.side ?? viewDefaults.side;
    OutlinedBorder effectiveShape =
        widget.viewShape ?? viewTheme.shape ?? viewDefaults.shape!;
    if (effectiveSide != null) {
      effectiveShape = effectiveShape.copyWith(side: effectiveSide);
    }
    final Color effectiveDividerColor = widget.dividerColor ??
        viewTheme.dividerColor ??
        dividerTheme.color ??
        viewDefaults.dividerColor!;
    final TextStyle? effectiveTextStyle = widget.viewHeaderTextStyle ??
        viewTheme.headerTextStyle ??
        viewDefaults.headerTextStyle;
    final TextStyle? effectiveHintStyle = widget.viewHeaderHintStyle ??
        viewTheme.headerHintStyle ??
        widget.viewHeaderTextStyle ??
        viewTheme.headerTextStyle ??
        viewDefaults.headerHintStyle;

    final Widget viewDivider = DividerTheme(
      data: dividerTheme.copyWith(color: effectiveDividerColor),
      child: const Divider(height: 1),
    );

    return Align(
      alignment: Alignment.topLeft,
      child: Transform.translate(
        offset: _viewRect.topLeft,
        child: SizedBox(
          width: _viewRect.width,
          height: _viewRect.height,
          child: Material(
            clipBehavior: Clip.antiAlias,
            shape: effectiveShape,
            color: effectiveBackgroundColor,
            surfaceTintColor: effectiveSurfaceTint,
            elevation: effectiveElevation,

            child: ClipRect(
              clipBehavior: Clip.antiAlias,
              child: OverflowBox(
                alignment: Alignment.topLeft,
                maxWidth: math.min(widget.viewMaxWidth, _screenSize!.width),
                minWidth: 0,
                child: FadeTransition(
                  opacity: CurvedAnimation(
                    parent: widget.animation,
                    curve: _kViewIconsFadeOnInterval,
                    reverseCurve: _kViewIconsFadeOnInterval.flipped,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: widget.topPadding),
                        child: SafeArea(
                          top: false,
                          bottom: false,
                          child: SearchBar(
                            constraints: widget.showFullScreenView
                                ? BoxConstraints(
                                minHeight: _SearchViewDefaultsM3
                                    .fullScreenBarHeight)
                                : null,
                            focusNode: _focusNode,
                            inputFormatters: widget.inputFormatters,
                            leading: widget.viewLeading ?? defaultLeading,
                            trailing: widget.viewTrailing ?? defaultTrailing,
                            hintText: widget.viewHintText,
                            backgroundColor:
                            const MaterialStatePropertyAll<Color>(
                                Colors.transparent),
                            overlayColor: const MaterialStatePropertyAll<Color>(
                                Colors.transparent),
                            elevation:
                            const MaterialStatePropertyAll<double>(0.0),
                            textStyle: MaterialStatePropertyAll<TextStyle?>(
                                effectiveTextStyle),
                            hintStyle: MaterialStatePropertyAll<TextStyle?>(
                                effectiveHintStyle),
                            controller: _controller,
                            onChanged: (_) {
                              updateSuggestions();
                            },
                            textCapitalization: widget.textCapitalization,
                          ),
                        ),
                      ),
                      FadeTransition(
                          opacity: CurvedAnimation(
                            parent: widget.animation,
                            curve: _kViewDividerFadeOnInterval,
                            reverseCurve: _kViewFadeOnInterval.flipped,
                          ),
                          child: viewDivider),
                      Expanded(
                        child: FadeTransition(
                          opacity: CurvedAnimation(
                            parent: widget.animation,
                            curve: _kViewListFadeOnInterval,
                            reverseCurve: _kViewListFadeOnInterval.flipped,
                          ),
                          child: result,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchAnchorWithSearchBar extends SearchAnchor {
  _SearchAnchorWithSearchBar(
      {Widget? barLeading,
        Iterable<Widget>? barTrailing,
        String? barHintText,
        GestureTapCallback? onTap,
        MaterialStateProperty<double?>? barElevation,
        MaterialStateProperty<Color?>? barBackgroundColor,
        MaterialStateProperty<Color?>? barOverlayColor,
        MaterialStateProperty<BorderSide?>? barSide,
        MaterialStateProperty<OutlinedBorder?>? barShape,
        MaterialStateProperty<EdgeInsetsGeometry?>? barPadding,
        MaterialStateProperty<TextStyle?>? barTextStyle,
        MaterialStateProperty<TextStyle?>? barHintStyle,
        super.viewLeading,
        super.viewTrailing,
        String? viewHintText,
        super.viewBackgroundColor,
        super.viewElevation,
        super.viewSide,
        super.viewShape,
        TextStyle? viewHeaderTextStyle,
        TextStyle? viewHeaderHintStyle,
        super.dividerColor,
        BoxConstraints? constraints,
        super.viewConstraints,
        super.isFullScreen,
        super.searchController,
        super.textCapitalization,
        required super.inputFormatters,
        required super.suggestionsBuilder})
      : super(
      viewHintText: viewHintText ?? barHintText,
      headerTextStyle: viewHeaderTextStyle,
      headerHintStyle: viewHeaderHintStyle,
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          constraints: constraints,
          controller: controller,
          onTap: () {
            controller.openView();
            onTap?.call();
          },
          onChanged: (_) {
            controller.openView();
          },
          hintText: barHintText,
          hintStyle: barHintStyle,
          textStyle: barTextStyle,
          elevation: barElevation,
          backgroundColor: barBackgroundColor,
          overlayColor: barOverlayColor,
          side: barSide,
          shape: barShape,
          inputFormatters: inputFormatters,
          padding: barPadding ??
              const MaterialStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0)),
          leading: barLeading ?? const Icon(Icons.search),
          trailing: barTrailing,
          textCapitalization: textCapitalization,
        );
      });
}

/// A controller to manage a search view created by [SearchAnchor].
///
/// A [SearchController] is used to control a menu after it has been created,
/// with methods such as [openView] and [closeView]. It can also control the text in the
/// input field.
///
/// See also:
///
/// * [SearchAnchor], a widget that defines a region that opens a search view.
/// * [TextEditingController], A controller for an editable text field.
class SearchController extends TextEditingController {
  // The anchor that this controller controls.
  //
  // This is set automatically when a [SearchController] is given to the anchor
  // it controls.
  _SearchAnchorState? _anchor;

  /// Whether or not the associated search view is currently open.
  bool get isOpen {
    assert(_anchor != null);
    return _anchor!._viewIsOpen;
  }

  /// Opens the search view that this controller is associated with.
  void openView() {
    assert(_anchor != null);
    _anchor!._openView();
  }

  /// Close the search view that this search controller is associated with.
  ///
  /// If `selectedText` is given, then the text value of the controller is set to
  /// `selectedText`.
  void closeView(String? selectedText) {
    assert(_anchor != null);
    _anchor!._closeView(selectedText);
  }

  // ignore: use_setters_to_change_properties
  void _attach(_SearchAnchorState anchor) {
    _anchor = anchor;
  }

  void _detach(_SearchAnchorState anchor) {
    if (_anchor == anchor) {
      _anchor = null;
    }
  }
}

class SearchBar extends StatefulWidget {
  const SearchBar({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.leading,
    this.trailing,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.constraints,
    this.elevation,
    this.backgroundColor,
    this.shadowColor,
    this.surfaceTintColor,
    this.overlayColor,
    this.side,
    this.shape,
    this.padding,
    this.textStyle,
    this.hintStyle,
    this.textCapitalization,
    required this.inputFormatters,
  });

  /// Controls the text being edited in the search bar's text field.
  ///
  /// If null, this widget will create its own [TextEditingController].
  final TextEditingController? controller;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// Text that suggests what sort of input the field accepts.
  ///
  /// Displayed at the same location on the screen where text may be entered
  /// when the input is empty.
  ///
  /// Defaults to null.
  final String? hintText;

  /// A widget to display before the text input field.
  ///
  /// Typically the [leading] widget is an [Icon] or an [IconButton].
  final Widget? leading;

  /// A list of Widgets to display in a row after the text field.
  ///
  /// Typically these actions can represent additional modes of searching
  /// (like voice search), an avatar, a separate high-level action (such as
  /// current location) or an overflow menu. There should not be more than
  /// two trailing actions.
  final Iterable<Widget>? trailing;

  /// Called when the user taps this search bar.
  final GestureTapCallback? onTap;

  /// Invoked upon user input.
  final ValueChanged<String>? onChanged;

  /// Called when the user indicates that they are done editing the text in the
  /// field.
  final ValueChanged<String>? onSubmitted;

  /// Optional size constraints for the search bar.
  ///
  /// If null, the value of [SearchBarThemeData.constraints] will be used. If
  /// this is also null, then the constraints defaults to:
  /// ```dart
  /// const BoxConstraints(minWidth: 360.0, maxWidth: 800.0, minHeight: 56.0)
  /// ```
  final BoxConstraints? constraints;

  /// The elevation of the search bar's [Material].
  ///
  /// If null, the value of [SearchBarThemeData.elevation] will be used. If this
  /// is also null, then default value is 6.0.
  final MaterialStateProperty<double?>? elevation;

  /// The search bar's background fill color.
  ///
  /// If null, the value of [SearchBarThemeData.backgroundColor] will be used.
  /// If this is also null, then the default value is [ColorScheme.surface].
  final MaterialStateProperty<Color?>? backgroundColor;

  /// The shadow color of the search bar's [Material].
  ///
  /// If null, the value of [SearchBarThemeData.shadowColor] will be used.
  /// If this is also null, then the default value is [ColorScheme.shadow].
  final MaterialStateProperty<Color?>? shadowColor;

  /// The surface tint color of the search bar's [Material].
  ///
  /// See [Material.surfaceTintColor] for more details.
  ///
  /// If null, the value of [SearchBarThemeData.surfaceTintColor] will be used.
  /// If this is also null, then the default value is [ColorScheme.surfaceTint].
  final MaterialStateProperty<Color?>? surfaceTintColor;

  /// The highlight color that's typically used to indicate that
  /// the search bar is focused, hovered, or pressed.
  final MaterialStateProperty<Color?>? overlayColor;

  /// The color and weight of the search bar's outline.
  ///
  /// This value is combined with [shape] to create a shape decorated
  /// with an outline.
  ///
  /// If null, the value of [SearchBarThemeData.side] will be used. If this is
  /// also null, the search bar doesn't have a side by default.
  final MaterialStateProperty<BorderSide?>? side;

  /// The shape of the search bar's underlying [Material].
  ///
  /// This shape is combined with [side] to create a shape decorated
  /// with an outline.
  ///
  /// If null, the value of [SearchBarThemeData.shape] will be used.
  /// If this is also null, defaults to [StadiumBorder].
  final MaterialStateProperty<OutlinedBorder?>? shape;

  /// The padding between the search bar's boundary and its contents.
  ///
  /// If null, the value of [SearchBarThemeData.padding] will be used.
  /// If this is also null, then the default value is 16.0 horizontally.
  final MaterialStateProperty<EdgeInsetsGeometry?>? padding;

  /// The style to use for the text being edited.
  ///
  /// If null, defaults to the `bodyLarge` text style from the current [Theme].
  /// The default text color is [ColorScheme.onSurface].
  final MaterialStateProperty<TextStyle?>? textStyle;

  /// The style to use for the [hintText].
  ///
  /// If null, the value of [SearchBarThemeData.hintStyle] will be used. If this
  /// is also null, the value of [textStyle] will be used. If this is also null,
  /// defaults to the `bodyLarge` text style from the current [Theme].
  /// The default text color is [ColorScheme.onSurfaceVariant].
  final MaterialStateProperty<TextStyle?>? hintStyle;

  /// {@macro flutter.widgets.editableText.textCapitalization}
  final TextCapitalization? textCapitalization;

  final List<TextInputFormatter> inputFormatters;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late final MaterialStatesController _internalStatesController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _internalStatesController = MaterialStatesController();
    _internalStatesController.addListener(() {
      setState(() {});
    });
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    _internalStatesController.dispose();
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final IconThemeData iconTheme = IconTheme.of(context);
    final SearchBarThemeData searchBarTheme = SearchBarTheme.of(context);
    final SearchBarThemeData defaults = _SearchBarDefaultsM3(context);

    T? resolve<T>(
        MaterialStateProperty<T>? widgetValue,
        MaterialStateProperty<T>? themeValue,
        MaterialStateProperty<T>? defaultValue,
        ) {
      final Set<MaterialState> states = _internalStatesController.value;
      return widgetValue?.resolve(states) ??
          themeValue?.resolve(states) ??
          defaultValue?.resolve(states);
    }

    final TextStyle? effectiveTextStyle = resolve<TextStyle?>(
        widget.textStyle, searchBarTheme.textStyle, defaults.textStyle);
    final double? effectiveElevation = resolve<double?>(
        widget.elevation, searchBarTheme.elevation, defaults.elevation);
    final Color? effectiveShadowColor = resolve<Color?>(
        widget.shadowColor, searchBarTheme.shadowColor, defaults.shadowColor);
    final Color? effectiveBackgroundColor = resolve<Color?>(
        widget.backgroundColor,
        searchBarTheme.backgroundColor,
        defaults.backgroundColor);
    final Color? effectiveSurfaceTintColor = resolve<Color?>(
        widget.surfaceTintColor,
        searchBarTheme.surfaceTintColor,
        defaults.surfaceTintColor);
    final OutlinedBorder? effectiveShape = resolve<OutlinedBorder?>(
        widget.shape, searchBarTheme.shape, defaults.shape);
    final BorderSide? effectiveSide =
    resolve<BorderSide?>(widget.side, searchBarTheme.side, defaults.side);
    final EdgeInsetsGeometry? effectivePadding = resolve<EdgeInsetsGeometry?>(
        widget.padding, searchBarTheme.padding, defaults.padding);
    final MaterialStateProperty<Color?>? effectiveOverlayColor =
        widget.overlayColor ??
            searchBarTheme.overlayColor ??
            defaults.overlayColor;
    final TextCapitalization effectiveTextCapitalization =
        widget.textCapitalization ??
            searchBarTheme.textCapitalization ??
            defaults.textCapitalization!;

    final Set<MaterialState> states = _internalStatesController.value;
    final TextStyle? effectiveHintStyle = widget.hintStyle?.resolve(states) ??
        searchBarTheme.hintStyle?.resolve(states) ??
        widget.textStyle?.resolve(states) ??
        searchBarTheme.textStyle?.resolve(states) ??
        defaults.hintStyle?.resolve(states);

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    bool isIconThemeColorDefault(Color? color) {
      if (isDark) {
        return color == kDefaultIconLightColor;
      }
      return color == kDefaultIconDarkColor;
    }

    Widget? leading;
    List<Widget>? trailing;

    return ConstrainedBox(
      constraints: widget.constraints ??
          searchBarTheme.constraints ??
          defaults.constraints!,
      child: Material(
        elevation: effectiveElevation!,
        shadowColor: effectiveShadowColor,
        color: effectiveBackgroundColor,
        surfaceTintColor: effectiveSurfaceTintColor,
        shape: effectiveShape?.copyWith(side: effectiveSide),
        child: InkWell(
          onTap: () {
            widget.onTap?.call();
            _focusNode.requestFocus();
            if (widget.controller != null) {
              widget.controller!.selection =
              const TextSelection.collapsed(offset: 0);
            }
          },
          overlayColor: effectiveOverlayColor,
          customBorder: effectiveShape?.copyWith(side: effectiveSide),
          statesController: _internalStatesController,
          child: Padding(
            padding: effectivePadding!,
            child: Row(
              textDirection: textDirection,
              children: <Widget>[
                if (leading != null) leading,
                Expanded(
                    child: IgnorePointer(
                      child: Padding(
                        padding: effectivePadding,
                        child: TextField(
                          inputFormatters: widget.inputFormatters,
                          focusNode: _focusNode,
                          onChanged: (value) {
                            if (widget.controller != null) {
                              widget.controller!.selection =
                                  TextSelection.collapsed(
                                      offset: widget.controller!.value.text.length);
                            }

                            widget.onChanged?.call(value);
                          },
                          onSubmitted: widget.onSubmitted,
                          controller: widget.controller,
                          onTap: () {},
                          style: effectiveTextStyle,
                          decoration: InputDecoration(
                            hintText: widget.hintText,
                          ).applyDefaults(InputDecorationTheme(
                            hintStyle: effectiveHintStyle,

                            // The configuration below is to make sure that the text field
                            // in `SearchBar` will not be overridden by the overall `InputDecorationTheme`
                            enabledBorder: InputBorder.none,
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            // Setting `isDense` to true to allow the text field height to be
                            // smaller than 48.0
                            isDense: true,
                          )),
                          textCapitalization: effectiveTextCapitalization,
                        ),
                      ),
                    )),
                if (trailing != null) ...trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchBarDefaultsM3 extends SearchBarThemeData {
  _SearchBarDefaultsM3(this.context);

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;

  @override
  MaterialStateProperty<Color?>? get backgroundColor =>
      MaterialStatePropertyAll<Color>(_colors.surface);

  @override
  MaterialStateProperty<double>? get elevation =>
      const MaterialStatePropertyAll<double>(6.0);

  @override
  MaterialStateProperty<Color>? get shadowColor =>
      MaterialStatePropertyAll<Color>(_colors.shadow);

  @override
  MaterialStateProperty<Color>? get surfaceTintColor =>
      MaterialStatePropertyAll<Color>(_colors.surfaceTint);

  @override
  MaterialStateProperty<Color?>? get overlayColor =>
      MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return _colors.onSurface.withOpacity(0.12);
        }
        if (states.contains(MaterialState.hovered)) {
          return _colors.onSurface.withOpacity(0.08);
        }
        if (states.contains(MaterialState.focused)) {
          return Colors.transparent;
        }
        return Colors.transparent;
      });

  // No default side

  @override
  MaterialStateProperty<OutlinedBorder>? get shape =>
      const MaterialStatePropertyAll<OutlinedBorder>(StadiumBorder());

  @override
  MaterialStateProperty<EdgeInsetsGeometry>? get padding =>
      const MaterialStatePropertyAll<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(horizontal: 8.0));

  @override
  MaterialStateProperty<TextStyle?> get textStyle =>
      MaterialStatePropertyAll<TextStyle?>(
          _textTheme.bodyLarge?.copyWith(color: _colors.onSurface));

  @override
  MaterialStateProperty<TextStyle?> get hintStyle =>
      MaterialStatePropertyAll<TextStyle?>(
          _textTheme.bodyLarge?.copyWith(color: _colors.onSurfaceVariant));

  @override
  BoxConstraints get constraints =>
      const BoxConstraints(minWidth: 360.0, maxWidth: 800.0, minHeight: 56.0);

  @override
  TextCapitalization get textCapitalization => TextCapitalization.none;
}


class _SearchViewDefaultsM3 extends SearchViewThemeData {
  _SearchViewDefaultsM3(this.context, {required this.isFullScreen});

  final BuildContext context;
  final bool isFullScreen;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;

  static double fullScreenBarHeight = 72.0;

  @override
  Color? get backgroundColor => _colors.surface;

  @override
  double? get elevation => 6.0;

  @override
  Color? get surfaceTintColor => _colors.surfaceTint;

  // No default side

  @override
  OutlinedBorder? get shape => isFullScreen
      ? const RoundedRectangleBorder()
      : const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(28.0)));

  @override
  TextStyle? get headerTextStyle =>
      _textTheme.bodyLarge?.copyWith(color: _colors.onSurface);

  @override
  TextStyle? get headerHintStyle =>
      _textTheme.bodyLarge?.copyWith(color: _colors.onSurfaceVariant);

  @override
  BoxConstraints get constraints =>
      const BoxConstraints(minWidth: 360.0, minHeight: 240.0);

  @override
  Color? get dividerColor => _colors.outline;
}

