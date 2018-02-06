drawSector = { 
 _marker = _this select 0; 
 _color = _this select 1;
 _markerPos = getMarkerPos _marker;

 _marker_outline = toString toArray _marker; 
 
  createMarkerLocal [_marker_outline, _markerPos]; 
 _marker_outline setMarkerColorLocal _color; 
 _marker_outline setMarkerShapeLocal "ELLIPSE"; 
 _marker_outline setMarkerBrushLocal "SolidBorder"; 
 _marker_outline setMarkerSizeLocal [200,200]; 
};
