import 'package:cost_estimator/logic/housing_cost.dart';
import 'package:flutter/material.dart';
import 'fields.dart';

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final configs = defaultFields();
  bool dialogShown = false;

  handleSubmit() {
    setState(() {
      dialogShown = true;
    });
  }

  Widget renderResult() {
    final map = Map<CostVariable, dynamic>.fromEntries(
        configs.map((e) => MapEntry<CostVariable, dynamic>(e.name, e.value)));

    return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("The estimated total cost is (in naira)",
                style: Theme.of(context).textTheme.headlineSmall),
            Text(
              getHousingCost({...map}).toStringAsFixed(2),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Padding(
                padding: const EdgeInsets.only(top: 32),
                child: TextButton(
                    child: const Text("View exlanation"),
                    onPressed: () {
                      // TODO
                    }))
          ],
        ));
  }

  Widget renderHintText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: SizedBox(
        width: 1E12,
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.start,
        ),
      ),
    );
  }

  Widget renderText(FormFieldState<FieldConfig> state) {
    final config = state.value;
    if (config == null) return const Text("...");
    String? value = config.value == null ? null : '${config.value}';
    dynamic cast(String? value) {
      value ??= '';
      switch (config.type) {
        case FieldType.number:
          return int.tryParse(value) ?? 0;
        case FieldType.decimal:
          return double.tryParse(value) ?? 0.0;
        default:
          return value;
      }
    }

    return Column(children: [
      TextFormField(
          initialValue: value,
          keyboardType: config.getTextInputType(),
          maxLines: config.type == FieldType.multiline ? 5 : 1,
          validator: (value) {
            var max = config.options?[FieldConfig.fieldValueMax];
            if (max != null && cast(value) > max) {
              return "Value must not exceed $max";
            }
            var min = config.options?[FieldConfig.fieldValueMin];
            if (min != null && cast(value) > min) {
              return "Value must not be less than $min";
            }
            return null;
          },
          onSaved: (value) => {config.value = cast(value)},
          onChanged: (value) => {config.value = cast(value)},
          decoration: InputDecoration(labelText: config.label)),
      renderHintText(config.hint)
    ]);
  }

  Widget renderRadio<T>(FormFieldState<FieldConfig<T>> state) {
    final config = state.value;
    final options = config?.options;
    if (config == null || options == null) return const Text("...");

    Widget renderRadioItem(MapEntry<String, T> e) {
      return RadioListTile<T>(
        value: e.value,
        groupValue: config.value,
        title: Text(e.key),
        onChanged: (value) {
          config.value = value;
          state.didChange(config);
        },
      );
    }

    TextTheme theme = Theme.of(context).textTheme;
    return Column(children: [
      //You can define in as your screen's size width,
      //or you can choose a double
      //ex:
      //width: 100,
      //this is the total width of your screen
      SizedBox(
          width: 1E12,
          child: Text(
            config.label,
            style: (theme.labelMedium ?? theme.bodyMedium)
                ?.copyWith(color: const Color(0xad000000)),
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
          )),
      ...options.entries.map<Widget>(renderRadioItem)
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

  Widget renderField(FieldConfig config) {
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

    return Padding(
        padding: const EdgeInsets.all(8.0), child: getFormField(config));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
            padding: const EdgeInsets.only(left: 8, top: 12, bottom: 12),
            child: Image.asset("assets/images/ic_launcher.png")),
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          primary: true,
          padding:
              const EdgeInsets.only(bottom: 24, left: 24, right: 24, top: 8),
          children: [
            ...configs.map<Widget>(renderField).toList(),
            dialogShown
                ? AlertDialog(content: renderResult())
                : const SizedBox.shrink()
          ],
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
