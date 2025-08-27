import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:http/http.dart' as http;
import 'package:grampulse/core/theme/app_theme.dart';
import 'package:grampulse/core/theme/spacing.dart';
import 'dart:convert';
import 'dart:io';

const String groqApiKey = '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';

class ReportIssueScreen extends StatefulWidget {
  final String? mode;

  const ReportIssueScreen({Key? key, this.mode}) : super(key: key);

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  // Form Controllers
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  // Services
  final ImagePicker _picker = ImagePicker();
  final MongoDBService _mongoService = MongoDBService();

  // State Variables
  File? _selectedImage;
  bool _isAnalyzing = false;
  bool _isGettingLocation = false;
  bool _isSubmitting = false;
  double? _latitude;
  double? _longitude;
  String? _locationError;
  Map<String, dynamic>? _aiAnalysis;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _getCurrentLocation();
  }

  Future<void> _initializeServices() async {
    try {
      await _mongoService.connect();
      _showMessage('✅ Connected to MongoDB successfully!');
    } catch (e) {
      _showErrorDialog('Database Connection Failed',
          'Could not connect to local MongoDB: $e\n\nMake sure MongoDB is running on localhost:27017');
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    _mongoService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          _resetForm();
          await _getCurrentLocation();
        },
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            _buildFormContent(),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      title: const Text('🤖 GramPulse AI Reporter'),
      actions: [
        IconButton(
          icon: const Icon(Icons.history),
          onPressed: _showIncidentHistory,
          tooltip: 'View History',
        ),
        IconButton(
          icon: const Icon(Icons.settings_ethernet),
          onPressed: _testDatabaseConnection,
          tooltip: 'Test DB Connection',
        ),
      ],
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      floating: true,
      snap: true,
    );
  }

  Widget _buildFormContent() {
    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeaderCard(),
              const SizedBox(height: 20),
              _buildImageSelectionCard(),
              const SizedBox(height: 16),
              _buildDescriptionCard(),
              const SizedBox(height: 16),
              _buildLocationCard(),
              const SizedBox(height: 24),
              _buildAnalysisButton(),
              const SizedBox(height: 20),
              if (_aiAnalysis != null) _buildAnalysisResults(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      elevation: 8,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primaryContainer,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              Icons.auto_awesome,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 36,
            ),
            const SizedBox(height: 12),
            Text(
              'AI-Powered Civic Reporting',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Local MongoDB • Smart Classification • Duplicate Detection',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSelectionCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.camera_alt, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Upload Issue Photo',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _selectedImage != null
                  ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton.filled(
                      onPressed: () {
                        setState(() {
                          _selectedImage = null;
                          _aiAnalysis = null;
                        });
                      },
                      icon: const Icon(Icons.close),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black54,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
                  : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_outlined, size: 48, color: Colors.grey),
                  SizedBox(height: 8),
                  Text(
                    'No image selected',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Take a photo or choose from gallery',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 400) {
                  return Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _pickImage(ImageSource.camera),
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Take Photo'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[600],
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _pickImage(ImageSource.gallery),
                          icon: const Icon(Icons.photo_library),
                          label: const Text('Choose Image'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _pickImage(ImageSource.camera),
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Take Photo'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[600],
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _pickImage(ImageSource.gallery),
                          icon: const Icon(Icons.photo_library),
                          label: const Text('Choose Image'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.edit_note, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                const Text(
                  'Describe the Issue',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'E.g., "Large pothole on Main Street causing accidents near ABC School"',
                border: OutlineInputBorder(),
                helperText: 'Include landmarks, severity, and impact details for better AI analysis',
                helperMaxLines: 2,
              ),
              onChanged: (value) {
                if (_aiAnalysis != null) {
                  setState(() {
                    _aiAnalysis = null;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                const Text(
                  'Location Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      hintText: _getLocationHint(),
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.location_on),
                      errorText: _locationError,
                    ),
                    maxLines: 2,
                    minLines: 1,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _isGettingLocation ? null : _getCurrentLocation,
                  icon: _isGettingLocation
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Icon(Icons.my_location),
                  tooltip: 'Get Current Location',
                ),
              ],
            ),
            if (_latitude != null && _longitude != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.green),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'GPS: ${_latitude!.toStringAsFixed(6)}, ${_longitude!.toStringAsFixed(6)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisButton() {
    final bool canAnalyze = _selectedImage != null &&
        _descriptionController.text.trim().isNotEmpty &&
        !_isAnalyzing;

    return SizedBox(
      height: 56,
      child: ElevatedButton.icon(
        onPressed: canAnalyze ? _performAIAnalysis : null,
        icon: _isAnalyzing
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : const Icon(Icons.auto_awesome, size: 24),
        label: Text(
          _isAnalyzing ? 'Analyzing with AI...' : '🚀 Analyze with AI',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: canAnalyze
              ? Colors.purple[600]
              : Colors.grey[400],
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildAnalysisResults() {
    return Card(
      elevation: 8,
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green[600]),
                const SizedBox(width: 8),
                const Text(
                  '🤖 AI Analysis Complete',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Classification Results
            if (_aiAnalysis!['classification'] != null) ...[
              _buildResultSection(
                '📷 Classification',
                [
                  'Category: ${_aiAnalysis!['classification']['category']}',
                  'Department: ${_aiAnalysis!['classification']['department']}',
                  'Confidence: ${(_aiAnalysis!['classification']['confidence'] * 100).toInt()}%',
                  'Evidence: ${_aiAnalysis!['classification']['visual_evidence']}',
                ],
              ),
            ],

            // Severity Analysis
            if (_aiAnalysis!['severity'] != null) ...[
              const SizedBox(height: 12),
              _buildResultSection(
                '⚠️ Severity Analysis',
                [
                  'Score: ${_aiAnalysis!['severity']['score']}/5 (${_aiAnalysis!['severity']['priority']})',
                  'Visual Severity: ${_aiAnalysis!['severity']['visual_severity']}/5',
                  'Location Impact: +${_aiAnalysis!['severity']['location_boost']}',
                  'Reasoning: ${(_aiAnalysis!['severity']['reasoning'] as List).join(', ')}',
                ],
              ),
            ],

            // Database Duplicate Check
            const SizedBox(height: 12),
            FutureBuilder<bool>(
              future: _checkDuplicateFromDB(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final isDuplicate = snapshot.data ?? false;
                return _buildResultSection(
                  '🔄 Database Duplicate Check',
                  [
                    isDuplicate
                        ? '⚠️ Similar incident found in database!'
                        : '✅ No duplicate found in database',
                    isDuplicate
                        ? 'Found similar report within 500m in last 24 hours'
                        : 'This appears to be a unique incident',
                  ],
                  isWarning: isDuplicate,
                );
              },
            ),

            // Image Authenticity
            if (_aiAnalysis!['authenticity'] != null) ...[
              const SizedBox(height: 12),
              _buildResultSection(
                '🔒 Image Authenticity',
                [
                  'Trust Score: ${(_aiAnalysis!['authenticity']['trust_score'] * 100).toInt()}%',
                  _aiAnalysis!['authenticity']['is_authentic']
                      ? '✅ Image appears authentic'
                      : '⚠️ Authenticity concerns detected',
                  'Quality: ${_aiAnalysis!['authenticity']['quality_indicators']}',
                ],
              ),
            ],

            // AI Recommendation
            if (_aiAnalysis!['recommendation'] != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💡 AI Recommendation',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Action: ${_aiAnalysis!['recommendation']['action']}'),
                    Text('Expected SLA: ${_aiAnalysis!['recommendation']['estimated_sla']}'),
                    Text('Suggested Officer: ${_aiAnalysis!['recommendation']['suggested_officer']}'),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _submitIncident,
                icon: _isSubmitting
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Icon(Icons.send),
                label: Text(
                  _isSubmitting ? 'Submitting...' : 'Submit Incident Report',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultSection(String title, List<String> items, {bool isWarning = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isWarning ? Colors.orange[50] : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isWarning ? Colors.orange : Colors.grey[300]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isWarning ? Colors.orange[700] : null,
            ),
          ),
          const SizedBox(height: 6),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              '• $item',
              style: const TextStyle(fontSize: 13),
            ),
          )),
        ],
      ),
    );
  }

  // Helper Methods
  String _getLocationHint() {
    if (_latitude != null && _longitude != null) {
      return 'GPS: ${_latitude!.toStringAsFixed(4)}, ${_longitude!.toStringAsFixed(4)}';
    }
    return 'Enter location manually or use GPS';
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _aiAnalysis = null;
        });
        _showMessage('📸 Image selected successfully!');
      }
    } catch (e) {
      _showErrorDialog('Image Selection Error', 'Failed to pick image: $e');
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isGettingLocation = true;
      _locationError = null;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled. Please enable location services.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permission denied. Please allow location access.';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied. Please enable in app settings.';
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _locationController.text = 'GPS: ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
        _locationError = null;
      });

      _showMessage('📍 Location obtained successfully!');
    } catch (e) {
      setState(() {
        _locationError = e.toString();
      });
      _showErrorDialog('Location Error', e.toString());
    } finally {
      setState(() {
        _isGettingLocation = false;
      });
    }
  }

  Future<bool> _checkDuplicateFromDB() async {
    if (_latitude == null || _longitude == null) return false;
    return await _mongoService.checkDuplicate(
      _latitude!,
      _longitude!,
      _descriptionController.text,
    );
  }

  Future<void> _performAIAnalysis() async {
    setState(() { _isAnalyzing = true; });

    try {
      final groqService = GroqAIService(groqApiKey);
      final analysis = await groqService.analyzeIncident(
        imageFile: _selectedImage!,
        description: _descriptionController.text,
        lat: _latitude ?? 0.0,
        lon: _longitude ?? 0.0,
      );

      setState(() {
        _aiAnalysis = analysis;
      });

      _showMessage('🤖 AI analysis completed successfully!');
    } catch (e) {
      _showErrorDialog('AI Analysis Failed', 'Failed to analyze with AI: $e');
    } finally {
      setState(() { _isAnalyzing = false; });
    }
  }

  Future<void> _submitIncident() async {
    if (_latitude == null || _longitude == null) {
      _showErrorDialog('Location Required', 'Please enable GPS location to submit.');
      return;
    }

    setState(() { _isSubmitting = true; });

    try {
      // Check for duplicates first
      final isDuplicate = await _mongoService.checkDuplicate(
        _latitude!,
        _longitude!,
        _descriptionController.text,
      );

      if (isDuplicate) {
        final shouldContinue = await _showDuplicateDialog();
        if (!shouldContinue) {
          setState(() { _isSubmitting = false; });
          return;
        }
      }

      final incident = {
        'description': _descriptionController.text.trim(),
        'category': _aiAnalysis?['classification']?['category'] ?? 'other',
        'department': _aiAnalysis?['classification']?['department'] ?? 'General',
        'latitude': _latitude,
        'longitude': _longitude,
        'image_path': _selectedImage?.path,
        'severity': _aiAnalysis?['severity']?['score'] ?? 1,
        'priority': _aiAnalysis?['severity']?['priority'] ?? 'LOW',
        'status': 'submitted',
        'created_at': DateTime.now(),
        'ai_analysis': _aiAnalysis != null ? jsonEncode(_aiAnalysis) : null,
        'location': {
          'type': 'Point',
          'coordinates': [_longitude!, _latitude!]
        }
      };

      final id = await _mongoService.insertIncident(incident);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 32),
              const SizedBox(width: 8),
              const Text('✅ Report Submitted'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your incident report has been saved to MongoDB successfully!'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('🆔 Incident ID: ${id.toString()}'),
                    if (_aiAnalysis != null) ...[
                      Text('📂 Category: ${_aiAnalysis!['classification']['category']}'),
                      Text('🏢 Department: ${_aiAnalysis!['classification']['department']}'),
                      Text('⚠️ Priority: ${_aiAnalysis!['severity']['priority']}'),
                    ],
                    Text('📅 Submitted: ${DateTime.now().toString().split('.')[0]}'),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showIncidentHistory();
              },
              child: const Text('View History'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _resetForm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
              ),
              child: const Text('Submit Another'),
            ),
          ],
        ),
      );
    } catch (e) {
      _showErrorDialog('Submission Error', 'Failed to submit incident: $e');
    } finally {
      setState(() { _isSubmitting = false; });
    }
  }

  Future<bool> _showDuplicateDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange[600]),
            const SizedBox(width: 8),
            const Text('Similar Issue Found'),
          ],
        ),
        content: const Text(
          'A similar issue has been reported nearby within the last 24 hours. Would you like to submit anyway?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[600],
              foregroundColor: Colors.white,
            ),
            child: const Text('Submit Anyway'),
          ),
        ],
      ),
    ) ?? false;
  }

  Future<void> _testDatabaseConnection() async {
    try {
      final isConnected = await _mongoService.testConnection();

      if (isConnected) {
        final incidents = await _mongoService.getAllIncidents();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('✅ Database Connection Test'),
            content: Text('Successfully connected to local MongoDB!\nFound ${incidents.length} incidents in database.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        _showErrorDialog('Connection Test Failed', 'Could not connect to local MongoDB database.');
      }
    } catch (e) {
      _showErrorDialog('Connection Test Error', e.toString());
    }
  }

  void _showIncidentHistory() async {
    try {
      final incidents = await _mongoService.getAllIncidents();

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Incident History (${incidents.length} records)',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: incidents.isEmpty
                    ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No incidents found', style: TextStyle(fontSize: 18)),
                      Text('Submit your first report to see it here'),
                    ],
                  ),
                )
                    : ListView.builder(
                  itemCount: incidents.length,
                  itemBuilder: (context, index) {
                    final incident = incidents[index];
                    final createdAt = incident['created_at'] is DateTime
                        ? incident['created_at'] as DateTime
                        : DateTime.parse(incident['created_at'].toString());

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue[700],
                          foregroundColor: Colors.white,
                          child: Text('${index + 1}'),
                        ),
                        title: Text(
                          incident['description'] ?? 'No description',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('📂 ${incident['category'] ?? 'Unknown'} • ${incident['status'] ?? 'submitted'}'),
                            Text('📅 ${createdAt.toString().split('.')[0]}'),
                            if (incident['ai_analysis'] != null)
                              const Text('🤖 AI Enhanced', style: TextStyle(color: Colors.green)),
                          ],
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getPriorityColor(incident['priority']),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${incident['priority'] ?? 'LOW'}',
                            style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      _showErrorDialog('History Load Error', 'Failed to load incident history: $e');
    }
  }

  Color _getPriorityColor(String? priority) {
    switch (priority?.toUpperCase()) {
      case 'HIGH':
        return Colors.red;
      case 'MEDIUM':
        return Colors.orange;
      case 'LOW':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _resetForm() {
    setState(() {
      _selectedImage = null;
      _aiAnalysis = null;
      _latitude = null;
      _longitude = null;
      _locationError = null;
      _isSubmitting = false;
    });
    _descriptionController.clear();
    _locationController.clear();
  }

  void _showErrorDialog(String title, String message) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            const SizedBox(width: 8),
            Expanded(child: Text(title, overflow: TextOverflow.ellipsis)),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue[700],
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );
  }
}

// MongoDB Service Class
class MongoDBService {
  static const String connectionString = 'mongodb://10.0.2.2:27017/grampulse';

  mongo.Db? _db;
  mongo.DbCollection? _incidentsCollection;
  bool _isConnected = false;

  Future<void> connect() async {
    if (_isConnected) return;

    try {
      _db = await mongo.Db.create(connectionString);
      await _db!.open();
      _incidentsCollection = _db!.collection('incidents');

      // Create indexes
      try {
        await _incidentsCollection!.createIndex(keys: {'created_at': -1});
        await _incidentsCollection!.createIndex(keys: {'location': '2dsphere'});
        await _incidentsCollection!.createIndex(keys: {
          'created_at': -1,
          'latitude': 1,
          'longitude': 1
        });
      } catch (e) {
        print('Index creation note: $e');
      }

      _isConnected = true;
      print('✅ Connected to MongoDB at $connectionString');
    } catch (e) {
      throw Exception('Failed to connect to MongoDB: $e');
    }
  }

  Future<void> disconnect() async {
    if (_isConnected && _db != null) {
      await _db!.close();
      _isConnected = false;
      print('📴 Disconnected from MongoDB');
    }
  }

  Future<mongo.ObjectId> insertIncident(Map<String, dynamic> incident) async {
    if (!_isConnected) await connect();

    try {
      final result = await _incidentsCollection!.insertOne(incident);
      print('✅ Incident inserted with ID: ${result.id}');
      return result.id!;
    } catch (e) {
      throw Exception('Failed to insert incident: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAllIncidents() async {
    if (!_isConnected) await connect();

    try {
      final incidents = await _incidentsCollection!
          .find(mongo.where.sortBy('created_at', descending: true))
          .toList();

      print('📋 Retrieved ${incidents.length} incidents from MongoDB');
      return incidents;
    } catch (e) {
      // Fallback: Use aggregation pipeline
      return await _getAllIncidentsWithAggregation();
    }
  }

  Future<List<Map<String, dynamic>>> _getAllIncidentsWithAggregation() async {
    try {
      final pipeline = [
        {'\$sort': {'created_at': -1}},
        {'\$limit': 100}
      ];

      final stream = _incidentsCollection!.aggregateToStream(pipeline);
      final incidents = <Map<String, dynamic>>[];

      await for (final doc in stream) {
        incidents.add(doc);
      }

      return incidents;
    } catch (e) {
      throw Exception('Failed to get incidents with aggregation: $e');
    }
  }

  Future<bool> checkDuplicate(double lat, double lon, String description) async {
    if (!_isConnected) await connect();

    try {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(hours: 24));

      final pipeline = [
        {
          '\$match': {
            'created_at': {'\$gte': yesterday},
            'location': {
              '\$geoWithin': {
                '\$centerSphere': [
                  [lon, lat],
                  0.5 / 6378.1 // 0.5km radius in radians
                ]
              }
            }
          }
        }
      ];

      final stream = _incidentsCollection!.aggregateToStream(pipeline);
      final nearbyIncidents = <Map<String, dynamic>>[];

      await for (final doc in stream) {
        nearbyIncidents.add(doc);
      }

      // Check text similarity
      for (final incident in nearbyIncidents) {
        final existingDesc = incident['description']?.toString().toLowerCase() ?? '';
        final newDesc = description.toLowerCase();

        final similarity = _calculateSimilarity(existingDesc, newDesc);
        if (similarity > 0.5) {
          return true;
        }
      }

      return false;
    } catch (e) {
      print('❌ Duplicate check error: $e');
      return false;
    }
  }

  double _calculateSimilarity(String text1, String text2) {
    final words1 = text1.split(' ').where((word) => word.length > 2).toSet();
    final words2 = text2.split(' ').where((word) => word.length > 2).toSet();
    final commonWords = words1.intersection(words2).length;
    final totalWords = words1.union(words2).length;
    return totalWords > 0 ? commonWords / totalWords : 0.0;
  }

  Future<bool> testConnection() async {
    try {
      await connect();
      final count = await _incidentsCollection!.count();
      print('🔧 Test successful. Database has $count documents.');
      return true;
    } catch (e) {
      print('❌ Test failed: $e');
      return false;
    }
  }
}

// GroqAI Service Class
class GroqAIService {
  final String apiKey;
  static const String baseUrl = 'https://api.groq.com/openai/v1/chat/completions';
  static const String model = 'llama-3.1-70b-versatile';

  GroqAIService(this.apiKey);

  Future<Map<String, dynamic>> analyzeIncident({
    required File imageFile,
    required String description,
    required double lat,
    required double lon,
  }) async {
    final base64Image = base64Encode(await imageFile.readAsBytes());

    final prompt = '''
🤖 COMPREHENSIVE CIVIC INCIDENT ANALYSIS

ANALYZE THIS INCIDENT IMAGE AND TEXT:
Description: "$description"
Location: $lat, $lon

PERFORM ALL THESE TASKS:

1. IMAGE CLASSIFICATION
Categorize into: pothole, water_logging, garbage, streetlight, transformer, drainage, road_damage

2. SEVERITY SCORING (1-5 scale)
Consider:
- Visual damage extent
- Safety hazards visible
- Location context (school/hospital nearby = higher)
- Text urgency keywords

3. DEPARTMENT ROUTING
Map to: Municipal Engineering, Water Board, Electricity Board, Waste Management

4. IMAGE AUTHENTICITY
Check for visual consistency and realism

5. ENTITY EXTRACTION
Extract: landmarks, road names, severity words

RESPOND IN JSON:
{
  "classification": {
    "category": "pothole",
    "department": "Municipal Engineering",
    "confidence": 0.95,
    "visual_evidence": "Clear road surface damage visible"
  },
  "severity": {
    "score": 4,
    "priority": "HIGH",
    "reasoning": ["Large pothole affecting traffic", "Near school zone"],
    "visual_severity": 3,
    "text_severity": 2,
    "location_boost": 1
  },
  "authenticity": {
    "trust_score": 0.9,
    "is_authentic": true,
    "concerns": [],
    "quality_indicators": "Good lighting, natural shadows"
  },
  "entities": {
    "locations": ["Main Street"],
    "landmarks": ["ABC School"],
    "severity_words": ["dangerous"],
    "time_references": []
  },
  "recommendation": {
    "action": "IMMEDIATE_ASSIGNMENT",
    "estimated_sla": "24-48 hours",
    "suggested_officer": "Senior Municipal Engineer"
  }
}
''';

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': model,
          'messages': [
            {
              "role": "user",
              "content": [
                {"type": "text", "text": prompt},
                {
                  "type": "image_url",
                  "image_url": {"url": "data:image/jpeg;base64,$base64Image"}
                }
              ],
            }
          ],
          'temperature': 0.1,
          'max_completion_tokens': 2048,
          'response_format': {"type": "json_object"},
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return jsonDecode(data['choices'][0]['message']['content']);
      } else {
        throw Exception('Groq API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // Return fallback analysis
      return {
        "classification": {
          "category": "general_issue",
          "department": "Municipal Engineering",
          "confidence": 0.5,
          "visual_evidence": "Analysis unavailable - using fallback"
        },
        "severity": {
          "score": 2,
          "priority": "MEDIUM",
          "reasoning": ["Based on description only"],
          "visual_severity": 2,
          "text_severity": 2,
          "location_boost": 0
        },
        "authenticity": {
          "trust_score": 0.7,
          "is_authentic": true,
          "concerns": [],
          "quality_indicators": "Unable to verify"
        },
        "entities": {
          "locations": [],
          "landmarks": [],
          "severity_words": [],
          "time_references": []
        },
        "recommendation": {
          "action": "STANDARD_ASSIGNMENT",
          "estimated_sla": "48-72 hours",
          "suggested_officer": "Duty Officer"
        }
      };
    }
  }
}
