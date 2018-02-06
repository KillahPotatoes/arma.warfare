SplitString = {
  _marker = _this select 0;
  _index = _this select 1;
  
  _tempmarker = toArray _marker; 
  _tempmarker resize _index;
  toString _tempmarker;
};