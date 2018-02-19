drawSector = { 
 _location = _this select 0; 
 _faction = (_location getVariable "faction"); 
 _color = "ColorGrey";
 
 if (!(_faction isEqualTo civilian)) then {
     _color = [_faction, true] call BIS_fnc_sideColor;
 };

 _marker = _location getVariable "marker"; 
 _markerPos = _location getVariable "pos"; 
 _marker_outline = toString toArray _marker; 

  createMarker [_marker_outline, _markerPos]; 
 _marker_outline setMarkerColor _color; 
 _marker_outline setMarkerShape "ELLIPSE"; 
 _marker_outline setMarkerBrush "SolidBorder"; 
 _marker_outline setMarkerSize [200,200]; 
};

DrawAllSectors = {
    _sectors = _this select 0;

    {
        [_x] call drawSector;
    } forEach _sectors;
}

