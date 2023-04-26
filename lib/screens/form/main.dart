import 'package:cost_estimator/components/format_amount.dart';
import 'package:cost_estimator/components/theme.dart';
import 'package:cost_estimator/logic/housing_cost.dart';
import 'package:flutter/material.dart';
import 'fields.dart';

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  // TODO: find a way to store wrong values since FieldConfig.value is typed
  final configs = defaultFields();

  int requestId = 0;
  CostInfo? info;
  bool showResult = false;
  bool showError = false;
  handleSubmit() async {
    info = CostInfo.from(CostInfoMap.fromEntries(configs.map((e) =>
        MapEntry<CostVariable, double>(
            e.name, e.type == FieldType.submit ? 0.0 : e.value * 1.0 ?? 0.0))));
    setState(() {
      showResult = false;
      showError = false;
      showDialog(context: context, builder: renderResult);
    });
  }

  Widget renderResult(BuildContext context) {
    return Container(
        constraints: BoxConstraints.loose(const Size.fromHeight(300)),
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          if (!showError && !showResult) {
            (() async {
              final id = ++requestId;
              try {
                await info!.estimatesReady;
                if (id == requestId) {
                  setState(() => showResult = true);
                }
              } catch (e) {
                if (id == requestId) {
                  setState(() => showError = true);
                }
              }
            })();
          }
          return AlertDialog(
            content: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  showError
                      ? Text(
                          "Error sending request. Please check your internet connection.",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(color: Theme.of(context).errorColor))
                      : Text("The estimated total cost is (in naira)",
                          style: Theme.of(context).textTheme.headlineSmall),
                  Padding(
                    padding: const EdgeInsets.only(top: 32, bottom: 16),
                    child: showResult
                        ? Text(
                            formatAmount(info!.estimateCost()),
                            style: Theme.of(context).textTheme.headlineLarge,
                          )
                        : showError
                            ? const Text("")
                            : const CircularProgressIndicator(),
                  ),
                ],
              ),
            ),
            actions: showResult
                ? [
                    TextButton(
                        child: const Text("View explanation"),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context)
                              .pushNamed('/detail', arguments: info);
                        })
                  ]
                : [],
            actionsPadding: const EdgeInsets.all(8),
            actionsAlignment: MainAxisAlignment.center,
          );
        }));
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

  Widget renderTextInput(FormFieldState<FieldConfig> state) {
    final config = state.value;
    if (config == null) return const SizedBox.shrink();

    dynamic cast(String? value, [noValidate = true]) {
      value ??= '';
      switch (config.type) {
        case FieldType.number:
          return noValidate ? int.tryParse(value) ?? 0 : int.parse(value);
        case FieldType.decimal:
          return noValidate
              ? double.tryParse(value) ?? 0.0
              : double.parse(value);
        default:
          return value;
      }
    }

    return Column(children: [
      TextFormField(
          initialValue: config.value == null ? null : '${config.value}',
          keyboardType: config.getTextInputType(),
          maxLines: config.type == FieldType.multiline ? 5 : 1,
          validator: (value) {
            final max = config.options?[FieldConfig.fieldValueMax];
            final num result;
            try {
              result = cast(value, false);
            } catch (e) {
              return "Invalid value supplied";
            }
            if (max != null && result > max) {
              return "Value must not exceed $max";
            }
            var min = config.options?[FieldConfig.fieldValueMin];
            if (min != null && result > min) {
              return "Value must not be less than $min";
            }
            return null;
          },
          onSaved: (value) => {config.value = cast(value)},
          onChanged: (value) {
            state.validate();
            config.value = cast(value);
          },
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
          if (value != null) config.value = value;
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
            FormState form = _formKey.currentState!;
            configs.forEach(disableOthers);
            config.value = true;
            if (form.validate()) {
              form.save();
              handleSubmit();
            }
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
              builder: renderTextInput, initialValue: config);
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
    final padding = GlobalTheme.getWindowPadding(context);
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
          padding: EdgeInsets.only(
              bottom: 24, left: padding, right: padding, top: 8),
          children: [...configs.map<Widget>(renderField).toList()],
        ),
      ),
    );
  }
}

class FormScreen extends StatefulWidget {
  const FormScreen({super.key, required this.title});

  final String title;

  @override
  State<FormScreen> createState() => _FormScreenState();
}
