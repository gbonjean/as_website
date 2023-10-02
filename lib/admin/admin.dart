import 'package:as_website/admin/another.dart';
import 'package:as_website/admin/medias.dart';
import 'package:flutter/material.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  String activeView = 'Médias';

  Widget _adminViewer() {
    switch (activeView) {
      case 'Médias':
        return const Medias();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: ListView(
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
                ListTile(
                  title: Text(
                    'Another',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  onTap: () => _onViewChange('Another'),
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
