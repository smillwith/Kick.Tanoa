/*
Attach the ball to the ref? 
Show a message for Winning side
Allow custom match length and day time
Allow spectators

Fix the ball drop
 - Make it so we have a warm up time
 - Add a sign or other thing to indicate kick off
 - 

Update score
Implement the Win and Lose scenarios
Add score labels
Add score colors (blue and green?)

Fix out of bounds?
 - play a sound and lock the ball?
 - implement a fence?
*/

// [this] call dingus_fnc_GoalTrigger_East;
dingus_fnc_GoalTrigger_East = {
  params ["_list"];
  // Hack - we have to use independent so civilians don't flee
  [_list, independent] call dingus_fnc_GoalTriggerHandler;
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
        // hint format ['Goal - %1!', _side];

        if (!isNil "_unit") then {
          if (side _unit isEqualTo _side) then {
            _unit addScore 1;
            _return = true;
          } else {
            hint 'Wrong goal!';
          };
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
        /*["m_midfieldMarker"] spawn {
          params ["_marker"];
          
          // Wait for 20 first
          sleep 20;

          [_marker] call dingus_fnc_initializeBall;
        };*/

        // _return = true;
      };
    } forEach _list;
  };

  _return;
};

dingus_fnc_HomeScored = {
  _homeScore = missionNamespace getVariable ["Score_Home", 0];
  _visitorScore = missionNamespace getVariable ["Score_Visitor", 0];
  _homeScore = _homeScore + 1;
  hint 'Goal - EAST!';
  [_visitorScore, _homeScore] call dingus_fnc_UpdateScore;
};

dingus_fnc_VisitorScored = {
  _homeScore = missionNamespace getVariable ["Score_Home", 0];
  _visitorScore = missionNamespace getVariable ["Score_Visitor", 0];
  _visitorScore = _visitorScore + 1;
  hint 'Goal - WEST!';
  [_visitorScore, _homeScore] call dingus_fnc_UpdateScore;
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
        // systemChat 'OUT OF BOUNDS!!!';
        _return = true;
      };
    } forEach _list;
  };

  _return;
};

// [_visitor, _home] call dingus_fnc_UpdateScore;
dingus_fnc_UpdateScore = {
  params ["_visitor", "_home"];
  missionNamespace setVariable ["Score_Home", _home];
  missionNamespace setVariable ["Score_Visitor", _visitor];
};

// missionNamespace getVariable ["MatchEnded", 0] == 1 && ;
// [] call dingus_fnc_YouLose;
dingus_fnc_YouLose = {
  _ret = false;

  _ended = missionNamespace getVariable ["MatchEnded", 0] == 1;
  _homeScore = missionNamespace getVariable ["Score_Home", 0];
  _visitorScore = missionNamespace getVariable ["Score_Visitor", 0];

  if (_ended) then {
    if (_homeScore <= _visitorScore && side player == independent) then {
      _ret = true;
    };

    if (_visitorScore <= _homeScore && side player == WEST) then {
      _ret = true;
    };
  };

  _ret;
};

// [] call dingus_fnc_YouWin;
dingus_fnc_YouWin = {
  _ret = false;

  _ended = missionNamespace getVariable ["MatchEnded", 0] == 1;
  _homeScore = missionNamespace getVariable ["Score_Home", 0];
  _visitorScore = missionNamespace getVariable ["Score_Visitor", 0];

  if (_ended) then {
    if (_homeScore > _visitorScore && (side player isEqualTo independent)) then {
      _ret = true;
    };

    if (_visitorScore > _homeScore && (side player isEqualTo WEST)) then {
      _ret = true;
    };
  };

  _ret;
};