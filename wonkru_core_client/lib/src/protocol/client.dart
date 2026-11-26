/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:wonkru_core_client/src/protocol/catalog/protocol_catalog.dart'
    as _itrff72s;

/// {@category Endpoint}
class EndpointCore extends _isc.EndpointRef {
  EndpointCore(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'wonkru_core.core';

  _ida.Future<_itrff72s.ProtocolCatalog> catalogs() =>
      caller.callServerEndpoint<_itrff72s.ProtocolCatalog>(
        'wonkru_core.core',
        'catalogs',
        {},
      );
}

class Caller extends _isc.ModuleEndpointCaller {
  Caller(_isc.ServerpodClientShared client) : super(client) {
    core = EndpointCore(this);
  }

  late final EndpointCore core;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'wonkru_core.core': core,
  };
}
