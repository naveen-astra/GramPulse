import 'package:flutter/material.dart';
import '../blocs/volunteer_dashboard_bloc.dart';

class NearbyRequestsMap extends StatelessWidget {
  final List<VerificationRequest> requests;

  const NearbyRequestsMap({
    Key? key,
    required this.requests,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Mock map background
          Container(
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomPaint(
              painter: MapPainter(),
              size: Size.infinite,
            ),
          ),
          
          // Map markers for requests
          ...requests.asMap().entries.map((entry) {
            final index = entry.key;
            final request = entry.value;
            
            // Position markers in different locations
            double left = 50.0 + (index * 40.0);
            double top = 40.0 + (index * 30.0);
            
            // Ensure markers stay within bounds
            left = left.clamp(20.0, 180.0);
            top = top.clamp(20.0, 140.0);
            
            return Positioned(
              left: left,
              top: top,
              child: GestureDetector(
                onTap: () {
                  _showRequestDetails(context, request);
                },
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _getPriorityColor(request.priority),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
          
          // Legend
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _LegendItem(color: Colors.red, label: 'High'),
                  const SizedBox(width: 8),
                  _LegendItem(color: Colors.orange, label: 'Med'),
                  const SizedBox(width: 8),
                  _LegendItem(color: Colors.green, label: 'Low'),
                ],
              ),
            ),
          ),
          
          // Current location indicator
          const Positioned(
            left: 100,
            top: 80,
            child: Icon(
              Icons.my_location,
              color: Colors.blue,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  void _showRequestDetails(BuildContext context, VerificationRequest request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(request.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${request.category}'),
            Text('Priority: ${request.priority}'),
            Text('Distance: ${request.distance.toStringAsFixed(1)} km'),
            Text('Address: ${request.address}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to verification
            },
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }
}

class MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw some simple roads/paths
    final path = Path();
    
    // Horizontal road
    path.moveTo(0, size.height * 0.6);
    path.lineTo(size.width, size.height * 0.6);
    
    // Vertical road
    path.moveTo(size.width * 0.4, 0);
    path.lineTo(size.width * 0.4, size.height);
    
    // Diagonal path
    path.moveTo(0, 0);
    path.lineTo(size.width, size.height);
    
    canvas.drawPath(path, paint);
    
    // Draw some building rectangles
    final buildingPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.fill;
    
    canvas.drawRect(
      Rect.fromLTWH(20, 20, 30, 40),
      buildingPaint,
    );
    
    canvas.drawRect(
      Rect.fromLTWH(size.width - 50, 30, 35, 30),
      buildingPaint,
    );
    
    canvas.drawRect(
      Rect.fromLTWH(30, size.height - 50, 40, 35),
      buildingPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
