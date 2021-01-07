unit CopyProcess;

interface

uses
  Datasnap.DBClient,System.Threading, System.SysUtils, System.Variants, System.Classes,  ExceptionManager, System.IOUtils, Data.DB;

type
  TServidor = class
  private
    FPath: string;
  public
    constructor Create;
    //  Tipo do parâmetro não pode ser alterado
    procedure SalvarArquivos(AData: OleVariant; fileNumber: integer = 0);
  end;

  //  Desafio de implementação #3
  //  Controlador de copia dos arquivos para o servidor
  //  com foco em performance

type
  TCopyController = class

  private

    // Output do loop de copias para alimentar o progessbar
    // Um conjunto de 5 thread com seus respectivos contadores
    // se mostrou a melhor maneira de ganhar perfomance livrando
    // os processos auxiliares da rotina de Synchronize com a VCL
    fThreadsScore: integer;
    fTh1Score: integer;
    fTh2Score: integer;
    fTh3Score: integer;
    fTh4Score: integer;
    fTh5Score: integer;
    FPathOrigem: string;

    // Copia identica ao servidor fornecido
    FServidor: TServidor;

    // Array de processos auxiliares para ratear carga de dados
    tsk: array[0..4] of ITask;

    procedure newCopyThread(iFile: Integer);
    function InitDataset: TClientDataset;

    procedure setThreadsScore(aValue: integer);
    function getThreadsScore(): integer;

  public
    constructor Create;
    procedure EnvioParalelo();

    property ThreadsScore: integer read getThreadsScore write setThreadsScore;
    property Servidor: TServidor read FServidor write FServidor;
  end;

const
  QTD_ARQUIVOS_ENVIAR: integer = 100;

implementation



function TCopyController.InitDataset: TClientDataset;
begin
  Result := TClientDataset.Create(nil);
  Result.FieldDefs.Add('Arquivo', ftBlob);
  Result.CreateDataSet;
end;

procedure TCopyController.newCopyThread(iFile : Integer);
var iFlagTask : integer;
begin

    // Pra cada parte do conjunto de arquivos a ser enviado delego uma task
  case iFile of
    0: iFlagTask := 0;
    20: iFlagTask := 1;
    40: iFlagTask := 2;
    60: iFlagTask := 3;
    80: iFlagTask := 4;
  else
    exit;
  end;

  tsk[iFlagTask] := TTask.create(
  procedure
  var
    cds: TClientDataset;
    i: integer;
  begin
    try
      for i := iFile to iFile + 19 do
      begin

        cds := InitDataset;
        cds.Append;
        TBlobField(cds.FieldByName('Arquivo')).LoadFromFile(FPathOrigem +
          '/pdf.pdf');
        cds.Post;

        FServidor.SalvarArquivos(cds.Data, i);

        // Acumula variavel de contagem de copias separadamente
        case iFlagTask of
          0: inc(fTh1Score);
          1: inc(fTh2Score);
          2: inc(fTh3Score);
          3: inc(fTh4Score);
          4: inc(fTh5Score);
        end;

        cds.free;
      end;

    except
      raise
        EThreadCopyFiles.Create('Falha ao copiar arquivos para o servidor.');
    end;

  end);

  tsk[iFlagTask].Start;
end;

procedure TCopyController.setThreadsScore(aValue: integer);
begin
  self.fThreadsScore := aValue;
end;

constructor TCopyController.Create;
begin
  FPathOrigem := ExtractFilePath(ParamStr(0));
end;

procedure TCopyController.EnvioParalelo();
var i : integer;
begin
   FServidor := TServidor.Create;

   if not DirectoryExists(FServidor.FPath) then
      forcedirectories(FServidor.FPath);

   for i := 0 to QTD_ARQUIVOS_ENVIAR do
   begin

     // Divido a carga a ser copiada para 5 processos auxiliares.
     // Obs cada task copia apenas o seu intervalo de arquivos.
     if i in [0,20,40,60,80] then
       newCopyThread(i);

   end;

end;

function TCopyController.getThreadsScore: integer;
begin
  result := (fTh1Score+fTh2Score+fTh3Score+fTh4Score+fTh5Score);
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
