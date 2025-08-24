import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grampulse/core/presentation/constants/spacing.dart';
import 'package:grampulse/core/utils/l10n/app_localizations.dart';
import 'package:grampulse/features/officer/domain/models/officer_models.dart';
import 'package:grampulse/features/officer/presentation/widgets/full_screen_media_view.dart';
import 'package:grampulse/features/officer/presentation/widgets/media_source_sheet.dart';

class BeforeAfterPhotoSection extends StatelessWidget {
  final List<MediaModel> beforePhotos;
  final List<File> newBeforePhotos;
  final List<MediaModel> afterPhotos;
  final List<File> newAfterPhotos;
  final Function(File) onAddBeforePhoto;
  final Function(File) onAddAfterPhoto;
  final Function(MediaModel) onRemoveBeforePhoto;
  final Function(File) onRemoveNewBeforePhoto;
  final Function(MediaModel) onRemoveAfterPhoto;
  final Function(File) onRemoveNewAfterPhoto;

  const BeforeAfterPhotoSection({
    super.key,
    this.beforePhotos = const [],
    this.newBeforePhotos = const [],
    this.afterPhotos = const [],
    this.newAfterPhotos = const [],
    required this.onAddBeforePhoto,
    required this.onAddAfterPhoto,
    required this.onRemoveBeforePhoto,
    required this.onRemoveNewBeforePhoto,
    required this.onRemoveAfterPhoto,
    required this.onRemoveNewAfterPhoto,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Spacing.md),
        
        // Before Photos Section
        Text(
          l10n.beforePhotos,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: Spacing.sm),
        _buildPhotoGrid(
          context,
          beforePhotos,
          newBeforePhotos,
          onAddBeforePhoto,
          onRemoveBeforePhoto,
          onRemoveNewBeforePhoto,
        ),
        
        const SizedBox(height: Spacing.xl),
        
        // After Photos Section
        Text(
          l10n.afterPhotos,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: Spacing.sm),
        _buildPhotoGrid(
          context,
          afterPhotos,
          newAfterPhotos,
          onAddAfterPhoto,
          onRemoveAfterPhoto,
          onRemoveNewAfterPhoto,
        ),
      ],
    );
  }

  Widget _buildPhotoGrid(
    BuildContext context,
    List<MediaModel> existingPhotos,
    List<File> newPhotos,
    Function(File) onAddPhoto,
    Function(MediaModel) onRemoveExistingPhoto,
    Function(File) onRemoveNewPhoto,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.0,
      ),
      itemCount: existingPhotos.length + newPhotos.length + 1, // +1 for add button
      itemBuilder: (context, index) {
        // Add button
        if (index == existingPhotos.length + newPhotos.length) {
          return GestureDetector(
            onTap: () async {
              final file = await showModalBottomSheet<File?>(
                context: context,
                builder: (context) => const MediaSourceSheet(),
              );
              
              if (file != null) {
                onAddPhoto(file);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.add_a_photo,
                size: 32,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          );
        }
        
        // Show existing photos first
        if (index < existingPhotos.length) {
          final photo = existingPhotos[index];
          return _buildPhotoItem(
            context,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullScreenMediaView(
                    media: existingPhotos,
                    initialIndex: index,
                  ),
                ),
              );
            },
            onRemove: () => onRemoveExistingPhoto(photo),
            child: Image.network(
              photo.url,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
            ),
          );
        } 
        
        // Then show new photos
        final newIndex = index - existingPhotos.length;
        final newPhoto = newPhotos[newIndex];
        return _buildPhotoItem(
          context,
          onTap: () {
            // Preview for new photos
            showDialog(
              context: context,
              builder: (context) => Dialog(
                child: Image.file(newPhoto),
              ),
            );
          },
          onRemove: () => onRemoveNewPhoto(newPhoto),
          child: Image.file(
            newPhoto,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
          ),
        );
      },
    );
  }
  
  Widget _buildPhotoItem(
    BuildContext context, {
    required Widget child,
    required VoidCallback onTap,
    required VoidCallback onRemove,
  }) {
    return Stack(
      children: [
        // Photo content
        GestureDetector(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox.expand(
              child: child,
            ),
          ),
        ),
        
        // Delete button
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.close,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
