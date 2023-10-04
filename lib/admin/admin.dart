import 'package:as_website/admin/accueil_admin.dart';
import 'package:as_website/admin/another.dart';
import 'package:as_website/admin/medias.dart';
import 'package:flutter/material.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  String activeView = 'Accueil';
  bool _isWorking = false;

  Widget _adminViewer() {
    switch (activeView) {
      case 'Médias':
        return const Medias();
      case 'Accueil':
        return AccueilAdmin(_onWorking);
      case 'Another':
        return const Another();
      default:
        return const Medias();
    }
  }

  _onViewChange(String view) {
    setState(() {
      activeView = view;
    });
  }

  _onWorking() {
    setState(() {
      _isWorking = !_isWorking;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Stack(
              children: [
                ListView(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.collections,
                      size: 20,
                    ),
                    title: Text(
                      'Médias',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    onTap: () => _onViewChange('Médias'),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.home_outlined,
                      size: 20,
                    ),
                    title: Text(
                      'Accueil',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    onTap: () => _onViewChange('Accueil'),
                  ),
                  ListTile(
                    title: Text(
                      'Another',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    onTap: () => _onViewChange('Another'),
                  ),
                  ListTile(
                    title: Text(
                      'Another',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    onTap: () => _onViewChange('Another'),
                  ),
                ],
              ),
              if (_isWorking) Container(
                color: Colors.blue.withOpacity(0.1),
              ),
              ],
              
            ),
          ),
          Expanded(
            flex: 9,
            child: _adminViewer(),
          ),
        ],
      ),
    );
  }
}
