import 'package:flutter/material.dart';

import 'package:as_website/private.dart';
import 'package:as_website/pages/portfolio.dart';
import 'package:as_website/admin/admin.dart';
import 'package:as_website/pages/apropos.dart';
import 'package:as_website/pages/galleries.dart';
import 'package:as_website/pages/reportages.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  String activePage = 'ACCUEIL';
  bool isAdmin = false;
  bool showLogin = false;

  Widget _pageViewer() {
    switch (activePage) {
      case 'ACCUEIL':
        return const Portfolio('accueil');
      case 'REPORTAGES':
        return Reportages(handlePageChange: _onPageChange,);
      case 'GALERIES':
        return const Galleries();
      case 'A PROPOS':
        return const APropos();
      case 'ADMIN':
        return const Admin();
      default:
        return Portfolio(activePage);
    }
  }

  _onPageChange(String page) {
    setState(() {
      activePage = page;
    });
  }

  _submitPassword(String value) {
    if (value == password) {
      setState(() {
        isAdmin = true;
        showLogin = false;
        activePage = 'ADMIN';
      });
    } else {
      setState(() {
        showLogin = false;
      });
    }
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => _onPageChange('ACCUEIL'),
                    child: Image.asset(
                      'assets/logo.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 12,
                    height: 25,
                    decoration: BoxDecoration(
                      border: Border(
                          left:
                              BorderSide(color: Colors.grey[300]!, width: 0.5)),
                    ),
                  ),
                  GestureDetector(
                    onLongPress: () {
                      if (!isAdmin) {
                        setState(() {
                          showLogin = true;
                        });
                      }
                    },
                    child: Text(
                      'ANNE SIMONNOT // PHOTOGRAPHIE',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  if (showLogin)
                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: SizedBox(
                        width: 100,
                        height: 50,
                        child: Center(
                          child: Material(
                            child: TextField(
                              obscureText: true,
                              autofocus: true,
                              decoration: null,
                              showCursor: false,
                              onSubmitted: (value) {
                                _submitPassword(value);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  const Expanded(child: SizedBox()),
                  if (isAdmin)
                    Padding(
                      padding: const EdgeInsets.only(right: 48),
                      child: NavItem(
                        name: 'ADMIN',
                        activePage: activePage,
                        handleClick: () => _onPageChange('ADMIN'),
                      ),
                    ),
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
                    name: 'GALERIES',
                    activePage: activePage,
                    handleClick: () => _onPageChange('GALERIES'),
                  ),
                  NavItem(
                    name: 'A PROPOS',
                    activePage: activePage,
                    handleClick: () => _onPageChange('A PROPOS'),
                  ),
                ],
              ),
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
