draw_sector = { 
 params ["_sector"];
 _side = (_sector getVariable owned_by); 
 _color = "ColorGrey";
 
 if (!(_side isEqualTo civilian)) then {
     _color = [_side, true] call BIS_fnc_sideColor;
 };

 _marker = _sector getVariable marker; 
 _markerPos = _sector getVariable pos; 
 _marker_outline = toString toArray _marker; 

  createMarker [_marker_outline, _markerPos]; 
 _marker_outline setMarkerColor _color; 
 _marker_outline setMarkerShape "ELLIPSE"; 
 _marker_outline setMarkerBrush "SolidBorder"; 
 _marker_outline setMarkerSize [sector_size,sector_size]; 
};

draw_all_sectors = {
    {
        [_x] call draw_sector;
    } forEach sectors;
}
