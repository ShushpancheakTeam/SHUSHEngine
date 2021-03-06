unit ShushengineTEST;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SHUSHENGINE_classes,SHUSHENGINE_consts, Vcl.ExtCtrls, GIFImg, Bass,
  System.Win.ScktComp, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    conMemo: TMemo;
    ClientSocket1: TClientSocket;
    ServerSocket1: TServerSocket;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure conMemoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ServerSocket1ClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Game_Control:TGameControl;
  TestObject:TGameObject;
implementation

{$R *.dfm}
///////////////////////////////////////SHUSH_STUFF//////////////////////////////
procedure shush1(img:TImage);                                                ///
begin                                                                        ///
  testobject.Sprite.img.Parent:=Form1;                                       ///
  testobject.Sprite.img.Transparent:=true;                                   ///
end;                                                                         ///
procedure Initialization_shush();                                            ///
begin                                         ///
  testobject.Sprite.img:=TImage.Create(Form1);                               ///
  shush1(testobject.Sprite.img);

  Form:=Form1;                                       ///
  HOST:=form1.serversocket1;
  CLIENT:=form1.ClientSocket1;

  console:=TConsole.Create;

  console.conmemo:=form1.conmemo;
end;                                                                         ///
///////////////////////////////////////SHUSH_STUFF//////////////////////////////
procedure TForm1.conMemoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  console.OnKeyDown(key);
end;

procedure TForm1.FormCreate(Sender: TObject);
var tmpflags:TFlags;
begin
  Game_control:=TGameControl.create;

  TestObject:=TGameObject.Create;
  TestObject.Set_default;

  Initialization_shush();

  tmpflags:=Tflags.create;

  tmpflags.size:=Def_flags_size;

  tmpflags.Bits[0]:=true;

  Game_control.init(tmpflags);
  Game_control.Audio_Control.init(Form1.Handle);



  


  Timer1.Enabled:=true;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Game_control.onkeydown(key);
end;

procedure TForm1.ServerSocket1ClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Server.onrecieveFromClient(socket);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  TestObject.set_xy(TestObject.x+random(5)+1,TestObject.y+random(5)+1);
  Game_control.set_camera_xy(camera_x+random(5)+1,camera_y+random(5)+1);
  TestObject.draw_sprite();
end;

end.









