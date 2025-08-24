import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:grampulse/core/presentation/constants/spacing.dart';
import 'package:grampulse/core/utils/l10n/app_localizations.dart';
import 'package:grampulse/features/officer/domain/models/officer_models.dart';
import 'package:grampulse/features/officer/domain/models/resolution_model.dart';
import 'package:grampulse/features/officer/presentation/widgets/full_screen_media_view.dart';

class ResolutionEvidenceSection extends StatelessWidget {
  final ResolutionModel? resolution;
  final VoidCallback onAddResolution;

  const ResolutionEvidenceSection({
    super.key,
    this.resolution,
    required this.onAddResolution,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Card(
      elevation: 1,
      margin: const EdgeInsets.all(Spacing.md),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.resolutionEvidence,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: Spacing.md),
            
            if (resolution != null) 
              _buildResolutionDetails(context, resolution!)
            else 
              _buildAddResolution(context),
          ],
        ),
      ),
    );
  }

  Widget _buildResolutionDetails(BuildContext context, ResolutionModel resolution) {
    final l10n = AppLocalizations.of(context);
    final resolvedAt = resolution.resolvedAt;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (resolvedAt != null) ...[
          Text(
            l10n.resolvedOn(DateFormat('dd MMM yyyy, hh:mm a').format(resolvedAt)),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: Spacing.md),
        ],
        
        Text(
          resolution.description,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        
        if (resolution.cost != null) ...[
          const SizedBox(height: Spacing.sm),
          Text(
            l10n.resolutionCost(resolution.cost.toString()),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        
        if (resolution.actionTaken != null) ...[
          const SizedBox(height: Spacing.sm),
          Text(
            '${l10n.actionTaken}: ${resolution.actionTaken}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
        
        if (resolution.mediaUrls.isNotEmpty) ...[
          const SizedBox(height: Spacing.lg),
          Text(
            l10n.evidencePhotos,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: Spacing.sm),
          _buildPhotoGrid(context, resolution.mediaUrls),
        ],
      ],
    );
  }

  Widget _buildPhotoGrid(BuildContext context, List<MediaModel> media) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: media.length,
      itemBuilder: (context, index) {
        final mediaItem = media[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FullScreenMediaView(
                  media: media,
                  initialIndex: index,
                ),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              mediaItem.url,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddResolution(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Center(
      child: Column(
        children: [
          Text(
            l10n.noResolutionYet,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          ElevatedButton.icon(
            onPressed: onAddResolution,
            icon: const Icon(Icons.add_photo_alternate_outlined),
            label: Text(l10n.addResolution),
          ),
        ],
      ),
    );
  }
}
