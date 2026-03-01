import 'package:dripzy/blocs/address/address_bloc.dart';
import 'package:dripzy/blocs/address/address_event.dart';
import 'package:dripzy/blocs/address/address_state.dart';
import 'package:dripzy/models/address/address_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddressFormPage extends StatefulWidget {
  final Address? address;
  const AddressFormPage({super.key, this.address});

  @override
  State<AddressFormPage> createState() => _AddressFormPageState();
}

class _AddressFormPageState extends State<AddressFormPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController labelController;
  late final TextEditingController receiverController;
  late final TextEditingController phoneController;
  late final TextEditingController line1Controller;
  late final TextEditingController line2Controller;
  late final TextEditingController postalController;

  bool isDefault = false;
  bool get isEditing => widget.address != null;

  @override
  void initState() {
    super.initState();
    final a = widget.address;

    labelController = TextEditingController(text: a?.label ?? '');
    receiverController = TextEditingController(text: a?.receiverName ?? '');
    phoneController = TextEditingController(text: a?.phone ?? '');
    line1Controller = TextEditingController(text: a?.line1 ?? '');
    line2Controller = TextEditingController(text: a?.line2 ?? '');
    postalController = TextEditingController(text: a?.postalCode ?? '');

    isDefault = a?.isDefault ?? false;
  }

  @override
  void dispose() {
    labelController.dispose();
    receiverController.dispose();
    phoneController.dispose();
    line1Controller.dispose();
    line2Controller.dispose();
    postalController.dispose();
    super.dispose();
  }

  String? _nullable(TextEditingController c) =>
      c.text.trim().isEmpty ? null : c.text.trim();

  Map<String, dynamic> _buildUpdateData(Address old) {
    final data = <String, dynamic>{};

    void put(String key, dynamic oldVal, dynamic newVal) {
      if (oldVal != newVal) data[key] = newVal;
    }

    put('label', old.label, labelController.text.trim());
    put('receiver_name', old.receiverName, _nullable(receiverController));
    put('phone', old.phone, phoneController.text.trim());
    put('line1', old.line1, line1Controller.text.trim());
    put('line2', old.line2, _nullable(line2Controller));
    put('postal_code', old.postalCode, postalController.text.trim());
    put('is_default', old.isDefault, isDefault);

    return data;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final bloc = context.read<AddressBloc>();

    if (isEditing) {
      final updateData = _buildUpdateData(widget.address!);

      if (updateData.isEmpty) {
        context.pop();
        return;
      }

      bloc.add(UpdateAddress(
        addressId: widget.address!.id,
        updateData: updateData,
      ));
    } else {
      final address = Address(
        id: '',
        userId: '',
        isDefault: isDefault,
        label: labelController.text.trim(),
        receiverName: _nullable(receiverController),
        phone: phoneController.text.trim(),
        line1: line1Controller.text.trim(),
        line2: _nullable(line2Controller),
        postalCode: postalController.text.trim(),
      );

      bloc.add(AddAddress(address: address));
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Address" : "Add Address"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: color.primary,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: BlocListener<AddressBloc, AddressState>(
        listenWhen: (p, c) => p.status != c.status,
        listener: (context, state) {
          if (state.status == AddressStatus.success) context.pop();

          if (state.status == AddressStatus.failure && state.error != null) {
            print("error is ${state.error}");
          }
        },
        child: BlocBuilder<AddressBloc, AddressState>(
          builder: (context, state) {
            final loading = state.status == AddressStatus.loading;

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            _field("Label", labelController),
                            _field("Receiver Name (optional)", receiverController, required: false),
                            _field("Phone", phoneController, keyboard: TextInputType.phone),
                            _field("Address Line 1", line1Controller),
                            _field("Address Line 2 (optional)", line2Controller, required: false),
                            _field("Postal Code", postalController, keyboard: TextInputType.number),
                            const SizedBox(height: 12),
                            SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              value: isDefault,
                              title: const Text("Set as default"),
                              onChanged: loading ? null : (v) => setState(() => isDefault = v),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: loading ? null : _submit,
                          child: loading
                              ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                              : Text(isEditing ? "Update Address" : "Save Address"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _field(
      String label,
      TextEditingController controller, {
        bool required = true,
        TextInputType keyboard = TextInputType.text,
      }) {
    final color = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        style: TextStyle(color: color.primary),
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (v) {
          if (!required) return null;
          if (v == null || v.trim().isEmpty) return "$label required";
          return null;
        },
      ),
    );
  }
}