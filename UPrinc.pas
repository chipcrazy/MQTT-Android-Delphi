unit UPrinc;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  TMS.MQTT.Global, FMX.ScrollBox, FMX.Memo, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, TMS.MQTT.Client, FMX.Objects,
  FMX.TMSBaseControl, FMX.TMSLed, FMX.TMSLedmeter, FMX.TabControl, uGhiFuncoes,
  System.Actions, FMX.ActnList, System.ImageList, FMX.ImgList,
  FMX.TMSBitmapContainer, FMX.TMSCustomButton, FMX.TMSSpeedButton, FMX.Gestures,System.IOUtils;

type
  TFPrinc = class(TForm)
    TMSMQTTClient1: TTMSMQTTClient;
    StyleBook1: TStyleBook;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    BtnConectar: TButton;
    BtnSuscribirse: TButton;
    BtnEnviar: TButton;
    Edit1: TEdit;
    Memo1: TMemo;
    TabItem3: TTabItem;
    TabItem4: TTabItem;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    LDatos: TLabel;
    ActionList1: TActionList;
    ChangeTabAction1: TChangeTabAction;
    ChangeTabAction2: TChangeTabAction;
    ChangeTabAction3: TChangeTabAction;
    Timer1: TTimer;
    ImageList1: TImageList;
    BtnLuz: TSpeedButton;
    GestureManager1: TGestureManager;
    NextTabAction1: TNextTabAction;
    PreviousTabAction1: TPreviousTabAction;
    ImgMov: TImage;
    Label1: TLabel;
    BtnLuz1: TSpeedButton;
    BtnLuz2: TSpeedButton;
    BtnLuz3: TSpeedButton;
    GroupBox3: TGroupBox;
    LedTemp: TTMSFMXLEDMeter;
    LTemp: TLabel;
    GroupBox4: TGroupBox;
    ImgPuerta1: TImage;
    Label2: TLabel;
    ImgPuerta2: TImage;
    Label4: TLabel;
    ImgPuerta3: TImage;
    Label5: TLabel;
    procedure TMSMQTTClient1PublishReceived(ASender: TObject; APacketID: Word;
      ATopic: string; APayload: TArray<System.Byte>);
    procedure BtnConectarClick(Sender: TObject);
    procedure BtnSuscribirseClick(Sender: TObject);
    procedure BtnEnviarClick(Sender: TObject);
    procedure TMSMQTTClient1ConnectedStatusChanged(ASender: TObject;
      const AConnected: Boolean; AStatus: TTMSMQTTConnectionStatus);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnLuzClick(Sender: TObject);
    procedure BtnLuz1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FPrinc: TFPrinc;

implementation

{$R *.fmx}

uses
  Androidapi.JNIBridge,
  AndroidApi.JNI.Media;

procedure Sound(ADuration: Integer);
var
  Volume: Integer;
  StreamType: Integer;
  ToneType: Integer;
  ToneGenerator: JToneGenerator;
begin

  Volume := TJToneGenerator.JavaClass.MAX_VOLUME;
 {
STREAM_VOICE_CALL (0)
STREAM_SYSTEM (1)
STREAM_RING (2)
STREAM_MUSIC(3)
STREAM_ALARM(4)
 }
 StreamType := 4;
  ToneType := TJToneGenerator.JavaClass.TONE_DTMF_0;

  ToneGenerator := TJToneGenerator.JavaClass.init(StreamType, Volume);
  ToneGenerator.startTone(ToneType, ADuration);

end;


procedure TFPrinc.BtnConectarClick(Sender: TObject);
begin
  //TMSMQTTClient1.Connect(false);
  TMSMQTTClient1.ClientID:='AndroidApk'+IntToStr(random(500));
  try
    TMSMQTTClient1.Connect(true);
  except
    TMSMQTTClient1.Connect(true);
  end;
end;

procedure TFPrinc.BtnEnviarClick(Sender: TObject);
begin
  if (TMSMQTTClient1.IsConnected) then
    TMSMQTTClient1.Publish('casa/room1/luz',Edit1.Text);
end;

procedure TFPrinc.BtnSuscribirseClick(Sender: TObject);
begin
  if (TMSMQTTClient1.IsConnected) then
  BEGIN
    TMSMQTTClient1.Subscribe('casa/room1/datos');
    TMSMQTTClient1.Subscribe('casa/room1/luz');
    TMSMQTTClient1.Subscribe('casa/room1/luz1');
    TMSMQTTClient1.Subscribe('casa/room1/luz2');
    TMSMQTTClient1.Subscribe('casa/room1/luz3');
    TMSMQTTClient1.Subscribe('casa/room1/puerta1');
    TMSMQTTClient1.Subscribe('casa/room1/puerta2');
    TMSMQTTClient1.Subscribe('casa/room1/puerta3');

    TMSMQTTClient1.Subscribe('casa/room1/temperatura');
    TMSMQTTClient1.Subscribe('casa/room1/mov1');
  END;
end;

procedure TFPrinc.FormShow(Sender: TObject);
begin
  Randomize();
  GhiFunc.MensagemToast(self, 'Presione Conectar....', TAlignLayout.Center, TAlphaColorRec.Red);
  //TIMER1.Enabled:=TRUE;
    ImgMov.Bitmap.LoadFromResource('motion_off');
    ImgPuerta1.Bitmap.LoadFromResource('door_off');
    ImgPuerta2.Bitmap.LoadFromResource('door_off');
    ImgPuerta3.Bitmap.LoadFromResource('door_off');
end;

procedure TFPrinc.BtnLuz1Click(Sender: TObject);
begin
  if (BtnLuz.TagString<>'+') then
  begin
    TMSMQTTClient1.Publish('casa/room1/luz'+(Sender as TSpeedButton).tag.tostring() ,'1');
    BtnLuz.ImageIndex:=1;
    BtnLuz.TagString:='+';
  end
  else
  begin
    TMSMQTTClient1.Publish('casa/room1/luz'+(Sender as TSpeedButton).tag.tostring() ,'0');
    BtnLuz.ImageIndex:=0;
    BtnLuz.TagString:='-';
  end;

end;

procedure TFPrinc.BtnLuzClick(Sender: TObject);
begin
  if (BtnLuz.TagString<>'+') then
  begin
    TMSMQTTClient1.Publish('casa/room1/luz','1');
    BtnLuz.ImageIndex:=1;
    BtnLuz.TagString:='+';
  end
  else
  begin
    TMSMQTTClient1.Publish('casa/room1/luz','0');
    BtnLuz.ImageIndex:=0;
    BtnLuz.TagString:='-';
  end;

end;

procedure TFPrinc.Timer1Timer(Sender: TObject);
begin
   //BtnConectar.OnClick(Sender);
end;

procedure TFPrinc.TMSMQTTClient1ConnectedStatusChanged(ASender: TObject;
  const AConnected: Boolean; AStatus: TTMSMQTTConnectionStatus);
begin
 if (AConnected) then
 begin
 // The client is now connected and you can now start interacting with the broker.
    //ShowMessage('Conectado !');
    GhiFunc.MensagemToast(self, 'Conectado !!', TAlignLayout.Center, TAlphaColorRec.SkyBlue);
    BtnSuscribirse.OnClick(ASender);
    ChangeTabAction3.ExecuteTarget(self);
 end
 else
 begin
     // The client is NOT connected and any interaction with the broker will result in an exception.
     case AStatus of
       csConnectionRejected_InvalidProtocolVersion,
       csConnectionRejected_InvalidIdentifier,
       csConnectionRejected_ServerUnavailable,
       csConnectionRejected_InvalidCredentials,
       csConnectionRejected_ClientNotAuthorized:
       ; // the connection is rejected by broker
       csConnectionLost:
      //  BtnConectar.OnClick(ASender)
       ; // the connection with the broker is lost
       csConnecting:
       ; // The client is trying to connect to the broker
       csReconnecting:
          GhiFunc.MensagemToast(self, 'Tratando de reconectar !!', TAlignLayout.Center, TAlphaColorRec.SkyBlue);
        // The client is trying to reconnect to the broker
     end;
 end;
end;

procedure TFPrinc.TMSMQTTClient1PublishReceived(ASender: TObject;
  APacketID: Word; ATopic: string; APayload: TArray<System.Byte>);
Var
  Temp1:Integer;
  Topic, Resultado, temperatura:String;
begin
  temperatura:='';
  Topic:=ATopic;
  Resultado:=Trim(TEncoding.UTF8.GetString(APayload));
  Memo1.Lines.Add(Topic+' = '+Resultado);
  if (Topic='casa/room1/luz') then
  begin
    if (Resultado='1') then
    begin
      BtnLuz.TagString:='+';
      BtnLuz.ImageIndex:=1;
    end
    else
    begin
      BtnLuz.TagString:='-';
      BtnLuz.ImageIndex:=0;
    end;
  end;

  if (Topic='casa/room1/luz1') then
  begin
    if (Resultado='1') then
    begin
      BtnLuz1.TagString:='+';
      BtnLuz1.ImageIndex:=1;
    end
    else
    begin
      BtnLuz1.TagString:='-';
      BtnLuz1.ImageIndex:=0;
    end;
  end;

  if (Topic='casa/room1/luz2') then
  begin
    if (Resultado='1') then
    begin
      BtnLuz2.TagString:='+';
      BtnLuz2.ImageIndex:=1;
    end
    else
    begin
      BtnLuz2.TagString:='-';
      BtnLuz2.ImageIndex:=0;
    end;
  end;

  if (Topic='casa/room1/luz3') then
  begin
    if (Resultado='1') then
    begin
      BtnLuz3.TagString:='+';
      BtnLuz3.ImageIndex:=1;
    end
    else
    begin
      BtnLuz3.TagString:='-';
      BtnLuz3.ImageIndex:=0;
    end;
  end;

  if (Topic='casa/room1/mov1') then
  begin
    if (Resultado='1') then
      ImgMov.Bitmap.LoadFromResource('motion_on')
    else
      ImgMov.Bitmap.LoadFromResource('motion_off');
  end;

  if (Topic='casa/room1/puerta1') then
  begin
    if (Resultado='1') then
    BEGIN
      ImgPuerta1.Bitmap.LoadFromResource('door_on');
      Sound(1000);
    END
    else
    BEGIN
      ImgPuerta1.Bitmap.LoadFromResource('door_off');
    END;
  end;

  if (Topic='casa/room1/temperatura') then
  begin
    temperatura:=COPY(Resultado,1,pos('.',Resultado)-1);
    Temp1:=Trunc(temperatura.ToInteger());
    temperatura:=COPY(Resultado,1,pos('.',Resultado)+2);
    LTemp.Text:=temperatura+' C';
    LedTemp.Value:= Temp1;
    LedTemp.PeakValue:=Temp1;
  end;

  if (Topic='casa/room1/datos') then
  begin
    LDatos.Text:=Resultado;
  end;

end;

end.
