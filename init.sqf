[] execVM "Genesis_Soccer.sqf";
[] execVM "soccer.sqf";
[] execVM "timer.sqf";

// This is how long the match lasts, in seconds. Add a few seconds to compensate for load times
SOCCER_MATCH_DURATION = 630;

// This is how long we wait after a goal is scored before a new ball arrives midfield
BALL_SPAWN_TIMEOUT = 10;

// This is how long to wait in between 'kick' checks. Wait longer for less 'bounce' between items
// original value was 0.01 - but has a double kick issue. Increasing seemed to fix it.
KICK_CHECK_SLEEP_TIME = 0.05;

// Distance to the ball a player needs to be in order to activate/kick the ball (meters)
KICK_MIN_DISTANCE = 0.8;

// This appears to be a modifier indicating how much faster the ball should go initially when you kick it
// Applied to current player speed to get ball speed
KICK_BOOST_MULT = 3;

// Power kick multiplier - when holding ctrl
// Applied to current player speed to get ball speed
PUNT_BOOST_MULT = 8;

BALL_VEHICLE_TYPE = "Land_Football_01_F";

//Set Darkness
_hoursToskip = ["darkness", -1] call BIS_fnc_getParamValue;
skiptime _hoursToskip;

missionNamespace setVariable ["MatchEnded", 0, true];
missionNamespace setVariable ["Score_Home", 0, true];
missionNamespace setVariable ["Score_Visitor", 0, true];
