unit SHUSHENGINE_consts;

interface
uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, mmsystem, GIFImg, Bass;
const
  SEnter = #13#10;

  SError_BASS1 = 'Библиотека BASS, кажется, потерпела фиаско, а именно, он стал немного пристарелым';
  SError_BASS2 = 'Библиотека BASS, кажется, потерпела фиаско в плане инициализации';
  SError_Sprite1 = 'Нету такого гифа!';
  SErrorCommand = 'Неизвестная команда!';
  SErrorPasswd = 'Неверный пароль хоста!';
  SErrorServerInfo = 'Сервер не запущен!';
  SErrorConnectInfo = 'Вы не присоеденены к серверу!';

  com_help = 'HELP';
  com_host = 'HOST';
  com_help_len = 2; //изменять по мере обновления helpa

  Scom_Help = 'Hello!|No help for you'+senter;
  Scom_Host1 = 'Пароль действителен, сервер запускается...';
  Scom_Host2 = 'Сервер запущен';
  Scom_ServerInfo = 'Информация о запущенном сервере:';

  Server_port = 1337;

  Default_Sprite_width = 64;
  Default_Sprite_height = 64;

  Def_World_width = 1000;
  Def_World_height = 1000;

  Def_camera_x = 50;
  Def_camera_y = 50;
  Def_camera_width = 100;
  Def_camera_height = 100;

  Def_flags_size = 10;

  key_open_con = 'À';

  Server_Passwd = '5310087';




implementation

end.
