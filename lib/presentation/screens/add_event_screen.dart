import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udevs_task/domain/entities/event.dart';
import 'package:udevs_task/presentation/bloc/add_event/add_event_bloc.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDescController = TextEditingController();
  final TextEditingController _eventLocationController =
      TextEditingController();
  final TextEditingController _eventTimeController = TextEditingController();
  Color _selectedColor = Colors.blue;
  DateTime _selectedDateTime = DateTime.now();

  // Reusable input decoration style
  InputDecoration _inputDecoration() => InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      );

  // Method to build a TextFormField with the common style
  Widget _buildTextFormField({
    required TextEditingController controller,
    int? maxLines = 1,
    Icon? suffixIcon,
    String? Function(String?)? validator,
  }) =>
      TextFormField(
        maxLines: maxLines,
        controller: controller,
        validator: validator,
        decoration: _inputDecoration().copyWith(suffixIcon: suffixIcon),
      );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddEventBloc, AddEventState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('Add Event',
              style: TextStyle(color: Colors.black, fontSize: 20)),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: _buildBody(context, state),
        bottomNavigationBar: GestureDetector(
          onTap: () {
            // if (_formKey.currentState!.validate()) {
            //   context.read<AddEventBloc>().add(
            //         Event(
            //           name: _eventNameController.text,
            //           description: _eventDescController.text,
            //           location: _eventLocationController.text,
            //           color: _selectedColor,
            //           dateTime: _selectedDateTime,
            //         ),
            //       );
            // }
          },
          child: Container(
            height: 60,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildBody(BuildContext context, AddEventState state) {
    if (state is AddEventSuccess) {
      // Tadbir muvaffaqiyatli qo'shilganda ekrandan chiqamiz
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tadbir muvaffaqiyatli qo\'shildi')),
      );
    } else if (state is AddEventError) {
      // Xatolik yuz berganda xabar ko'rsatamiz
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error)),
      );
    }
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Name
              Text('Event Name', style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 4),
              _buildTextFormField(
                  controller: _eventNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an event name';
                    }
                    return null;
                  }),
              //Event Description
              const SizedBox(height: 16),
              Text('Event Description',
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 4),
              _buildTextFormField(
                maxLines: 4,
                controller: _eventDescController,
              ),
              //Event Location
              const SizedBox(height: 16),
              Text('Event Location',
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 4),
              _buildTextFormField(
                controller: _eventLocationController,
                suffixIcon: const Icon(
                  Icons.location_on_rounded,
                  color: Colors.blue,
                ),
              ),

              // Priority Colors
              const SizedBox(height: 16),
              Text('Priority Color',
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 4),
              SizedBox(
                width: 70,
                child: DropdownButtonFormField<Color>(
                  value: _selectedColor,
                  onChanged: (color) => setState(() => _selectedColor = color!),
                  items: [
                    Colors.blue,
                    Colors.red,
                    Colors.yellow,
                  ].map((Color color) {
                    // Map the colors directly
                    return DropdownMenuItem<Color>(
                      value: color,
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: color),
                        ),
                      ),
                    );
                  }).toList(),
                  decoration: _inputDecoration(), // Use the decoration here
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.blue,
                  ),
                ),
              ),
              // Event Time
              const SizedBox(height: 16),
              Text('Event time', style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 4),
              TextFormField(
                readOnly: true,
                controller: _eventTimeController, // Use the time controller
                decoration: _inputDecoration().copyWith(
                  suffixIcon:
                      const Icon(Icons.calendar_today, color: Colors.blue),
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDateTime,
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2025),
                  );
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
                  );
                  if (picked != null && time != null) {
                    setState(() {
                      _selectedDateTime = DateTime(
                        picked.year,
                        picked.month,
                        picked.day,
                        time.hour,
                        time.minute,
                      );
                      // Update the text field
                      _eventTimeController.text = _selectedDateTime.toString();
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
