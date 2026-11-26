import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

/// Values are persisted verbatim as `PolicyFile.usageType`.
const policyFileOperations = <FileOperationType>[
  FileOperationType.open,
  FileOperationType.download,
  FileOperationType.delete,
];

const policyOperationLabels = <FileOperationType, String>{
  FileOperationType.open: 'policies.operation_open',
  FileOperationType.download: 'common.download',
  FileOperationType.delete: 'common.delete',
};

const policyOperationIcons = <FileOperationType, IconData>{
  FileOperationType.open: LucideIcons.folderOpen,
  FileOperationType.download: LucideIcons.download,
  FileOperationType.delete: LucideIcons.trash2,
};

List<PolicyFile> filesForOperation(
  List<PolicyFile> entries,
  FileOperationType operation,
) => [
  for (final entry in entries)
    if (entry.usageType == operation) entry,
];
