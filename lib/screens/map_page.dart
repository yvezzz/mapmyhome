import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'parametre.dart';
import 'package:mapmyhome/widgets/methode.dart';
import 'package:mapmyhome/screens/add_house_page.dart';
import 'package:mapmyhome/screens/favorites_page.dart';
import 'package:mapmyhome/screens/reservations_page.dart';
import 'package:mapmyhome/screens/users_management_page.dart';
import 'package:mapmyhome/screens/reports_page.dart';

class MapPage extends StatefulWidget {
  final String role;
  const MapPage({super.key, required this.role});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(3.848, 11.502);

  @override
  void initState() {
    super.initState();
    checkPermissions(context);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // --- Boutons selon rôle ---
  List<Map<String, dynamic>> _getRoleActions() {
    switch (widget.role.toLowerCase()) {
      case 'client':
        return [
          {
            'icon': Icons.search,
            'tooltip': 'Rechercher logement',
            'onTap': () {},
          },
          {
            'icon': Icons.favorite,
            'tooltip': 'Favoris',
            'onTap': () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesPage()),
              );
            },
          },
          {
            'icon': Icons.message,
            'tooltip': 'Contacter propriétaire',
            'onTap': () {},
          },
          {
            'icon': Icons.book_online,
            'tooltip': 'Réserver logement',
            'onTap': () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReservationsPage()),
              );
            },
          },
        ];
      case 'proprietaire':
        return [
          {
            'icon': Icons.add,
            'tooltip': 'Ajouter logement',
            'onTap': () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddHousePage()),
              );
            },
          },
          {'icon': Icons.house, 'tooltip': 'Mes logements', 'onTap': () {}},
          {
            'icon': Icons.assignment,
            'tooltip': 'Réservations',
            'onTap': () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReservationsPage()),
              );
            },
          },
          {'icon': Icons.bar_chart, 'tooltip': 'Statistiques', 'onTap': () {}},
        ];
      case 'admin':
        return [
          {
            'icon': Icons.admin_panel_settings,
            'tooltip': 'Gérer utilisateurs',
            'onTap': () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UsersManagementPage()),
              );
            },
          },
          {'icon': Icons.house, 'tooltip': 'Gérer logements', 'onTap': () {}},
          {
            'icon': Icons.report,
            'tooltip': 'Signalements',
            'onTap': () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReportsPage()),
              );
            },
          },
          {'icon': Icons.category, 'tooltip': 'Catégories', 'onTap': () {}},
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final roleActions = _getRoleActions();

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.blueAccent,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Parametre()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(target: _center, zoom: 12),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapToolbarEnabled: true,
          ),
          // Bloc flottant arrondi pour les boutons
          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:
                    roleActions.map((action) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: FloatingActionButton(
                          heroTag: action['tooltip'],
                          mini: true,
                          onPressed: action['onTap'],
                          tooltip: action['tooltip'],
                          child: Icon(action['icon']),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
