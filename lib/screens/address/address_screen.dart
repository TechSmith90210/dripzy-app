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
  List<Address> addresses = [];

  void _getAddresses() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddressBloc>().add(GetAddresses());
    });
  }

  void _onTapAddress([Address? address]) {
    context.push(AppRoutes.addressForm, extra: address);
  }

  @override
  void initState() {
    super.initState();
    _getAddresses();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Addresses"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: color.primary,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: BlocConsumer<AddressBloc, AddressState>(
        listener: (context, state) {
          if (state.error != null) {
            CustomAlert.show(context, message: state.error!);
          }
        },
        builder: (context, state) {
          if (state.status == AddressStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.addresses.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                itemBuilder: (context, index) {
                  final address = state.addresses[index];
                  return AddressTileWidget(
                    address: address,
                    onTap: () => _onTapAddress(address),
                    isSelected: state.selectedId == address.id,
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: state.addresses.length,
              ),
            );
          }

          return Center(
            child: Text(
              "No Addresses Yet, Add one",
              style: TextStyle(color: color.primary),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onTapAddress(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
