import 'package:as_website/admin/another.dart';
import 'package:as_website/admin/collection.dart';
import 'package:flutter/material.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  String activeView = 'Collection';

  Widget _adminViewer() {
    switch (activeView) {
      case 'Collection':
        return const Collection();
      case 'Another':
        return const Another();
      default:
        return const Collection();
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
                    leading: const Icon(Icons.collections, size: 20,),
                    title: Text('Collection', style: Theme.of(context).textTheme.bodySmall,),
                    onTap: () => _onViewChange('Collection'),
                  ),
                  ListTile(
                    title: Text('Another', style: Theme.of(context).textTheme.bodySmall,),
                    onTap: () => _onViewChange('Another'),
                  ),
                  ListTile(
                    title: Text('Another', style: Theme.of(context).textTheme.bodySmall,),
                    onTap: () => _onViewChange('Another'),
                  ),
                  ListTile(
                    title: Text('Another', style: Theme.of(context).textTheme.bodySmall,),
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
