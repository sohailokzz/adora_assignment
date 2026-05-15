import 'package:adora_assignment/screens/history_screen/history_screen_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HistoryScreenVM()..init(),
      child: const HistoryScreenContent(),
    );
  }
}

class HistoryScreenContent extends StatelessWidget {
  const HistoryScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryScreenVM>(
      builder: (context, vm, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Location History"),
          ),
          body: vm.locations.isEmpty
              ? const Center(
                  child: Text("No location data yet"),
                )
              : ListView.builder(
                  itemCount: vm.locations.length,
                  itemBuilder: (context, index) {
                    final item = vm.locations[index];

                    return ListTile(
                      leading: const Icon(Icons.location_on),
                      title: Text(
                        "${item.lat}, ${item.lng}",
                      ),
                      subtitle: Text(
                        item.timestamp.toString(),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
