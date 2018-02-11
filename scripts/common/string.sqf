S_SplitString = {
  _marker = _this select 0;
  _charNumber = _this select 1;
  
  _sub_string_1 = toArray _marker;   
  _sub_string_1 resize _charNumber;
  _sub_string_1 = toString _sub_string_1;

  _sub_string_2 = toArray _marker; 
  _sub_string_2 deleteRange [0, _charNumber];
  _sub_string_2 = toString _sub_string_2;

  [_sub_string_1, _sub_string_2];
};