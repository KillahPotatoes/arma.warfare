ARWA_draw_sector = {
 params ["_sector"];
 private _side = (_sector getVariable ARWA_KEY_owned_by);
 private _color = "ColorGrey";

 if (!(_side isEqualTo civilian)) then {
     _color = [_side, true] call BIS_fnc_sideColor;
 };

 private _marker = _sector getVariable ARWA_KEY_marker;
 private _markerPos = getPos _sector;
 private _marker_outline = toString toArray _marker;

  createMarker [_marker_outline, _markerPos];
 _marker_outline setMarkerColor _color;
 _marker_outline setMarkerShape "ELLIPSE";
 _marker_outline setMarkerBrush "SolidBorder";
 _marker_outline setMarkerSize [ARWA_sector_size,ARWA_sector_size];
};

ARWA_draw_sector_name = {
    params ["_sector"];
    private _name = [_sector getVariable ARWA_KEY_target_name] call ARWA_replace_underscore;
    private _markerPos = getPos _sector;

    _location = createLocation ["Name", [_markerPos select 0, (_markerPos select 1) + 50, _markerPos select 2], 200, 200];
    _location setText _name;
};

ARWA_update_progress_bar = {
    params ["_counter", "_sector", "_side"];

    _color = "ColorGrey";
    _opacity = 0;

    if (!(_side isEqualTo civilian)) then {
        _color = [_side, true] call BIS_fnc_sideColor;
        _opacity = 0.8;
    };

    _marker = _sector getVariable ARWA_KEY_marker;
    _markerPos = getPos _sector;

    _progress = ARWA_sector_size * (_counter/ARWA_capture_time);

    _markerPos = [(_markerPos select 0), (_markerPos select 1) + 250, _markerPos select 2];

    _marker_outline = format["%1-progress", toString toArray _marker];
    createMarker [_marker_outline, _markerPos];
    _marker_outline setMarkerColor _color;
    _marker_outline setMarkerAlpha _opacity;
    _marker_outline setMarkerShape "RECTANGLE";
    _marker_outline setMarkerBrush "SolidBorder";
    _marker_outline setMarkerSize [_progress,20];
};
