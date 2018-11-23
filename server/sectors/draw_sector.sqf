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
 _marker_outline setMarkerSize [arwa_sector_size,arwa_sector_size]; 
};

draw_all_sectors = {
    {
        [_x] call draw_sector;
    } forEach sectors;
};

update_progress_bar = {
    params ["_counter", "_sector", "_side"];
        
    _color = "ColorGrey";
    _opacity = 0;
    
    if (!(_side isEqualTo civilian)) then {
        _color = [_side, true] call BIS_fnc_sideColor;
        _opacity = 0.8;        
    };

    _marker = _sector getVariable marker; 
    _markerPos = _sector getVariable pos; 

    _progress = arwa_sector_size * (_counter/arwa_capture_time);
    
    _markerPos = [(_markerPos select 0), (_markerPos select 1) + 250, _markerPos select 2];
    
    _marker_outline = format["%1-progress", toString toArray _marker]; 
    createMarker [_marker_outline, _markerPos]; 
    _marker_outline setMarkerColor _color; 
    _marker_outline setMarkerAlpha _opacity;
    _marker_outline setMarkerShape "RECTANGLE"; 
    _marker_outline setMarkerBrush "SolidBorder"; 
    _marker_outline setMarkerSize [_progress,20]; 
};
