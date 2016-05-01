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
  SErrorConnectIp = 'Укажите IP!';
  SErrorServerInfo = 'Сервер не запущен!';
  SErrorServeral = 'Вы уже являетесь хостом!';       //already
  SErrorServeralc = 'Вы подключены к другому серверу, отключитесь!';       //connect
  SErrorConnectInfo = 'Вы не присоеденены к серверу!';
  SErrorConnectal = 'Вы уже присоеденены к серверу!';       //already
  SErrorConnectalh = 'Вы уже являетесь хостом! Остановите сервер!';       //host

  com_help = 'HELP';
  com_host = 'HOST';
  com_connect = 'CONNECT';
  com_clear = 'CLEAR';
  com_server_info = 'S_INFO';

  def_SSeparator = '|';
  ds = def_SSeparator;  //тоже самое

  Scom_Help = ds+ds+'--==THE HELP==--'+ds+ds+'Hello!'+ds+'No help for you'+ds+'NYEHEHEHE'+ds+ds+'--==THE HELP ENDING==--'+ds+ds;
  Scom_Host1 = ds+'Сервер запускается...'+ds+ds;
  Scom_Host2 = ds+'Сервер запущен'+ds+ds;
  Scom_connect1 = ds+'Подключаемся к серверу...'+ds+ds;
  Scom_connect2 = ds+'Сервер запущен'+ds+ds;
  Scom_ServerInfo = ds+'Информация о запущенном сервере:'+ds+ds;



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

  console_letters = ['A'..'Z','0','1'..'9',' ','_'];




implementation

end.
