unit ClienteServidor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Datasnap.DBClient, Data.DB, ExceptionManager,
  Vcl.ExtCtrls,CopyProcess;

type
  TServidor = class
  private
    FPath: String;
  public
    constructor Create;
    //Tipo do parâmetro não pode ser alterado
    procedure SalvarArquivos(AData: OleVariant; fileNumber :integer = 0);
  end;

  TfClienteServidor = class(TForm)
    ProgressBar: TProgressBar;
    btEnviarSemErros: TButton;
    btEnviarComErros: TButton;
    btEnviarParalelo: TButton;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure btEnviarSemErrosClick(Sender: TObject);
    procedure btEnviarComErrosClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btEnviarParaleloClick(Sender: TObject);

    procedure Timer1Timer(Sender: TObject);
  private
    FPath: String;
    FServidor: TServidor;
    procedure doRollbackFiles;
    function InitDataset: TClientDataset;
  public
  end;

var
  fClienteServidor: TfClienteServidor;

  CopyController :  TCopyController;

const
  QTD_ARQUIVOS_ENVIAR = 100;

implementation

uses
  IOUtils;

{$R *.dfm}

procedure TfClienteServidor.doRollbackFiles;
var i           : integer;
    sr          : TSearchRec;
    localFolder : String;
begin
  localFolder :=  (ExtractFilePath(ParamStr(0))) + '\Servidor\';

  I := FindFirst(localFolder+'*.*', faAnyFile, SR);
  while I = 0 do
  begin
    DeleteFile(localFolder + SR.Name);
    I := FindNext(SR);
  end;

end;

procedure TfClienteServidor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Libera objetos locais
   freeandnil(FServidor);
   if Assigned(CopyController.Servidor) then
   CopyController.Servidor.free;
   freeandnil(CopyController);

end;

procedure TfClienteServidor.btEnviarComErrosClick(Sender: TObject);
var
  cds: TClientDataset;
  i: Integer;
begin

  try
    ProgressBar.Position := 0;
    ProgressBar.Max      := QTD_ARQUIVOS_ENVIAR;

     if not DirectoryExists(FPath) then
      forcedirectories(FPath);

    for i := 0 to QTD_ARQUIVOS_ENVIAR do
    begin
      ProgressBar.Position := i;

      cds := InitDataset;
      cds.Append;
      TBlobField(cds.FieldByName('Arquivo')).LoadFromFile(FPath);

      cds.Post;
      FServidor.SalvarArquivos(cds.Data, i);
      cds.free;

      Application.Processmessages;

{$REGION Simulação de erro, não alterar}
      if i = (QTD_ARQUIVOS_ENVIAR / 2) then
        FServidor.SalvarArquivos(NULL);
{$ENDREGION}
    end;
    //    FServidor.SalvarArquivos(cds.Data);
  except
    ProgressBar.Position := 0;
    doRollbackFiles();
    raise ERollbackFiles.Create('Falha ao copiar arquivos para o servidor.');
  end;

end;

procedure TfClienteServidor.Timer1Timer(Sender: TObject);
begin
  try
    ProgressBar.Position := CopyController.ThreadsScore;
    Application.processmessages;

    if ProgressBar.Position = ProgressBar.Max then
    Timer1.Enabled := false;

  except
    Timer1.Enabled := false;
  end;
end;

procedure TfClienteServidor.btEnviarParaleloClick(Sender: TObject);
begin

  CopyController := TCopyController.Create();
  CopyController.EnvioParalelo();
  Timer1.Enabled := true;

end;

procedure TfClienteServidor.btEnviarSemErrosClick(Sender: TObject);
var
  cds: TClientDataset;
  i: Integer;
begin
  ProgressBar.Position := 0;
  ProgressBar.Max      := QTD_ARQUIVOS_ENVIAR;

   if not DirectoryExists(FPath) then
      forcedirectories(FPath);

  for i := 0 to QTD_ARQUIVOS_ENVIAR do
  begin
    ProgressBar.Position := i;
    cds := InitDataset;


    cds.Append;
    TBlobField(cds.FieldByName('Arquivo')).LoadFromFile(FPath);
    cds.Post;


    FServidor.SalvarArquivos(cds.Data,i);
    cds.free;

    Application.Processmessages;
  end;

end;


procedure TfClienteServidor.FormCreate(Sender: TObject);
begin
  inherited;
  FPath := (ExtractFilePath(ParamStr(0))) + '/pdf.pdf';
  FServidor := TServidor.Create;

end;

function TfClienteServidor.InitDataset: TClientDataset;
begin
  Result := TClientDataset.Create(nil);
  Result.FieldDefs.Add('Arquivo', ftBlob);
  Result.CreateDataSet;
end;

{ TServidor }

constructor TServidor.Create;
begin
  FPath := ExtractFilePath(ParamStr(0)) + 'Servidor\';

   if not DirectoryExists(FPath) then
      forcedirectories(FPath);
end;

procedure TServidor.SalvarArquivos(AData: OleVariant; fileNumber :integer);
var
  cds: TClientDataSet;
  FileName: string;
begin
  cds := TClientDataset.Create(nil);

  try
    try

      cds.Data := AData;

      {$REGION Simulação de erro, não alterar}
      if cds.RecordCount = 0 then
        Exit;
      {$ENDREGION}

      cds.First;

      while not cds.Eof do
      begin
        FileName := FPath + inttostr(fileNumber+1) + '.pdf';
        if TFile.Exists(FileName) then
          TFile.Delete(FileName);

        TBlobField(cds.FieldByName('Arquivo')).SaveToFile(FileName);
        cds.Next;
      end;

    except

      raise;
    end;
  finally
    cds.free;
  end;
end;

end.
