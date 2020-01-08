unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Menus,
  ExtCtrls, IdHTTP, IdSMTP, IdMessage, IdSSLOpenSSL, IdAntiFreeze;

type

  { TForm1 }

  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    IdAntiFreeze1: TIdAntiFreeze;
    IdMessage1: TIdMessage;
    IdSMTP1: TIdSMTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    MainMenu1: TMainMenu;
    Memo1: TMemo;
    MenuItem2: TMenuItem;
    Panel1: TPanel;
    procedure MenuItem2Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  IdMessage1.From.Address := Edit1.Text;
  IdMessage1.Recipients.EMailAddresses := Edit3.Text;
  IdMessage1.Charset := 'UTF-8';

  IdMessage1.Subject := Edit4.Text;
  IdMessage1.Date := now;

  IdMessage1.Body.Text := UTF8Encode(Memo1.Text);

  IdSMTP1.Host := 'smtp-relay.gmail.com';
  IdSMTP1.Port := 25;
  IdSMTP1.Username := Edit1.Text;
  IdSMTP1.Password := Edit2.Text;
  IdSMTP1.AuthType := satDefault;

  IdSSLIOHandlerSocketOpenSSL1 := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  IdSSLIOHandlerSocketOpenSSL1.Destination :=
    IdSMTP1.Host + ':' + IntToStr(IdSMTP1.Port);
  IdSSLIOHandlerSocketOpenSSL1.Host := IdSMTP1.Host;
  IdSSLIOHandlerSocketOpenSSL1.Port := IdSMTP1.Port;
  IdSSLIOHandlerSocketOpenSSL1.DefaultPort := 0;
  IdSSLIOHandlerSocketOpenSSL1.SSLOptions.Method := sslvTLSv1;
  IdSSLIOHandlerSocketOpenSSL1.SSLOptions.Mode := sslmUnassigned;

  IdSSLIOHandlerSocketOpenSSL1.SSLOptions.Method := sslvSSLv23;
  IdSMTP1.IOHandler := IdSSLIOHandlerSocketOpenSSL1;
  IdMessage1.IsEncoded := True;

  IdSMTP1.Connect();
  IdSMTP1.Send(IdMessage1);
  Application.ProcessMessages;
  IdSMTP1.Disconnect();
end;

end.
