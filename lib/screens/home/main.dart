import 'dart:developer';

import 'package:flutter/material.dart';

// const MyHomePage(title: 'Flutter Demo Home Page'),

enum FormType { number, multiline, text, radio, checkbox, submit }

class FormConfig<T> {
  final FormType type;
  final String name;
  T value;
  final String label;
  final String hint;
  FormConfig(this.type, this.name, this.value, this.label, [this.hint = ""]);
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final configs = [
    FormConfig(FormType.text, "name", "", "Enter name"),
    FormConfig(FormType.submit, "done", false, "Submit")
  ];

  handleSubmit() {
    final map = Map<String, dynamic>.fromEntries(
        configs.map((e) => MapEntry<String, dynamic>(e.name, e.value)));
    log(map.toString());
  }

  Widget renderText(FormFieldState<FormConfig> state) {
    final config = state.value;
    if (config == null) return const Text("...");
    String value = config.value;
    return Column(children: [
      TextFormField(
          initialValue: value,
          onSaved: (value) => {config.value = value},
          onChanged: (value) => {config.value = value},
          decoration:
              InputDecoration(labelText: config.label, hintText: config.hint))
    ]);
  }

  Widget renderSubmit(FormFieldState<FormConfig> state) {
    final config = state.value;
    disableOthers(FormConfig element) {
      if (element.type == FormType.submit) {
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

  FormField<FormConfig> getFormField(FormConfig config) {
    switch (config.type) {
      case FormType.text:
        return FormField<FormConfig>(builder: renderText, initialValue: config);
      case FormType.submit:
        return FormField<FormConfig>(
            builder: renderSubmit, initialValue: config);
      case FormType.checkbox:
      case FormType.number:
      case FormType.multiline:
      case FormType.radio:
        throw UnimplementedError("Not yet implemented");
    }
  }

  Widget renderField(FormConfig config) {
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
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                child: Column(children: configs.map(renderField).toList()))));
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
