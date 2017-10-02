// Credit: Genesis92x via Armaholic
// Source: http://www.armaholic.com/page.php?id=29245
// Date: Oct-1-2017

//To use this script, create a file called "init.sqf" in your root mission folder
//Then in the init.sqf copy and paste this line " [] execVM "Genesis_Soccer.sqf; "
//Should work now!
PlaySoundEverywhere = compileFinal "_this select 0 say3D (_this select 1);";
player setvariable ["Soccer_Hit",false,true];
MY_KEYDOWN_FNCDCGETIN =
{
    switch (_this) do {
        case 29: 
				{
					if (player getVariable "Soccer_Hit") then
					{
						player setvariable ["Soccer_Hit",false,true];
					}
					else
					{
						player setvariable ["Soccer_Hit",true,true];
					};
        };

    };
};
VCOMKEYBINDINGDCGET = (findDisplay 46) displayAddEventHandler ["KeyDown","_this select 1 spawn MY_KEYDOWN_FNCDCGETIN;false;"];


// ["m_midfieldMarker"] call dingus_fnc_initializeBall;
dingus_fnc_initializeBall = {
	if (isServer) then {
		params ["_marker"];
		[_marker] spawn {
			params ["_m"];
			SoccerBallArray = [];
			// _RandomPlayer = allUnits call BIS_fnc_SelectRandom;
			// Soccerball = "Land_Football_01_F" createvehicle [(getposATL _RandomPlayer) select 0,(getposATL _RandomPlayer) select 1,((getposATL _RandomPlayer) select 2) + 5];
			_pos = getMarkerPos _m;
			Soccerball = "Land_Football_01_F" createvehicle [(_pos) select 0, (_pos) select 1,((_pos) select 2) + 5];
			SoccerBallArray pushback Soccerball;
			// sleep 5; // why?

			while {alive Soccerball} do
			{
				// I think there's an issue where the kick action takes longer than the 'next check' so we get a 'double kick' effect
				_Closestplayer = [allUnits,Soccerball] call BIS_fnc_NearestPosition;
				if (_Closestplayer distance Soccerball <= 0.8) then
				{
					//[[SoccerBall,"AddItemOK"],"PlaySoundEverywhere"] call BIS_fnc_MP;
					[[SoccerBall,"Kick1"],"PlaySoundEverywhere"] call BIS_fnc_MP;

					missionNamespace setVariable ["LastTouchedUnit", _Closestplayer];

					_GetVelocity = velocity _Closestplayer;
					_playervelocityX = _GetVelocity select 0;
					_playervelocityY = _GetVelocity select 1;
					_playervelocityZ = _GetVelocity select 2;
				
					_boostX = _playervelocityX * 3;
					_boostY = _playervelocityY * 3;
					_boostZ = _playervelocityZ * 3;
					_Punt = _Closestplayer getVariable "Soccer_Hit";
					_Boost = 1;
					if (isNil "_Punt") then {_Punt = false};
					if (_Punt) then {_Boost = 8;};
					Soccerball setVelocity [_boostX,_boostY,_boostZ + _Boost];
				};
				// sleep 0.01; original - but has a double kick issue
				sleep 0.05;
			};

			// Hack? If the ball dies, spawn a new one
			if (!alive Soccerball) then {
				[_m] spawn {
          params ["_marker"];
          
          // Wait for 20 first
          sleep 17;

          // play the thingy?
          // alarm_independent
          // [[markerPos _marker, "beep_target"], "PlaySoundEverywhere"] call BIS_fnc_MP;
          systemChat "Get ready! Kick off in 3...2...1";
          missionNamespace setVariable ["BallSpawn", "0"];

          sleep 2;
          
          [_marker] call dingus_fnc_initializeBall;
        };
			};
		};
	};
};


