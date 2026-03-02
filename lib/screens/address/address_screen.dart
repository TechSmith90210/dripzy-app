import 'package:dripzy/blocs/address/address_bloc.dart';
import 'package:dripzy/blocs/address/address_event.dart';
import 'package:dripzy/blocs/address/address_state.dart';
import 'package:dripzy/core/router/routes.dart';
import 'package:dripzy/models/address/address_model.dart';
import 'package:dripzy/screens/address/widgets/address_tile_widget.dart';
import 'package:dripzy/widgets/custom_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  void initState() {
    super.initState();
    _fetchAddresses();
  }

  void _fetchAddresses() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddressBloc>().add(GetAddresses());
    });
  }

  Future<void> _onRefresh() async {
    context.read<AddressBloc>().add(GetAddresses());
  }

  void _onTapAddress([Address? address]) async {
    // Await the push so we refresh when coming back
    await context.push(AppRoutes.addressForm, extra: address);
    if (mounted) _fetchAddresses();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return Scaffold(
      backgroundColor: color.surface, // Clean, modern background
      appBar: AppBar(
        title: const Text("My Addresses"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: color.surface,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: color.onSurface,
        ),
      ),
      body: BlocConsumer<AddressBloc, AddressState>(
        listener: (context, state) {
          if (state.error != null) {
            CustomAlert.show(context, message: state.error!);
          }
        },
        builder: (context, state) {
          if (state.status == AddressStatus.loading &&
              state.addresses.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.addresses.isEmpty) {
            return _buildEmptyState(color);
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            displacement: 20,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: state.addresses.length,
              itemBuilder: (context, index) {
                final address = state.addresses[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: AddressTileWidget(
                    address: address,
                    onTap: () => _onTapAddress(address),
                    isSelected: state.selectedId == address.id,
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _onTapAddress(),
        elevation: 2,
        backgroundColor: color.tertiary,
        icon: Icon(Icons.add_rounded, color: color.onTertiary),
        label: Text(
          "Add New",
          style: TextStyle(
            color: color.onTertiary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme color) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: color.primaryContainer.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_on_outlined,
              size: 48,
              color: color.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "No Addresses Saved",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Add a delivery address to get started with your orders.",
              textAlign: TextAlign.center,
              style: TextStyle(color: color.outline),
            ),
          ),
        ],
      ),
    );
  }
}
