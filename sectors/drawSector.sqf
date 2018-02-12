drawSector = { 
 _location = _this select 0; 
 _faction = (_location getVariable "faction"); 
 _color = warfare_color_inactive;
 
 if (!(_faction isEqualTo civilian)) then {
     _color = [_faction, true] call BIS_fnc_sideColor;
 };

 _marker = _location getVariable "marker"; 
 _markerPos = _location getVariable "pos"; 
 _marker_outline = toString toArray _marker; 

  createMarkerLocal [_marker_outline, _markerPos]; 
 _marker_outline setMarkerColorLocal _color; 
 _marker_outline setMarkerShapeLocal "ELLIPSE"; 
 _marker_outline setMarkerBrushLocal "SolidBorder"; 
 _marker_outline setMarkerSizeLocal [200,200]; 
};

