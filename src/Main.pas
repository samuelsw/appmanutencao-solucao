unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.AppEvnts, ExceptionManager;

type
  TfMain = class(TForm)
    btDatasetLoop: TButton;
    btThreads: TButton;
    btStreams: TButton;
    ApplicationEvents1: TApplicationEvents;
    procedure ApplicationEvents1Exception(Sender: TObject; E: Exception);
    procedure btDatasetLoopClick(Sender: TObject);
    procedure btStreamsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btThreadsClick(Sender: TObject);
  private

  public

  end;

var
  fMain: TfMain;
  ControlExceptions : TControlExceptions;

implementation

uses
  DatasetLoop, ClienteServidor,Threads;

{$R *.dfm}

procedure TfMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  // Finaliza form , os objetos locais de la serão liberados
  fClienteServidor.Close;

  // Encerra objeto de controle de exceções
  ControlExceptions.free;
end;


procedure TfMain.FormCreate(Sender: TObject);
begin
  ControlExceptions := TControlExceptions.create();
end;


procedure TfMain.btDatasetLoopClick(Sender: TObject);
begin
  fDatasetLoop.Show;
end;

procedure TfMain.btStreamsClick(Sender: TObject);
begin
  fClienteServidor.Show;
end;

procedure TfMain.btThreadsClick(Sender: TObject);
begin
  fThreads.Show;
end;

procedure TfMain.ApplicationEvents1Exception(Sender: TObject; E: Exception);
begin
  try
    ControlExceptions.Newexception(E,sender.ClassName);
  finally
//    raise E;
  end;
end;


end.
