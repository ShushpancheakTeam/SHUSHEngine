unit SHUSHENGINE_classes;
interface
{
Copyright: ShushpancheakTeam
All rights reserved
}
uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,mmsystem, Bass, GIFImg, SHUSHENGINE_consts,System.Win.ScktComp;

type
  TDirection = (up,down,left,right,up_right,down_right,down_left,up_left);
  TFlags = TBits;
  {
    0 - chat
  }
  TServerValues  = (sv_host,sv_client,sv_NaN) ;
  TConsoleClear = (cl_lline,cl_all,cl_char);

  TGIF = class
    path:string;
  end;
  TSprite = class
    gif:array[0..7]of TGIF;      //всего max 8 напр, а так, возможно и 4, кароч     0 -  вверх и тд...
    width,height:integer;
    img:TImage;
    active_gif:integer;
    //какой гиф вставить на какое направление в каком state
    procedure assign_gif(path:string;num:integer);
    //default params
    procedure set_default();


  end;
  TGameObject = class                   //основные параметры всех объектов в мире. можно добавлять свои
    layer:word; //0 - Самый большой
    x,y,wx,wy:integer;
    hitbox_w,hitbox_h:integer;
    allowed_directions: set of up..up_left;
    direction: TDirection;
    Sprite:TSprite;
    //def
    procedure Set_default();
    //
    procedure Set_xy(nx,ny:integer);
    //x y относительно камеры
    procedure Set_wxy(nx,ny:integer);
    //
    procedure draw_sprite();
  end;

  TPlayer = class
    public
      name:string; //Почему бы и нет?
  end;

  TAudioControl = class
    public
      var
        AudioStream:Array[0..9] of HStream; //с нуля
      //initialization
      procedure Init(FormHandle:HWND);
  end;

  TConsole = class
    showed:boolean;
    conmemo:TMemo;
    //
    procedure show();
    //
    procedure OnKeyDown(key:word);
    //
    procedure read_command(com:string);
    //
    procedure output(s:string);
    //
    procedure output_info(s:string);
    //
    procedure clear(cl:TConsoleClear);
  end;

  TGameControl = class
    public
      paused:boolean; //paused yknow
      Audio_Control:TAudioControl;
      World_width:integer;
      World_height:integer;
      flags: Tflags;
    //пауза на n ms
    procedure pause(ms:integer);
    //initialization
    procedure Init(flg:TFlags);
    //
    procedure SHowLogo;
    //
    procedure set_camera_xy(nx,ny:integer);
    //
    procedure onKeyDown(key:word);
  end;
  TServer = class
    public
      hoc:TServerValues; //host or client?
    procedure start();
    procedure stop_host();
    procedure stop_connection();
    procedure connect(ip:string);
    procedure OnRecieveFromClient(sock:TCustomWinSocket);
  end;
  TChat = class
    public
      chatMemo:TMemo;
      chatSplit:TSplitter;
      chatSplit2:TSplitter;
      chatPanel:Tpanel;
      inputPanel:TPAnel;
      input:TEdit;
      //procedure read_command();
      //procedure onkeydown(sender:TObject;key:word;shift:TShiftstate);
  end;

var camera_x,camera_y:integer;
    camera_width,camera_height:integer;
    Server:TServer;
    host:TServerSocket;
    client:TClientSocket;
    Chat:TChat;
    Form:TWinControl;
    console:TConsole;




{███████████████████████████████████████████████████████████████████████████████ }
implementation
procedure Error(s:string);
begin
  MessageBox(0,PChar(s),0,MB_ICONWARNING);
end;

function read_word(s:string;stop_char:char;ind:integer):string;
var i:integer;
begin
  result:='';
  i:=ind;
  while (s[i] <> stop_char)and (i <= s.Length) do  begin
    result:=result+s[i];
    inc(i);
  end;
end;
function posoflastline(s:string):integer;
var
  g:integer;
begin
  g:=1;
  result:=1;
  while g <> length(s) do begin
    if s[g] = #10 then result:=g;
    inc(g);
  end;
end;


procedure Tserver.stop_host();
begin
  hoc:=sv_NaN;
  host.Close;
end;
procedure Tserver.stop_connection();
begin
  hoc:=sv_NaN;
  client.Close;
end;
procedure TServer.start();
begin
  if hoc = sv_NaN then    begin
    host.Port:=Server_port;
    Host.Open;
    hoc:=sv_host;
  end
  else if hoc = sv_client then error(SErrorserveralc)
  else error(SErrorserveral);
end;
procedure TServer.connect(ip:string);
begin
  if hoc = sv_NaN then    begin
    hoc:=sv_client; //client;
    client.port:=Server_port;
    Client.Address:=ip;
    Client.Open;
  end
  else if hoc = sv_host then error(SErrorConnectalh)
  else error(SErrorConnectal);
end;

procedure TServer.OnRecieveFromClient(sock:TCustomWinSocket);
begin
  console.output_info(Srecieve_client+inttostr(sock.sockethandle)+':'+sock.ReceiveText);
end;

procedure Tconsole.output(s:String);
var i:integer;
begin
  i:=1;
  while i <= length(s) do  begin
    if s[i] <> def_SSeparator then conmemo.text:=conmemo.Text+s[i]
    else conmemo.Text:=conmemo.Text+SEnter;
    inc(i);
  end;
end;
procedure TConsole.output_info(s:string);   //вывод до введения команды (для событий типа присоединении клиента)
var i:integer;
    tmptxt:string;
begin
  tmptxt:=conmemo.text;
  tmptxt.Remove(posoflastline(tmptxt)-1);
  conmemo.text:=tmptxt;
  i:=1;
  while i <= length(s) do  begin
    if s[i] <> def_SSeparator then conmemo.text:=conmemo.Text+s[i]
    else conmemo.Text:=conmemo.Text+SEnter;
    inc(i);
  end;
  conmemo.Text:=conmemo.Text+SEnter+dst1+dst2;
end;

procedure Tconsole.clear(cl:TConsoleClear);
var tmptxt:string;
    i:integer;
begin
  tmptxt:=string(conmemo.Text);
  if cl = cl_lline then begin
    while tmptxt[length(tmptxt)-length(dst2)] <> dst1[length(dst1)] do  begin
      tmptxt:=tmptxt.Remove(length(tmptxt)-length(dst2)-1,1);
    end;
    conmemo.Text:=tmptxt;
  end;
  if cl = cl_all then begin
    conmemo.lines.Clear;
    conmemo.Text:=dst1+dst2;
  end;
  if cl = cl_char then begin
    if tmptxt[length(tmptxt)-length(dst2)] <> dst1[length(dst1)] then conmemo.text:=tmptxt.Remove(length(tmptxt)-length(dst2)-1,1);     //за строку не выходить
  end;
end;


procedure TConsole.show();
var tmptxt:string;
begin
  if not showed then begin
    conmemo.Left:=10;
    conmemo.top:=0;
    conmemo.Width:=600;
    conmemo.Height:=400;
    conmemo.ScrollBars:=ssboth;       //na memo mnogo
    tmptxt:=conmemo.Text;
    if tmptxt[length(tmptxt)] = #10 then
      conmemo.Text:=conmemo.Text+dst1+dst2;
    showed:=true;
  end
  else begin
    conmemo.Left:=10;
    conmemo.top:=-600;
    conmemo.Width:=1;
    conmemo.Height:=1;
    showed:=false;
  end;
end;
procedure TConsole.read_command(com: string);
var curind:integer;
var comm:string;
begin
  curind:=length(dst1)+1;
  comm:=read_word(com,' ',curind);
  //+3 потому что там он был на один меньше, это уже +2, а потом стоп чар
  curind:=curind+3+length(dst1); //вместе с /|\ верхним
  if comm[length(comm)] = dst2[length(dst2)] then comm:=comm.Remove(length(comm)-length(dst2));
  if comm = com_help then                    //case nelzya
    output(Scom_help) // больше нету параметроb
  else
  if comm = com_host then begin
    if server.hoc = sv_NaN then output(Scom_host1);
    Server.start();
    if server.hoc = sv_host then output(Scom_host2);
  end
  else
  if comm = com_connect then begin
    if com[curind] = dst2[1] then error(SErrorConnectIp) // больше нету параметров
    else begin
      comm:=read_word(com,dst2[1],curind);
      if server.hoc = sv_NaN then output(Scom_connect1);
      Server.connect(comm);
      if server.hoc = sv_client then output(Scom_connect2);
    end
  end
  else
  if comm = com_clear then begin
    clear(cl_all);
  end
  else if comm = com_send_to_serv then begin
    if server.hoc = sv_Client then begin
      comm:=read_word(com,' ',curind);
      client.Socket.SendText(comm);
    end
    else error(SErrorHostSend);
  end
  else begin
    error(SErrorCommand);
    clear(cl_lline);
  end;
  conmemo.Text:=conmemo.Text+SEnter+dst1+dst2;
end;
procedure TConsole.OnKeyDown(key: Word);
var
  tmptxt,tmptxt1:string;
begin

  if (key=ord(key_open_con)) then
      show() else
  if showed then begin
    if key = 13 then begin
      read_command(conmemo.Lines[conmemo.Lines.Count-1]);
    end
    else
    if key = ord('') then//backspace
      clear(cl_char)
    else
    if key = 190 then begin
      tmptxt:=conmemo.text;
      tmptxt1:=tmptxt;
      delete(tmptxt,posoflastline(tmptxt),255);
      tmptxt:=tmptxt+read_word(tmptxt1,dst2[1],posoflastline(tmptxt1));
      conmemo.Text:=tmptxt+'.'+dst2;
    end
    else
    if key = 189 then begin
      tmptxt:=conmemo.text;
      tmptxt1:=tmptxt;
      delete(tmptxt,posoflastline(tmptxt),255);
      tmptxt:=tmptxt+read_word(tmptxt1,dst2[1],posoflastline(tmptxt1));
      conmemo.Text:=tmptxt+'_'+dst2;
    end
    else
    if chr(key) in console_letters then begin
      tmptxt:=conmemo.text;
      tmptxt1:=tmptxt;
      delete(tmptxt,posoflastline(tmptxt),255);
      tmptxt:=tmptxt+read_word(tmptxt1,dst2[1],posoflastline(tmptxt1));
      conmemo.Text:=tmptxt+chr(key)+dst2;
    end;
    conmemo.Perform(WM_VScroll,SB_BOTTOM,0);     //в самый низ переходить
  end;
end;


procedure TGameControl.pause(ms:integer);
var wtim:ttime;
begin
  paused:=true;
  wtim:=encodetime(0,0,ms div 1000,ms mod 1000)+time;
  while (time<=wtim)and paused do
      application.processmessages;
  paused:=false;
end;
procedure TGameControl.showlogo;
begin

end;
procedure TGameControl.Init(flg:TFlags);   //default значения
begin
  showlogo;
  camera_x:=Def_camera_x;
  camera_y:=Def_camera_y;
  camera_width:=Def_camera_width;
  camera_height:=Def_camera_height;

  flags:=flg;

  if flg.Bits[0] then begin
    chat:=TChat.Create;
    chat.chatpanel:=TPanel.Create(form);
    chat.chatPanel.Parent:=form;
    chat.chatPanel.Align:=TAlign.alRight;
    chat.chatPanel.Width:=250;

    chat.inputpanel:=TPanel.Create(form);
    chat.inputPanel.Parent:=form;
    chat.inputPanel.Align:=TAlign.alBottom;
    chat.inputPanel.Width:=250;
    chat.inputPanel.BevelEdges:=[beTop,bebottom];
    chat.inputPanel.BevelKind:=TBevelkind.bkTile;

    chat.input:=tedit.Create(chat.inputPanel);
    chat.input.Parent:=chat.inputPanel;

    chat.input.Width:=chat.inputPanel.Width - 100;

    chat.inputPanel.Height:=chat.input.Height+10;

    chat.input.Color:=def_input_clr;

    chat.input.Anchors:=[akBottom,akleft,aktop,akright];

    chat.chatSplit:=TSplitter.Create(form);
    chat.chatSplit.Parent:=Form;
    chat.chatSplit.Align:=alright;

    Chat.chatMemo:=Tmemo.Create(chat.chatPanel);
    chat.chatMemo.Parent:=chat.chatPanel;
    chat.chatMemo.ReadOnly:=true;
    chat.chatMemo.HideSelection:=true;
    chat.chatMemo.Height:=form.Height-75;
    chat.chatMemo.Align:=alclient;
    chat.chatMemo.ScrollBars:=ssboth;

  end;

  //console:=TConsole.Create; до инита
  console.showed:=false;

  Server:=TServer.Create;
  server.hoc:=sv_NaN;  //Еще серва нету

  World_width:=Def_World_width;
  world_height:=Def_World_height;
end;
procedure TGameControl.set_camera_xy(nx,ny:integer);
begin
  camera_x:=nx;
  camera_y:=ny;
end;

procedure TAudioControl.Init(FormHandle:HWND);       //Нужно ввести form{n}.handle
begin
	if (HIWORD(BASS_GetVersion) <> BASSVERSION) then
	begin
		MessageBox(0,SError_BASS1,NIL,MB_ICONERROR);
		Halt;
	end;

  if not BASS_Init(-1, 44100, 0,FormHandle, nil) then begin
    Error(SError_BASS2);
    Exit;
  end;
end;

procedure TSprite.assign_gif(path: string;num:integer);
begin
  gif[num].path:=path;
end;

procedure TGameObject.draw_sprite();
var TMP_Gif:TGifImage;
var gifnum:integer;
begin
    case direction of
      up:        gifnum:=0 ;
      down:      gifnum:=4 ;
      left:      gifnum:=6 ;
      right:     gifnum:=2 ;
      up_right:  gifnum:=1 ;
      down_right:gifnum:=3 ;
      down_left: gifnum:=5 ;
      up_left:   gifnum:=7 ;
    end;
    if sprite.active_gif <> gifnum then begin

      sprite.active_gif:=gifnum;
      TMP_Gif:=TGifImage.Create;
      try
        TMP_Gif.LoadFromFile(sprite.gif[gifnum].path);
      except
        error(SError_Sprite1+' '+sprite.gif[gifnum].path);
      end;
      TMP_Gif.Width:=sprite.width;
      TMP_Gif.height:=sprite.height;
      TMP_Gif.Transparent:=true;

      TMP_Gif.Animate := True;
      TMP_Gif.AnimateLoop := glEnabled;


      sprite.img.picture.Assign(TMP_gif);

      TMP_Gif.Free;
    end;
end;
procedure TSprite.set_default;
var
  i: Integer;
begin
  for i := 0 to 7 do
    gif[i]:=TGIF.Create;
  width:=Default_Sprite_width;
  height:=Default_Sprite_height;

  active_gif:=-1;
  assign_gif('bullet.gif',0);
end;
procedure TGameObject.Set_default;
begin
  Sprite:=TSprite.Create;
  Sprite.set_default;
  x:=50;
  y:=50;
  layer:=0;
  allowed_directions:=[up];
  direction:=up;
  hitbox_w:=Sprite.width;
  hitbox_h:=Sprite.height;
end;
procedure TGAmeObject.Set_wxy(nx: Integer; ny: Integer);
begin
  wx:=nx;
  wy:=ny;
  sprite.img.Left:=wx-camera_x+camera_width div 2;
  sprite.img.top:=wy-camera_y+camera_height div 2;
end;
procedure TGAmeObject.Set_xy(nx: Integer; ny: Integer);
begin
  if nx = x then
    if ny > y then
      if down in allowed_directions then direction:=down
      else
    else
    if ny < y then
      if up in allowed_directions then direction:=up
      else
    else
  else
  if ny = y then
    if nx > x then
      if right in allowed_directions then direction:=right
      else
    else
    if nx < x then
      if left in allowed_directions then direction:=left
      else
    else
  else
  if nx > x then
    if ny > y then
      if down_right in allowed_directions then direction:=down_right
      else
    else
    if ny < y then
      if up_right in allowed_directions then direction:=up_right
      else
    else
  else
  if nx < x then
    if ny > y then
      if down_left in allowed_directions then direction:=down_left
      else
    else
    if ny < y then
      if up_left in allowed_directions then direction:=up_left;
  x:=nx;
  y:=ny;
  set_wxy(x,y);
end;
procedure TGameCOntrol.onKeyDown(key:word);
begin
  if (key=ord(key_open_con)) then
    console.show();

end;

end.
