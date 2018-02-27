split_string = {
  params ["_marker", "_charNumber"];
  
  _sub_string_1 = toArray _marker;   
  _sub_string_1 resize _charNumber;
  _sub_string_1 = toString _sub_string_1;

  _sub_string_2 = toArray _marker; 
  _sub_string_2 deleteRange [0, _charNumber];
  _sub_string_2 = toString _sub_string_2;

  [_sub_string_1, _sub_string_2];
};

replace_underscore = {
  params ["_str"];

  private _str = _str splitString "_";
  _str joinString " ";
}

get_direction = {
  params ["_pos1", "_pos2"];

  private _dir = _pos1 getDir _pos2;

  switch true do {
    case ([_dir, 0, 10] call is_between): { "North" };
    case ([_dir, 11, 80] call is_between): { hint "North East" };
    case ([_dir, 81, 100] call is_between): { hint "East" };
    case ([_dir, 101, 170] call is_between): { hint "South East" };
    case ([_dir, 171, 190] call is_between): { hint "South" };
    case ([_dir, 191, 260] call is_between): { hint "South West" };
    case ([_dir, 261, 280] call is_between): { hint "West" };
    case ([_dir, 281, 350] call is_between): { hint "North West" };
    case ([_dir, 351, 360] call is_between): { hint "North" };       
  };
};

is_between = {
  params ["_val", "_start", "_end"];

  _val >= start && _val <= end;
};