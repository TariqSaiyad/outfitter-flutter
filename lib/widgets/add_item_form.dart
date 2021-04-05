import 'package:Outfitter/constants/constants.dart';
import 'package:Outfitter/helpers/helper_methods.dart';
import 'package:Outfitter/models/item.dart';
import 'package:flutter/material.dart';

class AddItemFormWidget extends StatefulWidget {
  final Function onFormComplete;
  final String image;

  const AddItemFormWidget(
      {Key key, @required this.image, @required this.onFormComplete})
      : super(key: key);

  @override
  _AddItemFormWidgetState createState() => _AddItemFormWidgetState();
}

class _AddItemFormWidgetState extends State<AddItemFormWidget> {
  final EdgeInsetsGeometry _fieldPadding =
      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8);

  final _formKey = GlobalKey<FormState>();

  List<DropdownMenuItem<String>> _dropdownCategoryItems;
  List<DropdownMenuItem<String>> _dropdownColorItems;
  List<DropdownMenuItem<String>> _dropdownCodeItems;
  List<DropdownMenuItem<String>> _dropdownTypeItems;
  String name = "";
  String category = "";
  String color = "";
  String code = "";
  String type = "";

  @override
  void initState() {
    super.initState();
    _dropdownCategoryItems = _buildList(CATEGORY_LIST);
    _dropdownColorItems = _buildList(COLORS_LIST.keys.toList(), isCol: true);
    _dropdownCodeItems = _buildList(DRESS_CODES);
    _dropdownTypeItems = _buildList(CLOTHING_TYPES);
    category = _dropdownCategoryItems[0].value;
    color = _dropdownColorItems[0].value;
    code = _dropdownCodeItems[0].value;
    type = _dropdownTypeItems[0].value;
  }

  // Save the form inputs
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  /// Validate the form and create the Item.
  void validateAndSubmit(BuildContext context) async {
    print("here");
    if (validateAndSave()) {
      FocusScope.of(context).unfocus();
      //Create item and add it using callback. Reset form afterwards.
      var i = Item(widget.image, name, type, code, color, category);
      widget.onFormComplete(i);
      _formKey.currentState.reset();
    }
  }

  bool _validate() {
    return _formKey != null &&
        _formKey.currentState != null &&
        _formKey.currentState.validate();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _itemNameField(),
            _itemCategoryField(),
            _itemColorField(),
            _itemCodeField(),
            _itemTypeField(),
            Padding(
              padding: _fieldPadding,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                elevation: 4,
                color: Theme.of(context).primaryColor,
                splashColor: Theme.of(context).accentColor,
                onPressed:
                    _validate() ? () => validateAndSubmit(context) : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Add Item"),
                    const SizedBox(width: 10, height: 40),
                    const Icon(Icons.check)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _itemNameField() {
    return Padding(
      padding: _fieldPadding,
      child: TextFormField(
        onEditingComplete: () {
          FocusScope.of(context).unfocus();
        },
        autofocus: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        maxLines: 1,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            isDense: false,
            errorStyle: TextStyle(
              color: Colors.red[100],
            ),
            labelText: "Item Name",
            hintText: "My denim jacket"),
        validator: (value) => value.isEmpty ? 'Name can\'t be empty' : null,
        onSaved: (value) => name = value.trim(),
      ),
    );
  }

  Widget _itemCategoryField() {
    return DropDownWidget(
      title: 'Category',
      list: _dropdownCategoryItems,
      onChanged: (val) => setState(() => category = val),
      value: category,
      col: Theme.of(context).primaryColor,
    );
  }

  Widget _itemColorField() {
    return DropDownWidget(
      title: 'Colour',
      list: _dropdownColorItems,
      onChanged: (val) => setState(() => color = val),
      value: color,
    );
  }

  Widget _itemCodeField() {
    return DropDownWidget(
      title: 'Dress Code',
      list: _dropdownCodeItems,
      onChanged: (val) => setState(() => code = val),
      value: code,
      col: Theme.of(context).primaryColor,
    );
  }

  Widget _itemTypeField() {
    return DropDownWidget(
      title: 'Clothing Type',
      list: _dropdownTypeItems,
      onChanged: (val) => setState(() => type = val),
      value: type,
      col: Theme.of(context).primaryColor,
    );
  }

  List<DropdownMenuItem<String>> _buildList(List input, {bool isCol = false}) {
    var items = <DropdownMenuItem<String>>[];
    for (var i in input) {
      items.add(
          DropdownMenuItem(value: i, child: isCol ? _colorItem(i) : Text(i)));
    }
    return items;
  }

  Widget _colorItem(i) {
    return Row(
      children: [
        CircleAvatar(maxRadius: 15, backgroundColor: COLORS_LIST[i]),
        const SizedBox(width: 10),
        Text(Helper.capitalise(i))
      ],
    );
  }
}

class DropDownWidget extends StatelessWidget {
  final EdgeInsetsGeometry _fieldPadding =
      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8);
  final String title, value;
  final List list;
  final Function onChanged;
  final Color col;

  DropDownWidget(
      {Key key, this.title, this.value, this.list, this.onChanged, this.col})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: _fieldPadding,
        child: OutlinedButton(
            onPressed: () {},
            child: DropdownButtonFormField(
                dropdownColor: col,
                decoration: InputDecoration(
                    enabledBorder: InputBorder.none, labelText: title),
                items: list,
                value: value,
                onChanged: (val) => onChanged(val))));
  }
}
