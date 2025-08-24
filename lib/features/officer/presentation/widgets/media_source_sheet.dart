import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grampulse/core/presentation/constants/spacing.dart';
import 'package:grampulse/core/utils/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

class MediaSourceSheet extends StatelessWidget {
  const MediaSourceSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt, color: Theme.of(context).colorScheme.primary),
            title: Text(l10n.takePhoto),
            onTap: () async {
              final ImagePicker picker = ImagePicker();
              final XFile? image = await picker.pickImage(
                source: ImageSource.camera,
                imageQuality: 80,
              );
              
              if (image != null && context.mounted) {
                Navigator.pop(context, File(image.path));
              } else if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.photo_library, color: Theme.of(context).colorScheme.primary),
            title: Text(l10n.chooseFromGallery),
            onTap: () async {
              final ImagePicker picker = ImagePicker();
              final XFile? image = await picker.pickImage(
                source: ImageSource.gallery,
                imageQuality: 80,
              );
              
              if (image != null && context.mounted) {
                Navigator.pop(context, File(image.path));
              } else if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
          const SizedBox(height: Spacing.md),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(l10n.cancel),
          ),
          // Bottom padding for notch on iPhone
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
