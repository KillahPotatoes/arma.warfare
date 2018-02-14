[] call compileFinal preprocessFileLineNumbers "scripts\playerActions\halo.sqf";
[] call compileFinal preprocessFileLineNumbers "scripts\playerActions\spawnSquad.sqf";
[] call compileFinal preprocessFileLineNumbers "scripts\playerActions\showArsenal.sqf";
[] call compileFinal preprocessFileLineNumbers "scripts\playerActions\redeploy.sqf";

RefreshActionList = {
	_sectors = _this select 0;

	removeAllActions player;

	[_sectors] call AddRedeployToSectorsActions;
	[] call ShowRequestSquadAction;
	[] call ShowArsenalAction;
	[] call AddRedeployToHqAction;
	[] call AddHeloAction;
}