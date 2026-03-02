import 'package:dripzy/blocs/address/address_bloc.dart';
import 'package:dripzy/blocs/address/address_event.dart';
import 'package:dripzy/blocs/address/address_state.dart';
import 'package:dripzy/models/address/address_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

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

    // Clean phone number: strip +91 if it exists so prefixText handles it visually
    String initialPhone = a?.phone ?? '';
    if (initialPhone.contains('+91')) {
      initialPhone = initialPhone.replaceAll('+91', '').trim();
    }
    phoneController = TextEditingController(text: initialPhone);

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

    // Keys match the snake_case expected by your Node.js backend
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

      bloc.add(
        UpdateAddress(addressId: widget.address!.id, updateData: updateData),
      );
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
      debugPrint("[_submit]$address");

      bloc.add(AddAddress(address: address));
      context.pop();
    }
  }

  void _onDelete(ColorScheme color) async {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              "Delete Address",
              style: TextStyle(color: color.primary),
            ),
            content: Text(
              "Are you sure you want to delete this address?",
              style: TextStyle(color: color.primary),
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(),
                child: Text("Cancel", style: TextStyle(color: color.primary)),
              ),
              TextButton(
                onPressed: () {
                  context.read<AddressBloc>().add(
                    DeleteAddress(addressId: widget.address!.id),
                  );

                  context.pop();
                  context.pop();
                },
                child: Text("Delete", style: TextStyle(color: color.error)),
              ),
            ],
          ),
    );
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
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        actions: [
          if (widget.address != null)
            IconButton(
              onPressed: () => _onDelete(color),
              icon: Icon(IconsaxPlusBroken.trash),
            ),
        ],
      ),
      body: BlocListener<AddressBloc, AddressState>(
        listenWhen: (p, c) => p.status != c.status,
        listener: (context, state) {
          // if (state.status == AddressStatus.success) context.pop();
          if (state.status == AddressStatus.failure && state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
          }
        },
        child: BlocBuilder<AddressBloc, AddressState>(
          builder: (context, state) {
            final loading = state.status == AddressStatus.loading;

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            const SizedBox(height: 10),
                            _field(
                              "Label",
                              labelController,
                              hint: "Home / Office / Gym",
                            ),
                            _field(
                              "Receiver Name (optional)",
                              receiverController,
                              required: false,
                              hint: "Who will receive the package?",
                            ),
                            _field(
                              "Phone Number",
                              phoneController,
                              keyboard: TextInputType.phone,
                              prefix: "+91 ",
                              maxLength: 10,
                              hint: "10-digit mobile number",
                            ),
                            _field(
                              "Address Line 1",
                              line1Controller,
                              hint: "Flat No, Building, Street",
                            ),
                            _field(
                              "Address Line 2 (optional)",
                              line2Controller,
                              required: false,
                              hint: "Landmark / Area",
                            ),
                            _field(
                              "Postal Code",
                              postalController,
                              keyboard: TextInputType.number,
                              maxLength: 6,
                              hint: "6-digit PIN",
                            ),

                            // Modern Default Toggle
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: color.surfaceVariant.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: SwitchListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                value: isDefault,
                                title: const Text(
                                  "Set as default address",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                onChanged:
                                    loading
                                        ? null
                                        : (v) => setState(() => isDefault = v),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Bottom Action Button
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: color.primary,
                              foregroundColor: color.onPrimary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: loading ? null : _submit,
                            child:
                                loading
                                    ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                    : Text(
                                      isEditing
                                          ? "Update Address"
                                          : "Save Address",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                          ),
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
    String? prefix,
    int? maxLength,
    String? hint,
  }) {
    final color = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        style: TextStyle(
          color: color.primary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        controller: controller,
        keyboardType: keyboard,
        inputFormatters: [
          if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
          if (keyboard == TextInputType.number ||
              keyboard == TextInputType.phone)
            FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: TextStyle(
            color: color.outline.withOpacity(0.4),
            fontSize: 14,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          prefixText: prefix,
          prefixStyle: TextStyle(
            color: color.primary,
            fontWeight: FontWeight.bold,
          ),
          filled: true,
          fillColor: color.surfaceVariant.withOpacity(0.2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: color.outlineVariant.withOpacity(0.3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: color.primary, width: 1.5),
          ),
          errorStyle: const TextStyle(fontSize: 12),
        ),
        validator: (v) {
          if (!required) return null;
          if (v == null || v.trim().isEmpty) return "$label is required";
          if (maxLength != null && v.trim().length != maxLength) {
            return "Must be $maxLength digits";
          }
          return null;
        },
      ),
    );
  }
}
