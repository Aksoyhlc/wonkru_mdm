import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wonkrumdm/Core/Extensions/file_cache.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_theme.dart';
import 'package:wonkrumdm/Core/Utils/file_cache.dart';

class CachedNetworkImage extends StatelessWidget {
  const CachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.placeholder,
    this.errorWidget,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.cacheDuration,
    this.loadingColor,
    this.backgroundColor,
  });

  final String imageUrl;

  final Widget? placeholder;

  final Widget? errorWidget;

  final double? width;

  final double? height;

  final BoxFit fit;

  final BorderRadius? borderRadius;

  final Duration? cacheDuration;

  final Color? loadingColor;

  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Container(
        width: width,
        height: height,
        color: backgroundColor,
        child: FutureBuilder<String?>(
          future: _loadImage(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildPlaceholder();
            }

            if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
              return _buildErrorWidget();
            }

            return _buildImage(snapshot.data!);
          },
        ),
      ),
    );
  }

  Future<String?> _loadImage() async {
    if (imageUrl.isEmpty) return null;

    if (cacheDuration != null) {
      FileCache.instance.cacheDuration = cacheDuration!;
    }

    return await imageUrl.cached();
  }

  Widget _buildPlaceholder() {
    if (placeholder != null) return placeholder!;

    return Container(
      width: width,
      height: height,
      color: Colors.grey.withValues(alpha: 0.1),
      child: Center(
        child: SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(loadingColor ?? WonkruColors.accent),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    if (errorWidget != null) return errorWidget!;

    return Container(
      width: width,
      height: height,
      color: Colors.grey.withValues(alpha: 0.1),
      child: const Center(child: Icon(Icons.broken_image_outlined, color: Colors.grey, size: 40)),
    );
  }

  Widget _buildImage(String imagePath) {
    return Image.file(
      File(imagePath),
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return _buildErrorWidget();
      },
    );
  }
}

class SimpleCachedImage extends StatelessWidget {
  const SimpleCachedImage({super.key, required this.imageUrl, this.size = 50, this.borderRadius = 8});

  final String imageUrl;
  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(borderRadius),
      fit: BoxFit.cover,
    );
  }
}

class CachedAvatarImage extends StatelessWidget {
  const CachedAvatarImage({
    super.key,
    required this.imageUrl,
    this.radius = 30,
    this.backgroundColor,
    this.placeholderIcon = Icons.person,
  });

  final String imageUrl;
  final double radius;
  final Color? backgroundColor;
  final IconData placeholderIcon;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        backgroundColor: backgroundColor ?? Colors.grey.withValues(alpha: 0.1),
        placeholder: Container(
          width: radius * 2,
          height: radius * 2,
          color: backgroundColor ?? Colors.grey.withValues(alpha: 0.1),
          child: Icon(placeholderIcon, color: Colors.grey, size: radius),
        ),
        errorWidget: Container(
          width: radius * 2,
          height: radius * 2,
          color: backgroundColor ?? Colors.grey.withValues(alpha: 0.1),
          child: Icon(placeholderIcon, color: Colors.grey, size: radius),
        ),
      ),
    );
  }
}

class CachedImageCard extends StatelessWidget {
  const CachedImageCard({
    super.key,
    required this.imageUrl,
    this.title,
    this.subtitle,
    this.onTap,
    this.imageHeight = 200,
    this.cardMargin,
  });

  final String imageUrl;
  final String? title;
  final String? subtitle;
  final VoidCallback? onTap;
  final double imageHeight;
  final EdgeInsets? cardMargin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: cardMargin ?? const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: WonkruColors.bg2,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: WonkruColors.creamFaint, blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              width: double.infinity,
              height: imageHeight,
              fit: BoxFit.cover,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            ),

            if (title != null || subtitle != null)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null)
                      Text(
                        title!,
                        style: WonkruText.body(16, color: WonkruColors.cream, weight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (title != null && subtitle != null) const SizedBox(height: 4),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: WonkruText.body(14, color: WonkruColors.creamDim),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}