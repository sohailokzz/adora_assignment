import 'package:adora_assignment/screens/home_screen/home_screen_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../routes/route_name.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeScreenVM(),
      child: const HomeScreenContent(),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Location Tracker"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, RouteName.historyScreen);
            },
            icon: const Icon(Icons.history),
          ),
        ],
      ),
      body: Center(
        child: Consumer<HomeScreenVM>(
          builder: (context, vm, child) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Current Location",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  if (vm.isLoading)
                    const CircularProgressIndicator()
                  else ...[
                    Text(
                      "Latitude: ${vm.latitude ?? '--'}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Longitude: ${vm.longitude ?? '--'}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],

                  const SizedBox(height: 30),

                  ElevatedButton(
                    onPressed: vm.fetchLocation,
                    child: const Text("Get Current Location"),
                  ),

                  const SizedBox(height: 20),

                  SwitchListTile(
                    title: const Text("Live Tracking"),
                    value: vm.isTracking, // optional idea below
                    onChanged: (value) {
                      if (value) {
                        vm.startBackgroundTracking();
                        vm.startLiveTracking();
                      } else {
                        vm.stopBackgroundTracking();
                        vm.stopLiveTracking();
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
