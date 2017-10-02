[] spawn {
  disableSerialization;
  cutRsc["AUSMD_Timer","PLAIN"];
  _Display = uiNamespace getVariable "AUSMD_Timer"; 
  _textBar = _display displayCtrl -1;
  _timer = 600;
  while{_timer > 1} do
  {
    _textBar ctrlsetText (format["%1",[_timer,"HH:MM:SS",false] call BIS_fnc_secondstoString]);
    _timer = _timer - 1;
    uiSleep 1;
  };
};
