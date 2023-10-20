import 'package:as_website/admin/const.dart';
import 'package:flutter/material.dart';

import '../models/photo.dart';

class AllPortfoliosAdmin extends StatefulWidget {
  const AllPortfoliosAdmin({super.key, required this.handlePageChange});

  final Function(String) handlePageChange;

  @override
  State<AllPortfoliosAdmin> createState() => _AllPortfoliosAdminState();
}

class _AllPortfoliosAdminState extends State<AllPortfoliosAdmin> {
  Stream<List<Photo>> portfoliosStream = mediasService.getLeadsStream();
  List<Photo> photos = [];
  bool _isDeleting = false;

  _addPortfolio() async {
    final name = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Ajouter un portfolio'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Nom du portfolio',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
    if (name != null) {
      widget.handlePageChange(name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Text(
                'Portfolios',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(width: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(
                    width: 1.0,
                    color: Colors.black,
                  ),
                ),
                onPressed: _addPortfolio,
                child: Text(
                  'Ajouter',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              const Expanded(child: SizedBox()),
              IconButton(
                onPressed: () => setState(() => _isDeleting = !_isDeleting),
                icon: Icon(
                  _isDeleting ? Icons.delete_outline : Icons.collections,
                  size: 32,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 24),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: StreamBuilder(
              stream: portfoliosStream,
              builder: ((context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Colors.black,
                  ));
                }
                photos = snapshot.data!;
                return GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 1,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: photos.length,
                    itemBuilder: (context, index) {
                      final photo = photos[index];
                      return GestureDetector(
                        onTap: () => setState(() {
                          if (_isDeleting) {
                            // mediasService.deletePhoto(photo);
                          } else {
                            widget.handlePageChange(photo.lead);
                          }
                        }),
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.network(
                                  width: 150,
                                  height: 150,
                                  photo.url,
                                  fit: BoxFit.cover,
                                ),
                                if (_isDeleting)
                                  const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  )
                              ],
                            ),
                            Text(
                              photo.lead,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      );
                    });
              }),
            ),
          ),
        ),
      ],
    );
  }
}
