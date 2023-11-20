import 'package:flutter/material.dart';

import 'package:as_website/pages/portfolio.dart';
import 'package:as_website/pages/apropos.dart';
import 'package:as_website/pages/reportages.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  String activePage = 'Accueil';

  Widget _pageViewer() {
    switch (activePage) {
      case 'ACCUEIL':
        return const Portfolio('Accueil');
      case 'REPORTAGES':
        return Reportages(
          handlePageChange: _onPageChange,
        );
      case 'A PROPOS':
        return const APropos();
      default:
        return Portfolio(activePage);
    }
  }

  _onPageChange(String page) {
    setState(() {
      activePage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[300]!,
                ),
              ),
            ),
            alignment: Alignment.center,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => _onPageChange('ACCUEIL'),
                      child: Text(
                        'ANNE SIMONNOT // PHOTOGRAPHIE',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),                     
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    NavItem(
                      name: 'ACCUEIL',
                      activePage: activePage,
                      handleClick: () => _onPageChange('ACCUEIL'),
                    ),
                    NavItem(
                      name: 'REPORTAGES',
                      activePage: activePage,
                      handleClick: () => _onPageChange('REPORTAGES'),
                    ),
                    NavItem(
                      name: 'A PROPOS',
                      activePage: activePage,
                      handleClick: () => _onPageChange('A PROPOS'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _pageViewer(),
          ),
        ],
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  const NavItem(
      {super.key,
      required this.name,
      required this.activePage,
      required this.handleClick});

  final String name;
  final String activePage;
  final Function() handleClick;

  @override
  Widget build(BuildContext context) {
    bool isActive = (name == activePage);

    return Padding(
      padding: const EdgeInsets.only(left: 24),
      child: GestureDetector(
        onTap: isActive ? null : handleClick,
        child: Text(
          name,
          style: isActive
              ? Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.blue, fontWeight: FontWeight.bold)
              : Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
