// [] spawn compileFinal preprocessFileLineNumbers "airUnitSpawn.sqf";
_sectors = [true] call BIS_fnc_moduleSector;
{
    if((_x getVariable "owner") == West) then {
        _sector = _x;

        _syncedObjects = synchronizedObjects _sector;

        {
          _syncedObject = _x;
          if(typeOf _syncedObject == "ModuleSector_F") then {
            bluforCanCapture synchronizeObjectsAdd [_syncedObject];
          };
        } forEach _syncedObjects
    }
} forEach _sectors;
