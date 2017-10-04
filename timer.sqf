[] spawn {
  disableSerialization;
  cutRsc["AUSMD_Timer","PLAIN"];
  _Display = uiNamespace getVariable "AUSMD_Timer"; 
  _textBar = _display displayCtrl 40018;
  _scoreBoard = _display displayCtrl 40019;

  _timer = SOCCER_MATCH_DURATION;

  while{_timer > 1} do
  {
    _home = missionNamespace getVariable ["Score_Home", 0];
    _visitor = missionNamespace getVariable ["Score_Visitor", 0];
    _textBar ctrlsetText (format["Remaining: %1",[_timer,"HH:MM:SS",false] call BIS_fnc_secondstoString]);
    _scoreBoard ctrlsetText (format["%1 - %2", _home, _visitor]);
    _timer = _timer - 1;
    uiSleep 1;
  };

  missionNamespace setVariable ["MatchEnded", 1, true];
};
