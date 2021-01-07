unit ExceptionManager;

interface

uses
  System.SysUtils, Vcl.Dialogs;

  {Controlador de exce��es}
type
  TControlExceptions = class

  private
    procedure logAplicacao(sStr : String = '';sNomelog :String = '');
    function SomenteNumero(AValue: string):string;
  public
    procedure newException(e: Exception; sClassName : String);

  end;

{$REGION 'Exce��es personalizadas'}
type
  ERollbackFiles = class(Exception);
  EThreadCopyFiles = class(Exception);
{$ENDREGION}

implementation


function TControlExceptions.SomenteNumero(AValue: string):string;
Var
  I : Integer ;
  LenValue : Integer;
begin
  Result   := '' ;
  LenValue := Length( AValue ) ;
  For I := 1 to LenValue  do
  begin
     if CharInSet( AValue[I], ['0'..'9'] ) then
       Result := Result + AValue[I];
  end;
end;

procedure TControlExceptions.logAplicacao(sStr : String = '';sNomelog :String = '');
var arq         : TextFile;
    localFolder : String;
begin
  try
    try
      localFolder :=  (ExtractFilePath(ParamStr(0))) + '\log';

      if Trim(sNomelog) = '' then
      sNomelog := 'Log - '+SomenteNumero(Datetostr(date))+'.txt';

      ForceDirectories(localFolder);

      AssignFile(arq, localFolder+'\'+sNomelog);

      if not fileexists(localFolder+'\'+sNomelog) then
        Rewrite(arq)
      else
        Append(arq);

      sStr := Datetostr(date)+'-'
              +Timetostr(now)+'    '+
              sLineBreak+
              sStr+sLineBreak;

      Writeln(arq, sStr);
    except
    end;
  finally
    CloseFile(arq);
  end;
end;

procedure TControlExceptions.newException(e: Exception; sClassName : String);
begin

  try
//    if e is ERollbackFiles then   Dispara Alguma outra a��o

  finally
    logAplicacao('Tipo de Excess�o encontrada ......:'+e.classname +sLineBreak+
                 'Classe geradora ..................:'+sClassName+sLineBreak+
                 'Mensagem da exce��o ..............:'+e.Message);


  end;

end;

end.
