import 'package:flutter/cupertino.dart';
import 'package:parking_spot_log/core/database/database.dart';

class SavedPlacesScreen extends StatefulWidget {
  final AppDatabase db;
  final Function(TableMapData) onPlaceSelected;
  final VoidCallback? onPlaceDeleted;
  
  const SavedPlacesScreen({
    super.key, 
    required this.db,
    required this.onPlaceSelected,
    this.onPlaceDeleted,
  });

  @override
  State<SavedPlacesScreen> createState() => _SavedPlacesScreenState();
}

class _SavedPlacesScreenState extends State<SavedPlacesScreen> {
  List<TableMapData> _places = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlaces();
  }

  Future<void> _loadPlaces() async {
    try {
      final places = await widget.db.select(widget.db.tableMap).get();
      setState(() {
        _places = places;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading places: $e');
    }
  }

  Future<void> _deletePlace(TableMapData place) async {
    try {
      await widget.db.deleteMap(place.id);
      await _loadPlaces();
      // Notify parent screen about deletion
      if (widget.onPlaceDeleted != null) {
        widget.onPlaceDeleted!();
      }
    } catch (e) {
      print('Error deleting place: $e');
    }
  }

  void _showDeleteConfirmation(TableMapData place) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('🗑️ Delete Parking Spot'),
        content: Text('Are you sure you want to delete parking spot "${place.name ?? 'Unnamed'}"?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Delete'),
            onPressed: () {
              Navigator.of(context).pop();
              _deletePlace(place);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          '🚗 My Parking Spots',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        backgroundColor: CupertinoColors.systemBackground,
        border: Border(
          bottom: BorderSide(
            color: CupertinoColors.separator,
            width: 0.5,
          ),
        ),
      ),
      child: _isLoading
          ? const Center(
              child: CupertinoActivityIndicator(),
            )
          : _places.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.car_fill,
                        size: 64,
                        color: CupertinoColors.systemYellow,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No Saved Parking Spots',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: CupertinoColors.label,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Add parking spots on the map',
                        style: TextStyle(
                          fontSize: 14,
                          color: CupertinoColors.secondaryLabel,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _places.length,
                  itemBuilder: (context, index) {
                    final place = _places[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemBackground,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: CupertinoColors.systemYellow.withOpacity(0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.systemYellow.withOpacity(0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 3),
                          ),
                          BoxShadow(
                            color: CupertinoColors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => widget.onPlaceSelected(place),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // Иконка места парковки
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      CupertinoColors.systemYellow,
                                      CupertinoColors.systemOrange,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: CupertinoColors.systemYellow.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  CupertinoIcons.car_fill,
                                  color: CupertinoColors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Информация о месте
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      place.name ?? 'Unnamed Parking Spot',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: CupertinoColors.label,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      place.address,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: CupertinoColors.secondaryLabel,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Coordinates: ${place.latitude.toStringAsFixed(4)}, ${place.longitude.toStringAsFixed(4)}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: CupertinoColors.tertiaryLabel,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Кнопка навигации
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                minSize: 0,
                                onPressed: () => widget.onPlaceSelected(place),
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        CupertinoColors.systemYellow,
                                        CupertinoColors.systemOrange,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(18),
                                    boxShadow: [
                                      BoxShadow(
                                        color: CupertinoColors.systemYellow.withOpacity(0.3),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    CupertinoIcons.location_fill,
                                    color: CupertinoColors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Кнопка удаления
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                minSize: 0,
                                onPressed: () => _showDeleteConfirmation(place),
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.systemRed,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: const Icon(
                                    CupertinoIcons.trash,
                                    color: CupertinoColors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
