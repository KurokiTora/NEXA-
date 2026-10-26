import 'package:flutter/foundation.dart';

import '../core/errors.dart';
import '../data/repositories/nexa_repository.dart';

/// Global "is the app syncing with the backend right now?" state.
/// The data itself is NOT held here: screens read it from Drift streams.
class SyncState extends ChangeNotifier {
  SyncState(this._repository);

  final NexaRepository _repository;

  bool _isRefreshing = false;
  NexaException? _lastError;

  bool get isRefreshing => _isRefreshing;
  NexaException? get lastError => _lastError;

  /// Pull fresh data from the backend into the local database.
  /// Returns the failure (also kept in [lastError]) or null on success.
  Future<NexaException?> refresh() async {
    if (_isRefreshing) return null;
    _isRefreshing = true;
    _lastError = null;
    notifyListeners();

    try {
      await _repository.refresh();
      return null;
    } on NexaException catch (e) {
      _lastError = e;
      return e;
    } catch (e) {
      final failure = ServerFailure(e.toString());
      _lastError = failure;
      return failure;
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }

  /// Only hits the network when the cache is empty or older than the TTL.
  Future<NexaException?> refreshIfStale() async {
    if (_isRefreshing) return null;
    if (!await _repository.isCacheStale()) return null;
    return refresh();
  }
}
