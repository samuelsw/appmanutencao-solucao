unit Threads;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TfThreads = class(TForm)
    edtnumThreads: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    ProgressBar1: TProgressBar;
    Memo1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure ConfiguraProgrssBar();
    procedure Button2Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fThreads: TfThreads;
  pbPosition : Integer;
implementation

{$R *.dfm}

procedure TfThreads.Button1Click(Sender: TObject);
var x : integer;
begin
  ConfiguraProgrssBar();
  Memo1.lines.clear;
  pbPosition := 0;

  for x := 0 to strtoint(edtnumThreads.text) - 1 do
  begin

    TThread.CreateAnonymousThread(
      procedure
      var
        i: integer;
      begin

        try
          Memo1.lines.add('Thread id ' + TThread.Current.ThreadID.ToString +
            ' Iniciando processamento');
          for i := 0 to 100 do
          begin
            sleep(Random(Strtoint(Edit2.Text)));


            // Problematica de seção crítica
            // Abordagem opcional , utilizar SyncObjs.TCriticalSection
            TThread.Synchronize(TThread.CurrentThread,
            procedure
            begin
              inc(pbPosition);
              ProgressBar1.Position := pbPosition;
            end);


          end;


        finally
          Memo1.lines.add('Thread id ' + TThread.Current.ThreadID.ToString +
            ' Finalizou processamento');
        end;

      end).start();

  end;

end;

procedure TfThreads.Button2Click(Sender: TObject);
begin
  showmessage('Variavel Acumulada: '+inttostr(pbPosition) +sLineBreak+
              'Barra de Progresso: '+inttostr(ProgressBar1.Position));
end;

procedure TfThreads.ConfiguraProgrssBar();
begin
  ProgressBar1.Max := (strtoint(edtnumThreads.text) * 101);
  ProgressBar1.Position := 0;
end;

procedure TfThreads.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if ((ProgressBar1.Max > 0) and (ProgressBar1.Position > 1)) and (ProgressBar1.Position <> ProgressBar1.Max) then
  begin
    Memo1.lines.add('Tentativa de fechar com Threads em processamento ! Aguarde o encerramento...');
    CanClose := false;
  end;
end;

end.
