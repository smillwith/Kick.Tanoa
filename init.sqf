[] execVM "Genesis_Soccer.sqf";
[] execVM "soccer.sqf";
[] execVM "timer.sqf";

SOCCER_MATCH_DURATION = 600;
// SOCCER_MATCH_DURATION = 45;

//Set Darkness
_hoursToskip = ["darkness", -1] call BIS_fnc_getParamValue;
skiptime _hoursToskip;

missionNamespace setVariable ["MatchEnded", 0];
missionNamespace setVariable ["Score_Home", 0];
missionNamespace setVariable ["Score_Visitor", 0];
