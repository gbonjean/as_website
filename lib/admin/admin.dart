import 'package:as_website/admin/portfolio_admin.dart';
import 'package:as_website/admin/medias_admin.dart';
import 'package:flutter/material.dart';

import 'all_portfolios_admin.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  String activeView = 'Médias';
  bool _isWorking = false;

  Widget _adminViewer() {
    switch (activeView) {
      case 'Médias':
        return const MediasAdmin();
      case 'Accueil':
        return PortfolioAdmin('Accueil', _onWorking);
      case 'Portfolios':
        return AllPortfoliosAdmin(
          handlePageChange: _onViewChange,
        );
      default:
        return PortfolioAdmin(activeView, _onWorking);
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
                      leading: const Icon(
                        Icons.browse_gallery_outlined,
                        size: 20,
                      ),
                      title: Text(
                        'Portfolios',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      onTap: () => _onViewChange('Portfolios'),
                    ),
                  ],
                ),
                if (_isWorking)
                  Container(
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
