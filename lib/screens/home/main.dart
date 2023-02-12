import 'dart:developer';

import 'package:flutter/material.dart';

import 'fields.dart';

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final configs = defaultFields();

  handleSubmit() {
    final map = Map<String, dynamic>.fromEntries(
        configs.map((e) => MapEntry<String, dynamic>(e.name, e.value)));
    log(map.toString());
  }

  Widget renderText(FormFieldState<FieldConfig> state) {
    final config = state.value;
    if (config == null) return const Text("...");
    String? value = config.value == null ? null : '${config.value}';
    dynamic cast(String? value) {
      if (value == null) return value;
      switch (config.type) {
        case FieldType.number:
          return int.tryParse(value) ?? 0;
        case FieldType.decimal:
          return double.tryParse(value) ?? 0;
        default:
          return value;
      }
    }

    return Column(children: [
      TextFormField(
          initialValue: value,
          keyboardType: config.getTextInputType(),
          maxLines: config.type == FieldType.multiline ? 5 : 1,
          onSaved: (value) => {config.value = cast(value)},
          onChanged: (value) => {config.value = cast(value)},
          decoration:
              InputDecoration(labelText: config.label, hintText: config.hint))
    ]);
  }

  Widget renderRadio(FormFieldState<FieldConfig> state) {
    final config = state.value;
    final options = config?.options;
    if (config == null || options == null) return const Text("...");

    Widget renderOption<T>(MapEntry<String, T> e) {
      return RadioListTile<T>(
          value: e.value,
          groupValue: config.value,
          title: Text(e.key),
          onChanged: ((value) => config.value = value));
    }

    return Column(children: [
      SizedBox(
        //You can define in as your screen's size width,
        //or you can choose a double
        //ex:
        //width: 100,
        //this is the total width of your screen
        child: Text(
          config.label,
          maxLines: 1000,
          style: Theme.of(context).textTheme.labelMedium,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      ...options.entries.map<Widget>(renderOption)
    ]);
  }

  Widget renderSubmit(FormFieldState<FieldConfig> state) {
    final config = state.value;
    disableOthers(FieldConfig element) {
      if (element.type == FieldType.submit) {
        element.value = false;
      }
    }

    if (config == null) return const Text("...");
    return Column(children: [
      ElevatedButton(
          onPressed: () {
            configs.forEach(disableOthers);
            config.value = true;
            Form.of(context)?.save();
            handleSubmit();
          },
          child: Text(config.label))
    ]);
  }

  FormField<FieldConfig> getFormField(FieldConfig config) {
    switch (config.type) {
      case FieldType.text:
      case FieldType.multiline:
      case FieldType.number:
      case FieldType.decimal:
        return FormField<FieldConfig>(
            builder: renderText, initialValue: config);
      case FieldType.radio:
        return FormField<FieldConfig>(
            builder: renderRadio, initialValue: config);
      case FieldType.submit:
        return FormField<FieldConfig>(
            builder: renderSubmit, initialValue: config);
      case FieldType.checkbox:
        throw UnimplementedError("Not yet implemented");
    }
  }

  Widget renderField(FieldConfig config) {
    return Padding(
        padding: const EdgeInsets.all(10.0), child: getFormField(config));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          primary: true,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          children: configs.map<Widget>(renderField).toList(),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
