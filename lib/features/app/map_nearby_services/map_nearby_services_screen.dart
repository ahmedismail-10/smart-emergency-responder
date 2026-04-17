import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class MapNearbyServicesScreen extends StatefulWidget {
  const MapNearbyServicesScreen({super.key});

  @override
  State<MapNearbyServicesScreen> createState() =>
      _MapNearbyServicesScreenState();
}

class _MapNearbyServicesScreenState extends State<MapNearbyServicesScreen> {
  static const LatLng _defaultCenter = LatLng(30.0444, 31.2357);

  static const List<String> _filters = ['All', 'Hospital', 'Police', 'Fire'];

  static const List<String> _suggestionSeed = [
    'General Health Center',
    'St. Jude Medical',
    'North Fire Station',
    'Downtown Police Unit',
    'Hospital',
    'Police Station',
    'Fire Station',
    'Emergency Clinic',
    'Pharmacy',
    'Ambulance',
  ];

  static const List<_NearbyService> _services = [
    _NearbyService(
      id: 'general_health_center',
      name: 'General Health Center',
      type: 'Hospital',
      distanceKm: 1.2,
      position: LatLng(30.0484, 31.2337),
      markerHue: BitmapDescriptor.hueRed,
    ),
    _NearbyService(
      id: 'st_jude_medical',
      name: 'St. Jude Medical',
      type: 'Hospital',
      distanceKm: 2.4,
      position: LatLng(30.0411, 31.2464),
      markerHue: BitmapDescriptor.hueOrange,
    ),
    _NearbyService(
      id: 'north_fire_station',
      name: 'North Fire Station',
      type: 'Fire',
      distanceKm: 2.9,
      position: LatLng(30.0364, 31.2245),
      markerHue: BitmapDescriptor.hueGreen,
    ),
    _NearbyService(
      id: 'downtown_police_unit',
      name: 'Downtown Police Unit',
      type: 'Police',
      distanceKm: 1.8,
      position: LatLng(30.0521, 31.2415),
      markerHue: BitmapDescriptor.hueBlue,
    ),
  ];

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  GoogleMapController? _mapController;
  LatLng? _currentLocation;
  Marker? _searchMarker;
  Timer? _searchDebounce;
  List<String> _suggestions = const [];
  bool _isLocating = false;
  bool _isSearching = false;
  bool _showSuggestions = false;
  String _activeFilter = 'All';
  late _NearbyService _selectedService;

  @override
  void initState() {
    super.initState();
    _selectedService = _services.first;
    _searchFocusNode.addListener(_handleSearchFocusChanged);
    unawaited(_locateUser(moveCamera: false));
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchFocusNode
      ..removeListener(_handleSearchFocusChanged)
      ..dispose();
    _mapController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearchFocusChanged() {
    if (!mounted) {
      return;
    }

    setState(() {
      _showSuggestions = _searchFocusNode.hasFocus && _suggestions.isNotEmpty;
    });
  }

  List<String> _buildSuggestions(String rawInput) {
    final query = rawInput.trim().toLowerCase();
    if (query.isEmpty) {
      return const [];
    }

    final pool = <String>[
      ..._services.map((service) => service.name),
      ..._suggestionSeed,
    ];

    final unique = <String>{};
    final results = <String>[];

    for (final candidate in pool) {
      final normalized = candidate.toLowerCase();
      if (!normalized.contains(query) || !unique.add(candidate)) {
        continue;
      }

      results.add(candidate);
      if (results.length >= 6) {
        break;
      }
    }

    return results;
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 180), () {
      if (!mounted) {
        return;
      }

      final nextSuggestions = _buildSuggestions(value);
      setState(() {
        _suggestions = nextSuggestions;
        _showSuggestions =
            _searchFocusNode.hasFocus && nextSuggestions.isNotEmpty;
      });
    });
  }

  void _onSuggestionTap(String value) {
    _searchController
      ..text = value
      ..selection = TextSelection.collapsed(offset: value.length);

    unawaited(_searchPlace(customQuery: value));
  }

  List<_NearbyService> _filteredServicesFor(String filter) {
    if (filter == 'All') {
      return _services;
    }
    return _services.where((service) => service.type == filter).toList();
  }

  List<_NearbyService> get _visibleServices =>
      _filteredServicesFor(_activeFilter);

  Set<Marker> _buildMarkers() {
    final markers = <Marker>{};

    for (final service in _visibleServices) {
      final isSelected = service.id == _selectedService.id;
      markers.add(
        Marker(
          markerId: MarkerId(service.id),
          position: service.position,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            isSelected ? BitmapDescriptor.hueRose : service.markerHue,
          ),
          infoWindow: InfoWindow(
            title: service.name,
            snippet:
                '${service.type} • ${service.distanceKm.toStringAsFixed(1)} km',
          ),
          onTap: () => setState(() => _selectedService = service),
        ),
      );
    }

    if (_currentLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('my_location'),
          position: _currentLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
          infoWindow: const InfoWindow(title: 'My Location'),
        ),
      );
    }

    if (_searchMarker != null) {
      markers.add(_searchMarker!);
    }

    return markers;
  }

  Future<void> _moveCamera(LatLng target, {double zoom = 14.8}) async {
    final controller = _mapController;
    if (controller == null) {
      return;
    }

    try {
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: target, zoom: zoom),
        ),
      );
    } catch (_) {
      // Ignore map camera exceptions to keep the screen stable.
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    final initialTarget = _currentLocation ?? _selectedService.position;
    unawaited(
      _moveCamera(initialTarget, zoom: _currentLocation == null ? 13.8 : 15.2),
    );
  }

  Future<void> _locateUser({required bool moveCamera}) async {
    if (!mounted) {
      return;
    }

    if (_isLocating) {
      return;
    }

    setState(() => _isLocating = true);

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showMessage('Please enable location services first.');
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _showMessage('Location permission is required to center the map.');
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      ).timeout(const Duration(seconds: 12));

      if (!mounted) {
        return;
      }

      final userPosition = LatLng(position.latitude, position.longitude);
      setState(() => _currentLocation = userPosition);

      if (moveCamera) {
        await _moveCamera(userPosition, zoom: 15.2);
      }
    } on TimeoutException {
      _showMessage('Location lookup timed out. Please try again.');
    } catch (_) {
      _showMessage('Unable to fetch your location right now.');
    } finally {
      if (mounted) {
        setState(() => _isLocating = false);
      }
    }
  }

  void _setFilter(String nextFilter) {
    final filtered = _filteredServicesFor(nextFilter);
    if (filtered.isEmpty) {
      return;
    }

    setState(() {
      _activeFilter = nextFilter;
      if (!filtered.any((service) => service.id == _selectedService.id)) {
        _selectedService = filtered.first;
      }
    });

    unawaited(_moveCamera(_selectedService.position));
  }

  Future<void> _searchPlace({String? customQuery}) async {
    final query = (customQuery ?? _searchController.text).trim();
    if (query.isEmpty || _isSearching) {
      return;
    }

    _searchDebounce?.cancel();
    setState(() {
      _isSearching = true;
      _showSuggestions = false;
    });

    FocusScope.of(context).unfocus();

    try {
      final lowerQuery = query.toLowerCase();
      for (final service in _services) {
        if (service.name.toLowerCase().contains(lowerQuery)) {
          if (!mounted) {
            return;
          }

          setState(() {
            _selectedService = service;
            _searchMarker = null;
            _activeFilter = 'All';
          });

          await _moveCamera(service.position);
          return;
        }
      }

      final locations = await locationFromAddress(
        query,
      ).timeout(const Duration(seconds: 10));

      if (!mounted) {
        return;
      }

      if (locations.isEmpty) {
        _showMessage('No places found for "$query".');
        return;
      }

      final target = LatLng(
        locations.first.latitude,
        locations.first.longitude,
      );
      setState(() {
        _searchMarker = Marker(
          markerId: const MarkerId('search_result'),
          position: target,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueViolet,
          ),
          infoWindow: InfoWindow(title: query, snippet: 'Search result'),
        );
      });

      await _moveCamera(target);
    } on TimeoutException {
      _showMessage('Search timed out. Please try a shorter query.');
    } catch (_) {
      _showMessage('Could not find this location. Try a more specific name.');
    } finally {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) {
      return;
    }

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: _defaultCenter,
              zoom: 13.4,
            ),
            mapType: MapType.normal,
            markers: _buildMarkers(),
            myLocationEnabled: _currentLocation != null,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: true,
            onMapCreated: _onMapCreated,
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: Container(
              height: 140,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.surface.withValues(alpha: 0.9),
                    AppColors.surface.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 14,
          left: 14,
          right: 14,
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Material(
                  color: Colors.white.withValues(alpha: 0.96),
                  elevation: 4,
                  shadowColor: Colors.black.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(18),
                  child: Row(
                    children: [
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.search_rounded,
                        color: AppColors.onSurfaceVariant,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          textInputAction: TextInputAction.search,
                          onChanged: _onSearchChanged,
                          onSubmitted: (_) => unawaited(_searchPlace()),
                          decoration: const InputDecoration(
                            hintText: 'Search service or place',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Search',
                        onPressed: () => unawaited(_searchPlace()),
                        icon: _isSearching
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.arrow_forward_rounded),
                      ),
                    ],
                  ),
                ),
                if (_showSuggestions) ...[
                  const SizedBox(height: 8),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 240),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 14,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      itemCount: _suggestions.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                        color: AppColors.outline.withValues(alpha: 0.12),
                      ),
                      itemBuilder: (context, index) {
                        final suggestion = _suggestions[index];
                        return _SearchSuggestionTile(
                          value: suggestion,
                          onTap: () => _onSuggestionTap(suggestion),
                        );
                      },
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final filter = _filters[index];
                      return _FilterChipButton(
                        label: filter,
                        selected: _activeFilter == filter,
                        onTap: () => _setFilter(filter),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                    itemCount: _filters.length,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 14,
          bottom: 170,
          child: _RoundFab(
            icon: _isLocating
                ? Icons.hourglass_top_rounded
                : Icons.my_location_rounded,
            color: AppColors.primary,
            iconColor: Colors.white,
            onPressed: () => _locateUser(moveCamera: true),
          ),
        ),
      ],
    );
  }
}

class _NearbyService {
  const _NearbyService({
    required this.id,
    required this.name,
    required this.type,
    required this.distanceKm,
    required this.position,
    required this.markerHue,
  });

  final String id;
  final String name;
  final String type;
  final double distanceKm;
  final LatLng position;
  final double markerHue;
}

class _FilterChipButton extends StatelessWidget {
  const _FilterChipButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AppColors.primary
          : Colors.white.withValues(alpha: 0.95),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : AppColors.onSurface,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchSuggestionTile extends StatelessWidget {
  const _SearchSuggestionTile({required this.value, required this.onTap});

  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              const Icon(
                Icons.search_rounded,
                size: 18,
                color: AppColors.onSurfaceVariant,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoundFab extends StatelessWidget {
  const _RoundFab({
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.onPressed,
  });

  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onPressed,
        child: SizedBox(
          width: 54,
          height: 54,
          child: Icon(icon, color: iconColor),
        ),
      ),
    );
  }
}
