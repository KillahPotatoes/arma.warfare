ARWA_split_string = {
  params ["_marker", "_charNumber"];
  
  _sub_string_1 = toArray _marker;   
  _sub_string_1 resize _charNumber;
  _sub_string_1 = toString _sub_string_1;

  _sub_string_2 = toArray _marker; 
  _sub_string_2 deleteRange [0, _charNumber];
  _sub_string_2 = toString _sub_string_2;

  [_sub_string_1, _sub_string_2];
};

ARWA_replace_underscore = {
  params ["_str"];

  private _str = _str splitString "_";
  _str joinString " ";
};
