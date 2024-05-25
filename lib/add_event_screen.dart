import 'package:flutter/material.dart';

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
      // ... your app bar code
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
              Wrap(
                spacing: 8.0,
                children: Colors.primaries.map((color) {
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = color),
                    child: CircleAvatar(
                      backgroundColor: color,
                      child: _selectedColor == color
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  );
                }).toList(),
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
