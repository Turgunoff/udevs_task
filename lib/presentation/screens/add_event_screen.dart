// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:udevs_task/domain/entities/event.dart';
import 'package:udevs_task/presentation/bloc/add_event/add_event_bloc.dart';
import 'package:udevs_task/presentation/screens/home_screen.dart';

class AddEventScreen extends StatefulWidget {
  final Event? event;
  const AddEventScreen({super.key, this.event});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _eventNameController;
  late TextEditingController _eventDescController;
  late TextEditingController _eventLocationController;
  TextEditingController _selectedStartTime = TextEditingController();
  TextEditingController _selectedEndTime = TextEditingController();
  Color _selectedColor = Colors.blue;
  DateTime _selectedDateTime = DateTime.now();
  String type = '';

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      //  Edit mode
      _eventNameController = TextEditingController(text: widget.event!.name);
      _eventDescController =
          TextEditingController(text: widget.event!.description);
      _eventLocationController =
          TextEditingController(text: widget.event!.location);
      _selectedStartTime = TextEditingController(
          text:
              DateFormat('yyyy-MM-dd - kk:mm').format(widget.event!.startTime));
      _selectedEndTime = TextEditingController(
          text: DateFormat('yyyy-MM-dd - kk:mm').format(widget.event!.endTime));
      type = widget.event!.type;
    } else {
      // New event Add mode
      _eventNameController = TextEditingController();
      _eventDescController = TextEditingController();
      _eventLocationController = TextEditingController();
      _selectedStartTime = TextEditingController();
      _selectedEndTime = TextEditingController();
      type = '';
    }
  }

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
    return BlocConsumer<AddEventBloc, AddEventState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(widget.event == null ? 'Add Event' : 'Update Event',
                style: const TextStyle(color: Colors.black, fontSize: 20)),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: _buildBody(context, state),
          bottomNavigationBar: GestureDetector(
            onTap: () {
              if (_formKey.currentState!.validate()) {
                DateTime? startTime =
                    DateTime.tryParse(_selectedStartTime.text);
                DateTime? endTime = DateTime.tryParse(_selectedEndTime.text);

                if (startTime == null || endTime == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Incorrect date or time format!')),
                  );
                  return;
                }

                if (_selectedColor == Colors.blue) {
                  type = 'B';
                } else if (_selectedColor == Colors.red) {
                  type = 'R';
                } else if (_selectedColor == Colors.purple) {
                  type = 'Y';
                }
                final event = Event(
                  id: widget.event?.id,
                  name: _eventNameController.text,
                  description: _eventDescController.text,
                  location: _eventLocationController.text,
                  type: type,
                  startTime: startTime,
                  endTime: endTime,
                );

                context.read<AddEventBloc>().add(
                      widget.event ==
                              null // Sending a suitable event depending on the condition
                          ? AddEventSubmitted(event)
                          : UpdateEventSubmitted(event),
                    );
              }
            },
            child: Container(
              height: 60,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.event == null ? 'Add Event' : 'Update Event',
                    style: const TextStyle(
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
      },
      listener: (context, state) async {
        if (state is AddEventSuccess) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const HomeScreen()),
              (route) => false);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
              widget.event == null
                  ? 'The event was successfully added'
                  : 'The event was successfully updated',
            )),
          );
        } else if (state is AddEventError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
    );
  }

  Widget _buildBody(BuildContext context, AddEventState state) {
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an event name';
                    }
                    return null;
                  }),
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an event name';
                    }
                    return null;
                  }),

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
                    Colors.purple,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.45,
                    child: TextFormField(
                      readOnly: true,
                      controller: _selectedStartTime, // Use the time controller
                      decoration: _inputDecoration().copyWith(),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDateTime,
                          firstDate: DateTime(2023),
                          lastDate: DateTime(2025),
                        );
                        final time = await showTimePicker(
                          context: context,
                          initialTime:
                              TimeOfDay.fromDateTime(_selectedDateTime),
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
                            _selectedStartTime.text =
                                DateFormat('yyyy-MM-dd HH:mm')
                                    .format(
                                      _selectedDateTime,
                                    )
                                    .toString();
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.45,
                    child: TextFormField(
                      readOnly: true,
                      controller: _selectedEndTime, // Use the time controller
                      decoration: _inputDecoration().copyWith(),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDateTime,
                          firstDate: DateTime(2023),
                          lastDate: DateTime(2025),
                        );
                        final time = await showTimePicker(
                          context: context,
                          initialTime:
                              TimeOfDay.fromDateTime(_selectedDateTime),
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
                            _selectedEndTime.text =
                                DateFormat('yyyy-MM-dd HH:mm')
                                    .format(
                                      _selectedDateTime,
                                    )
                                    .toString();
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
