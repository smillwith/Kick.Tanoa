// Credit: Genesis92x via Armaholic
// Source: http://www.armaholic.com/page.php?id=29245
// Date: Oct-1-2017 (heavily modified)

PlaySoundEverywhere = compileFinal "_this select 0 say3D (_this select 1);";
player setvariable ["Soccer_Hit",false,true];
MY_KEYDOWN_FNCDCGETIN = {
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
			_pos = getMarkerPos _m;
			Soccerball = BALL_VEHICLE_TYPE createvehicle [(_pos) select 0, (_pos) select 1,((_pos) select 2) + 5];
			SoccerBallArray pushback Soccerball;
			// sleep 5; // why?

			// Random kick sound
			_snds = ["Kick1", "Kick1", "Kick3"];

			while {alive Soccerball} do
			{
				_Closestplayer = [allUnits,Soccerball] call BIS_fnc_NearestPosition;
				if (_Closestplayer distance Soccerball <= KICK_MIN_DISTANCE) then
				{
					[[SoccerBall, _snds select floor random count _snds],"PlaySoundEverywhere"] call BIS_fnc_MP;

					missionNamespace setVariable ["LastTouchedUnit", _Closestplayer];

					_GetVelocity = velocity _Closestplayer;
					_playervelocityX = _GetVelocity select 0;
					_playervelocityY = _GetVelocity select 1;
					_playervelocityZ = _GetVelocity select 2;
				
					_boostX = _playervelocityX * KICK_BOOST_MULT;
					_boostY = _playervelocityY * KICK_BOOST_MULT;
					_boostZ = _playervelocityZ * KICK_BOOST_MULT;
					_Punt = _Closestplayer getVariable "Soccer_Hit";
					_Boost = 1;
					if (isNil "_Punt") then {_Punt = false};
					if (_Punt) then {_Boost = PUNT_BOOST_MULT;};
					Soccerball setVelocity [_boostX,_boostY,_boostZ + _Boost];
				};
				sleep KICK_CHECK_SLEEP_TIME;
			};

			// Hack? If the ball dies, spawn a new one
			if (!alive Soccerball) then {
				[_m] spawn {
          params ["_marker"];
          // Wait for a bit first
          sleep (BALL_SPAWN_TIMEOUT - 3);
          systemChat "Get ready! Kick off in 3...2...1";
          missionNamespace setVariable ["BallSpawn", "0"];
          sleep 3;
          [_marker] call dingus_fnc_initializeBall;
        };
			};
		};
	};
};
