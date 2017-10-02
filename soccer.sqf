/*
Attach the ball to the ref? 

How do we trigger the next ball drop?

Show the score on the screen

Show a clock on the screen

*/

// [this] call dingus_fnc_GoalTrigger_East;
dingus_fnc_GoalTrigger_East = {
  params ["_list"];
  [_list, EAST] call dingus_fnc_GoalTriggerHandler;
};

// [this] call dingus_fnc_GoalTrigger_West;
dingus_fnc_GoalTrigger_West = {
  params ["_list"];
  [_list, WEST] call dingus_fnc_GoalTriggerHandler;
};

dingus_fnc_GoalTriggerHandler = {
  params ["_list", "_side"];

  _unit = missionNamespace getVariable ["LastTouchedUnit", nil];

  _return = false;

  if (isNil "_list") then {
    // systemChat 'list nil';
  } else {
    {
      // systemChat format ["%1", _x];
      if (_x isEqualTo Soccerball) then {
        // systemChat format ['Goal - %1!', _side];
        hint format ['Goal - %1!', _side];

        if (!isNil "_unit") then {
          _unit addScore 1;  
        } else {
          // systemChat "Couldnt get unit for score!.";
        };

        // Spawn a task to kill the ball
        // deleteVehicle (SoccerBallArray select 0);
        [SoccerBallArray select 0] spawn {
          params ["_ball"];
          sleep 3;
          deleteVehicle (_ball);
        };

        // Spawn a task to respawn the ball
        ["m_midfieldMarker"] spawn {
          params ["_marker"];
          sleep 8;
          [_marker] call dingus_fnc_initializeBall;
        };

        _return = true;
      };
    } forEach _list;
  };

  _return;
};

// [thisList] call dingus_fnc_PlayFieldTrigger;
dingus_fnc_PlayFieldTrigger = {
  params ["_list"];

  _return = false;

  if (isNil "_list") then {
    systemChat 'list nil';
  } else {
    {
      // systemChat format ["%1", _x];
      if (_x isEqualTo Soccerball) then {
        systemChat 'OUT OF BOUNDS!!!';
        _return = true;
      };
    } forEach _list;
  };

  _return;
};