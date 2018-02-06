S_SplitString = {
  _marker = _this select 0;
  _charNumber = _this select 1;
  
  _tempmarker = toArray _marker; 
  _tempmarker resize _charNumber;
  toString _tempmarker;
};