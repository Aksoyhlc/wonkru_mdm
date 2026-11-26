import '../../../../../Widgets/Input/uploaded_file.dart';

class UploadResult {
  const UploadResult({required this.uploaded, this.destinationPath});

  final UploadedFile uploaded;
  final String? destinationPath;
}
