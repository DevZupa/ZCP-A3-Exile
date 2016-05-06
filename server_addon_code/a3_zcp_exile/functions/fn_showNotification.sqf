private['_ZCP_SN_notificationType','_ZCP_SN_message'];

_ZCP_SN_notificationType = _this select 0;
_ZCP_SN_message          = _this select 1;

if(ZCP_CurrentMod == 'Exile') exitWith {

  switch (_ZCP_SN_notificationType) do {
      case ('Notification'): {
        PV_ZCP_zupastic = _ZCP_SN_message;
        publicVariable "PV_ZCP_zupastic";
      };
      case ('PersonalNotification'): {
          private['_ZCP_SN_player'];
          _ZCP_SN_player = _this select 2;
          PV_ZCP_zupastic = _ZCP_SN_message;
          owner _ZCP_SN_player publicVariableClient "PV_ZCP_zupastic";
      };
      case ('Reputation'): {
        _ZCP_SN_message call ExileServer_system_network_send_to;
      };
      case ('Money'): {
        _ZCP_SN_message call ExileServer_system_network_send_to;
      };
  };

};

if(ZCP_CurrentMod == 'Epoch') exitWith {
  switch (_ZCP_SN_notificationType) do {
      case ('Notification'): {
        PV_ZCP_zupastic = _ZCP_SN_message;
        publicVariable "PV_ZCP_zupastic";
      };
      case ('PersonalNotification'): {
          private['_ZCP_SN_player'];
          _ZCP_SN_player = _this select 2;
          PV_ZCP_zupastic = _ZCP_SN_message;
          owner _ZCP_SN_player publicVariableClient "PV_ZCP_zupastic";
      };
      case ('Reputation'): {

      };
      case ('Money'): {

      };
  };
};
