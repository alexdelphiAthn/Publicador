unit inMtoPublish;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.Masks, ShellAPI,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, clGZip, clTcpClient,
  clSFtp, sevenzip, System.IniFiles, Vcl.ComCtrls, JvgPage,
  System.IOUtils, System.StrUtils, System.DateUtils, System.Net.HttpClient,
  System.Net.HttpClientComponent, System.JSON, JvDialogs;

type
  TfrmPublish = class(TForm)
    clsftp3: TclSFtp;
    m1: TMemo;
    sd7z: TSaveDialog;
    flpndlg1: TFileOpenDialog;
    sFtpClient: TclSFtp;
    jpcPestanas: TJvgPageControl;
    tsFicheros: TTabSheet;
    tsFTP: TTabSheet;
    lblPassword1: TLabel;
    edtServer: TEdit;
    lblPuerto: TLabel;
    edtPuerto: TEdit;
    lblCarpetaRemot: TLabel;
    edtCarpetaRemota: TEdit;
    lblPassword11: TLabel;
    edtUsuario: TEdit;
    lblPassFTP: TLabel;
    edtPassFTP: TEdit;
    btnEnviarFTP: TButton;
    lblOrigen: TLabel;
    edtOrigen: TEdit;
    btn3: TButton;
    btnComprimir: TButton;
    btnCheck: TButton;
    edtDestino: TEdit;
    lblOrigen1: TLabel;
    btnDestino: TButton;
    lblPassword: TLabel;
    edtPassword: TEdit;
    tsPatrones: TTabSheet;
    lblExtensiones: TLabel;
    edtExtension: TEdit;
    btnAddExt: TButton;
    lstExtensiones: TListBox;
    btnDeleteExt: TButton;
    tsCompilacion: TTabSheet;
    grp1: TGroupBox;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    edtVersion: TEdit;
    edtProjectPath: TEdit;
    btnSelectProject: TButton;
    edtLibVarGlobPath: TEdit;
    btnSelectLibVarGlob: TButton;
    edtVirusTotalAPIKey: TEdit;
    chkSendToVirusTotal: TCheckBox;
    btnCompile: TButton;
    btnGetDate: TButton;
    btnVirusTotal: TButton;
    dlgOpenPoject: TJvOpenDialog;
    chkVersionarVariable: TCheckBox;
    procedure btnCheckClick(Sender: TObject);
    procedure btnComprimirClick(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure btnDestinoClick(Sender: TObject);
    procedure btnEnviarFTPClick(Sender: TObject);
    procedure sFtpClientVerifyServer(Sender: TObject; const AHost, AKeyType,
      AFingerPrint, AHostKey: string; var AVerified: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAddExtClick(Sender: TObject);
    procedure btnDeleteExtClick(Sender: TObject);
    procedure btnCompileClick(Sender: TObject);
    procedure btnVirusTotalClick(Sender: TObject);
    procedure btnGetDateClick(Sender: TObject);
    procedure btnSelectProjectClick(Sender: TObject);
  private
    //FFileExtensions: TArray<string>;
    sOrigen, sDestino, sPassword, sServer, sServerPort,
    sFolderDest, sUserFtp, sPassFtp, sVersion, sProjFile, sGlobFile:string;
    sVirusTotalAPI : string;
    aFiles:TStringList;
    procedure LogMessage(const Msg: string);
    procedure RecorrerCarpetasConTDirectory(const CarpetaRaiz: string);
    function ExtraerDLLDeRecurso: string;
    procedure MakeDll;
    //para el ini
    procedure grabarIni;
    procedure leerIni;
    procedure InitControls;
    function leCadINI (clave, cadena : string; defecto : string) : string;
    procedure esCadINI (clave, cadena, valor : string);
    function UpdateVersionInFile(const FileName,
                                 NewVersion: string): Boolean;
    function CompileProject: Boolean;
    function GetDelphiLibPath: string;
    function ExecuteCommand2(const CommandLine, DirIni: string): Boolean;
    function ExecuteCommand(const Command,
                            Parameters,
                            DirIni: string): Boolean;
    function SendToVirusTotal(FilePath: string): Boolean;
    function GetAnalysisResult(const AnalysisID: string): string;
    procedure EnviarVirusTotal;
  public
    { Public declarations }
  end;

var
  frmPublish: TfrmPublish;



implementation

{$R *.dfm}
{$R recursos.res}

uses
  System.Types;

//FUNCIONES Y PROC DLL
function TfrmPublish.ExtraerDLLDeRecurso: string;
var
  ResStream: TResourceStream;
  FileStream: TFileStream;
  TempPath: string;
    function GetTempDir: string;
    var
      Buffer: array[0..MAX_PATH] of Char;
    begin
      GetTempPath(MAX_PATH, Buffer);
      Result := StrPas(Buffer);
      if Result[Length(Result)] <> '\' then
        Result := Result + '\';
    end;
begin
  // Crear ruta temporal
  TempPath := GetTempDir + '7z.dll';
  try
    // Verificar si ya existe
    if FileExists(TempPath) then
    begin
      Result := TempPath;
      Exit;
    end;

    // Extraer DLL del recurso
    ResStream := TResourceStream.Create(HInstance, 'MIDLL', RT_RCDATA);
    try
      FileStream := TFileStream.Create(TempPath, fmCreate);
      try
        FileStream.CopyFrom(ResStream, 0);
        Result := TempPath;
      finally
        FileStream.Free;
      end;
    finally
      ResStream.Free;
    end;

  except
    on E: Exception do
    begin
      ShowMessage('Error extrayendo DLL: ' + E.Message);
      Result := '';
    end;
  end;
end;

//EVENTOS DEL FORM
procedure TfrmPublish.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  grabarIni;
end;

procedure TfrmPublish.FormCreate(Sender: TObject);
begin
  MakeDll;
  leerIni;
  InitControls;
end;

procedure TfrmPublish.btnCheckClick(Sender: TObject);
var
  Arch: I7zInArchive;
  I: Integer;
begin
  if not FileExists(edtDestino.Text) then
  begin
    ShowMessage('El fichero comprimido: ' + edtDestino.Text + ' no existe');
  end
  else
  begin
    M1.Lines.Clear;
    M1.Lines.Add(StringOfChar('=', 30));
    try
      Arch := CreateInArchive(CLSID_CFormat7z);
      Arch.OpenFile(edtDestino.Text);
      Arch.SetPassword(edtPassword.Text);
      for I := 0 to Arch.NumberOfItems - 1 do
        if not Arch.ItemIsFolder[I] then
          M1.Lines.Add(Arch.ItemPath[I]);
    except
      on E:Exception do
      begin
        M1.Lines.Add(Format('ERROR: [%s] %s', [E.ClassName, E.Message]));
        raise;
      end;
    end;
  end;
end;    //https://jachguate.wordpress.com/2012/12/10/7zip-y-delphi/

procedure TfrmPublish.RecorrerCarpetasConTDirectory(const CarpetaRaiz: string);
var
  Archivos: TStringDynArray;
  Carpetas: TStringDynArray;
  Archivo: string;
  Carpeta: string;
      function IsValidExtension(const FileName: string): Boolean;
      var
        sFileMask: string;
        ValidExt: string;
      begin
        Result := False;
        sFileMask := LowerCase(ExtractFileName(FileName));
        for ValidExt in lstExtensiones.Items do
        begin
          if MatchesMask(sFileMask, ValidExt) then
          begin
            Result := True;
            Break;
          end;
        end;
      end;
begin
  try
    // Obtener todos los archivos de la carpeta actual
    Archivos := TDirectory.GetFiles(CarpetaRaiz);
    for Archivo in Archivos do
    begin
      if IsValidExtension(Archivo) then
      begin
        aFiles.Add(Archivo);
        M1.Lines.Add('Archivo: ' + Archivo);
      end;
    end;
    // Obtener todas las subcarpetas
    Carpetas := TDirectory.GetDirectories(CarpetaRaiz);
    for Carpeta in Carpetas do
    begin
      M1.Lines.Add('Carpeta: ' + Carpeta);
      // Llamada recursiva para procesar subcarpetas
      RecorrerCarpetasConTDirectory(Carpeta);
    end;
  except
    on E: Exception do
      M1.Lines.Add('Error: ' + E.Message);
  end;
end;

procedure TfrmPublish.sFtpClientVerifyServer(Sender: TObject; const AHost, AKeyType,
  AFingerPrint, AHostKey: string; var AVerified: Boolean);
begin
  AVerified := True;
  m1.Lines.Add('Servidor: ' + AHost + ' - Fingerprint: ' + AFingerPrint);
end;

procedure TfrmPublish.btnComprimirClick(Sender: TObject);
var
   Arch: I7zOutArchive;
   AFileName: string;
   DirectorioBase, RutaRelativa:string;
   LenBase:Integer;
begin
//  if sd7z.Execute then
//  begin
    Arch := CreateOutArchive(CLSID_CFormat7z);
    SetCompressionLevel(Arch, 9);
    SevenZipSetCompressionMethod(Arch, m7LZMA);
    Arch.SetPassword(edtPassword.Text);
    M1.Lines.Clear;
    if not Assigned(aFiles) then
      aFiles := TStringList.Create
    else
      aFiles.Clear;
    DirectorioBase := IncludeTrailingPathDelimiter(edtOrigen.Text);
    LenBase := Length(DirectorioBase);
    RecorrerCarpetasConTDirectory(edtOrigen.Text);
    for AFileName in aFiles  do
    begin
     // Quitar el directorio base para obtener ruta relativa
      if Pos(UpperCase(DirectorioBase), UpperCase(AFileName)) = 1 then
        RutaRelativa := Copy(AFileName, LenBase + 1, MaxInt)
      else
        RutaRelativa := ExtractFileName(AFileName);
      // Convertir \ a / (opcional pero recomendado)
      RutaRelativa := StringReplace(RutaRelativa, '\', '/', [rfReplaceAll]);
      Arch.AddFile(AFileName, RutaRelativa);
      M1.Lines.Add(AFileName);
      M1.Update;
    end;
    M1.Lines.Add(StringOfChar('=', 30));
    M1.Lines.Add('Finalizado');
    Arch.SaveToFile(edtDestino.Text);
//  end;
end;

procedure TfrmPublish.btn3Click(Sender: TObject);
begin
  flpndlg1.DefaultFolder := edtOrigen.Text;
  if flpndlg1.Execute then
    edtOrigen.Text := flpndlg1.FileName;
end;

procedure TfrmPublish.btnAddExtClick(Sender: TObject);
begin
  if (edtExtension.Text <> '')  then
    lstExtensiones.Items.Add(edtExtension.Text);
end;

procedure TfrmPublish.btnDeleteExtClick(Sender: TObject);
begin
if lstExtensiones.ItemIndex >= 0 then
    lstExtensiones.Items.Delete(lstExtensiones.ItemIndex);
end;

procedure TfrmPublish.btnDestinoClick(Sender: TObject);
begin
  if sd7z.Execute then
    edtDestino.Text := sd7z.FileName;
end;

procedure TfrmPublish.btnEnviarFTPClick(Sender: TObject);
var
  sNameFile:string;
begin
  try
    // Configuración de conexión
    SftpClient.Server := edtServer.Text; // IP o nombre del servidor
    SftpClient.Port := StrToIntDef(edtPuerto.Text, 22); // Puerto SFTP (por defecto 22)
    SftpClient.UserName := edtUsuario.Text;
    SftpClient.Password := edtPassFtp.text;
    try
      // Conectar al servidor
      SftpClient.Open;
      m1.Lines.Clear;
      m1.Lines.Add('Conectado al servidor SFTP');
      // Cambiar al directorio remoto donde quieres subir el archivo (opcional)
      if ((edtCarpetaRemota.Text <> '') or (edtCarpetaRemota.Text <> '/')) then
        SftpClient.ChangeCurrentDir(edtCarpetaRemota.Text);
      // Enviar el archivo
      sNameFile := ExtractFileName(edtDestino.Text);
      SftpClient.PutFile(edtDestino.Text, sNameFile);
      m1.Lines.Add('Archivo '+sNameFile+' enviado correctamente');
    except
      on E: Exception do
      begin
        WriteLn('Error al enviar archivo: ' + E.Message);
      end;
    end;
  finally
    // Cerrar conexión
    if SftpClient.Active then
      SftpClient.Close;
  end;
end;

procedure TfrmPublish.btnGetDateClick(Sender: TObject);
begin
  if (Length(edtVersion.Text) >= 3)  then
  begin
    edtVersion.Text := Copy(edtVersion.Text , 1, 3);
    edtVersion.Text := edtVersion.Text + '.' + FormatDateTime('yyyymmddhhnn', Now);
  end;
end;

procedure TfrmPublish.btnSelectProjectClick(Sender: TObject);
begin
  if dlgOpenPoject.Execute() then
    edtProjectPath.Text := dlgOpenPoject.FileName;
end;

procedure TfrmPublish.btnVirusTotalClick(Sender: TObject);
begin
  EnviarVirusTotal;
end;

procedure TfrmPublish.MakeDll;
var
  DLLPath: string;
  DLLHandle: THandle;
begin
  // Extraer DLL del recurso
  DLLPath := ExtraerDLLDeRecurso;
  DLLHandle := LoadLibrary(PChar(DLLPath));
end;

function TfrmPublish.leCadINI (clave, cadena : string; defecto : string) : string;
var
  sIniFile:string;
begin
  if ParamStr(2) = '' then
    sIniFile := ExtractFilePath(ParamStr(0)) +
        TPath.GetFileNameWithoutExtension(ExtractFileName(ParamStr(0))) + '.ini'
  else
    sIniFile := ExtractFilePath(ParamStr(0)) + ParamStr(2);

  with tinifile.create (sIniFile) do
  try
    result := readString(clave, cadena, defecto);
    if result = defecto then
      esCadINI(clave, cadena, defecto);
  finally
    free;
  end;
end;

procedure TfrmPublish.esCadINI (clave, cadena, valor : string);
var
   sIniFile:string;
begin
  if ParamStr(2) = '' then
    sIniFile := ExtractFilePath(ParamStr(0)) +
        TPath.GetFileNameWithoutExtension(ExtractFileName(ParamStr(0))) + '.ini'
  else
    sIniFile := ExtractFilePath(ParamStr(0)) + ParamStr(2);
  with tinifile.create (sIniFile) do
  try
    writeString (clave, cadena, valor);
  finally
    free;
  end;
end;

procedure TfrmPublish.leerIni;
var
  i: Integer;
  extensiones: string;
begin
  sOrigen      := leCadIni('Basic', 'Source', 'c:\');
  sDestino     := leCadIni('Basic', 'Destination', 'c:\');
  sPassword    := leCadIni('Basic', 'PasswordZip', 'passZip');
  sServer      := leCadIni('sFTP', 'Server', 'server.com');
  sServerPort  := leCadIni('sFTP', 'Port', '21');
  sUserFtp     := leCadIni('sFTP', 'User', 'user_ftp');
  sPassFtp     := leCadIni('sFTP', 'FtpPasswd', 'passftp');
  sFolderDest  := leCadIni('sFTP', 'FolderDest', '/');
  sVersion     := leCadIni('Compilation', 'Version', '109');
  sProjFile    := leCadINI('Compilation', 'ProjectFile', 'c:\MyProject');
  sVirusTotalAPI := leCadINI('Other', 'APIVirusTotal', '000000000000000000');
   //Leer extensiones del INI (guardadas como string separado por comas)
  extensiones := leCadIni('Files', 'Extensions', '*.exe,*.dll,*.txt');
   //Cargar extensiones en el ListBox
  lstExtensiones.Items.Clear;
  lstExtensiones.Items.CommaText := extensiones;
end;

procedure TfrmPublish.InitControls;
begin
  edtOrigen.Text              := sOrigen;
  edtDestino.Text             := sDestino;
  edtPassword.Text            := sPassword;
  edtServer.Text              := sServer;
  edtPuerto.Text              := sServerPort;
  edtUsuario.Text             := sUserFtp;
  edtPassFTP.Text             := sPassFtp;
  edtCarpetaRemota.Text       := sFolderDest;
  edtVersion.Text             := sVersion;
  edtProjectPath.Text         := sProjFile;
  edtLibVarGlobPath.Text      := sGlobFile;
  edtVirusTotalAPIKey.Text    := sVirusTotalAPI;
end;

procedure TfrmPublish.grabarIni;
var
  i: Integer;
  extensiones: string;
begin
  sOrigen       := edtOrigen.Text;
  sDestino      := edtDestino.Text;
  sPassword     := edtPassword.Text;
  sServer       := edtServer.Text;
  sServerPort   := edtPuerto.Text;
  sUserFtp      := edtUsuario.Text;
  sPassFtp      := edtPassFTP.Text;
  sFolderDest   := edtCarpetaRemota.Text;
  sVersion      := edtVersion.Text;
  sProjFile     := edtProjectPath.Text;
  sGlobFile     := edtLibVarGlobPath.Text;
  sVirusTotalAPI := edtVirusTotalApiKey.Text;
  // Convertir lista de extensiones a string separado por comas
  extensiones := '';
  for i := 0 to lstExtensiones.Items.Count - 1 do
  begin
    if i > 0 then
      extensiones := extensiones + ',';
    extensiones := extensiones + lstExtensiones.Items[i];
  end;
  // Grabar en INI
  esCadIni('Basic',       'DirSource',      sOrigen);
  esCadIni('Basic',       'DirDestination', sDestino);
  esCadIni('Basic',       'PasswordZip',    sPassword);
  esCadIni('sFTP',        'Server',         sServer);
  esCadIni('sFTP',        'Port',           sServerPort);
  esCadIni('sFTP',        'User',           sUserFtp);
  esCadIni('sFTP',        'FtpPasswd',      sPassFtp);
  esCadIni('sFTP',        'FolderDest',     sFolderDest);
  esCadIni('Files',       'Extensions',     extensiones);
  esCadINI('Compilation', 'Version',        sVersion);
  esCadINI('Compilation', 'ProjectFile',    sProjFile);
  esCadINI('Compilation', 'LibGlobFile',    sGlobFile);
  esCadINI('Other', 'APIVirusTotal', sVirusTotalAPI);
end;

//FUNCIONES Y PROC COMPILACION
function TfrmPublish.UpdateVersionInFile(const FileName,
                                         NewVersion: string): Boolean;
var
  FileContent: TStringList;
  i: Integer;
  Line: string;
  Found: Boolean;
begin
  Result := False;
  Found := False;

  if not FileExists(FileName) then
    Exit;

  FileContent := TStringList.Create;
  try
    // Leer archivo
    FileContent.LoadFromFile(FileName);

    // Buscar y reemplazar la línea de versión
    for i := 0 to FileContent.Count - 1 do
    begin
      Line := Trim(FileContent[i]);

      // Buscar línea que contenga "Fversion :="
      if (Pos('Fversion', Line) > 0) and (Pos(':=', Line) > 0) then
      begin
        // Reemplazar con nueva versión
        FileContent[i] := '  Fversion := ''' + NewVersion + ''';';
        Found := True;
        m1.Lines.Add('Línea original: ' + Line);
        m1.Lines.Add('Nueva línea: ' + FileContent[i]);
      end;
    end;
    if Found then
    begin
      // Guardar archivo modificado
      FileContent.SaveToFile(FileName);
      Result := True;
    end
    else
    begin
      m1.Lines.Add('ERROR: No se encontró la variable Fversion en el archivo');
    end;
  finally
    FileContent.Free;
  end;
end;

function TfrmPublish.GetDelphiLibPath: string;
var
  BasePath:string;
begin
  BasePath := 'c:\program files (x86)\embarcadero\studio\20.0';

  // Construir paths básicos
  Result := '"' + BasePath + '\lib\Win32\release"';
  Result := Result + ';C:\Users\Alejansro\Documents\Embarcadero\Studio\20.0\Imports';
  Result := Result + ';"' + BasePath + '\Imports"';
  Result := Result + ';C:\Users\Public\Documents\Embarcadero\Studio\20.0\Dcp';
  Result := Result + ';"' + BasePath + '\include"';

  // Agregar paths de componentes de terceros (estos generalmente son independientes de la versión)
  Result := Result + ';"C:\Program Files (x86)\Devart\UniDAC for RAD Studio 10.3\Bin\Win32"';
  Result := Result + ';"C:\Program Files (x86)\Devart\UniDAC for RAD Studio 10.3\Lib\Win32"';
  Result := Result + ';"C:\DISCO DURO\DevExpressVCL20.2.6\Library\RS26"';
  Result := Result + ';"c:\DISCO DURO\jedi"';
  Result := Result + ';"C:\DISCO DURO\jedi\jcl\lib\d26\win32"';
  Result := Result + ';"C:\DISCO DURO\jedi\jcl\source\include"';
  Result := Result + ';"C:\DISCO DURO\sqlbuilder\src"';
  Result := Result + ';"C:\DISCO DURO\sqlbuilder\dependencies\gaSQLParser\src"';
  Result := Result + ';"C:\DISCO DURO\SynEdit\Source"';
  Result := Result + ';"C:\DISCO DURO\crypt\DCPCrypt-master\Ciphers"';
  Result := Result + ';"C:\DISCO DURO\crypt\DCPCrypt-master"';
  Result := Result + ';"C:\DISCO DURO\jedi\jvcl\lib\D26\win32"';
  Result := Result + ';"C:\DISCO DURO\FastMM4"';
  Result := Result + ';"C:\Program Files (x86)\FastReport 6 VCL Enterprise\LibD26"';
  Result := Result + ';"C:\DISCO DURO\jcl\jcl\lib\d26\win32"';
  Result := Result + ';"C:\DISCO DURO\jcl\jcl\source\include"';
  Result := Result + ';"C:\DISCO DURO\jvcl\jvcl\lib\D26\win32"';
  Result := Result + ';"C:\DISCO DURO\jvcl\jvcl\common"';
  Result := Result + ';"C:\DISCO DURO\jvcl\jvcl\Resources"';
  Result := Result + ';"C:\DISCO DURO\clever9\SourceFiles\ssh"';
  Result := Result + ';"C:\DISCO DURO\clever9\SourceFiles\common"';
end;

function TfrmPublish.CompileProject: Boolean;
var
  Command, Parameters: WideString;
  ProjectDir: string;
  ProjectName: string;
  DelphiBin: string;
  OriginalDir: string;
  Paths_I:string;
  function GetDelphiBinPath: string;
    begin
     Result := 'c:\program files (x86)\embarcadero\studio\20.0\bin'
  end;
begin
  Result := False;

  ProjectDir := ExtractFilePath(edtProjectPath.Text);
  ProjectName := ExtractFileName(edtProjectPath.Text);
  DelphiBin := GetDelphiBinPath;

  // Guardar directorio original
//  OriginalDir := GetCurrentDir;

  m1.Lines.Add('=== CONFIGURACIÓN DE COMPILACIÓN ===');
  m1.Lines.Add('Versión Delphi: 10.3' );
  m1.Lines.Add('Compilador: ' + DelphiBin + '\dcc32.exe');
  m1.Lines.Add('Directorio de trabajo: ' + ProjectDir);
  m1.Lines.Add('Archivo proyecto: ' + ProjectName);
  m1.Lines.Add('');

//  m1.Lines.Add('Posicionado en directorio: ' + GetCurrentDir);

  Paths_I := '"c:\program files (x86)\embarcadero\studio\20.0\lib\Win32\release"';
  Paths_I := Paths_I + ';C:\Users\Alejansro\Documents\Embarcadero\Studio\20.0\Imports';
  Paths_I := Paths_I + ';"c:\program files (x86)\embarcadero\studio\20.0\Imports"';
  Paths_I := Paths_I + ';C:\Users\Public\Documents\Embarcadero\Studio\20.0\Dcp';
  Paths_I := Paths_I + ';"c:\program files (x86)\embarcadero\studio\20.0\include"';
  Paths_I := Paths_I + ';"C:\Program Files (x86)\Devart\UniDAC for RAD Studio 10.3\Bin\Win32"';
  Paths_I := Paths_I + ';"C:\Program Files (x86)\Devart\UniDAC for RAD Studio 10.3\Lib\Win32"';
  Paths_I := Paths_I + ';"C:\DISCO DURO\DevExpressVCL20.2.6\Library\RS26"';
  Paths_I := Paths_I + ';"c:\DISCO DURO\jedi"';
  Paths_I := Paths_I + ';"C:\DISCO DURO\jedi\jcl\lib\d26\win32"';
  Paths_I := Paths_I + ';"C:\DISCO DURO\jedi\jcl\source\include"';
  Paths_I := Paths_I + ';"C:\DISCO DURO\sqlbuilder\src"';
  Paths_I := Paths_I + ';"C:\DISCO DURO\sqlbuilder\dependencies\gaSQLParser\src"';
  Paths_I := Paths_I + ';"C:\DISCO DURO\SynEdit\Source"';
  Paths_I := Paths_I + ';"C:\DISCO DURO\crypt\DCPCrypt-master\Ciphers"';
  Paths_I := Paths_I + ';"C:\DISCO DURO\crypt\DCPCrypt-master"';
  Paths_I := Paths_I + ';"C:\DISCO DURO\jedi\jvcl\lib\D26\win32"';
  Paths_I := Paths_I + ';"C:\DISCO DURO\FastMM4"';
  Paths_I := Paths_I + ';"C:\Program Files (x86)\FastReport 6 VCL Enterprise\LibD26"';
  Paths_I := Paths_I + ';"C:\DISCO DURO\jcl\jcl\lib\d26\win32"';
  Paths_I := Paths_I + ';"C:\DISCO DURO\jcl\jcl\source\include"';
  Paths_I := Paths_I + ';"C:\DISCO DURO\jvcl\jvcl\lib\D26\win32"';
  Paths_I := Paths_I + ';"C:\DISCO DURO\jvcl\jvcl\common"';
  Paths_I := Paths_I + ';"C:\DISCO DURO\jvcl\jvcl\Resources"';
  Paths_I := Paths_I + ';"C:\DISCO DURO\clever9\SourceFiles\ssh"';
  Paths_I := Paths_I + ';"C:\DISCO DURO\clever9\SourceFiles\common"';

  // Comando de compilación exacto basado en tu ejemplo
// Comando de compilación dividido en partes
  Command := '"' + DelphiBin + '\dcc32.exe"';
  Logmessage('Comando: '+ Command);
  Parameters := Parameters + ' -$D0 -$L- -$Y- --no-config -B -Q -TX.exe';
  Parameters := Parameters + ' -AGenerics.Collections=System.Generics.Collections;Generics.Defaults=System.Generics.Defaults;WinTypes=Winapi.Windows;WinProcs=Winapi.Windows;DbiTypes=BDE;DbiProcs=BDE;DbiErrs=BDE';
  Parameters := Parameters + ' -DRELEASE';
  Parameters := Parameters + ' -E.\Win32\Release';
  Parameters := Parameters + ' -I' + Paths_I;
  Parameters := Parameters + ' -LEC:\Users\Public\Documents\Embarcadero\Studio\20.0\Bpl';
  Parameters := Parameters + ' -LNC:\Users\Public\Documents\Embarcadero\Studio\20.0\Dcp';
  Parameters := Parameters + ' -NU.\Win32\Release';
  Parameters := Parameters + ' -NSWinapi;System.Win;Data.Win;Datasnap.Win;Web.Win;Soap.Win;Xml.Win;Bde;System;Xml;Data;Datasnap;Web;Soap;Vcl;Vcl.Imaging;Vcl.Touch;Vcl.Samples;Vcl.Shell;';
  Parameters := Parameters + ' -O' + Paths_I;
  Parameters := Parameters + ' -R' + Paths_I;
  Parameters := Parameters + ' -U' + Paths_I;
  Parameters := Parameters + ' -NBC:\Users\Public\Documents\Embarcadero\Studio\20.0\Dcp';
  Parameters := Parameters + ' -NHC:\Users\Public\Documents\Embarcadero\Studio\20.0\hpp\Win32';
  Parameters := Parameters + ' -NO.\Win32\Release';
  Parameters := Parameters + ' "' + ProjectName + '"';
  LogMessage('Parámetros: ' + Parameters);
  m1.Lines.Add('Ejecutando compilación...');
  ForceDirectories(ProjectDir + '\Win32\Release');
  try
    Result := ExecuteCommand2(Command+ ' ' + Parameters, ProjectDir);
  finally
    // Restaurar directorio original
//    SetCurrentDir(OriginalDir);
//    m1.Lines.Add('Directorio restaurado a: ' + GetCurrentDir);
  end;
end;

function TfrmPublish.ExecuteCommand2(const CommandLine, DirIni: string): Boolean;
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  SecurityAttr: TSecurityAttributes;
  ReadPipe, WritePipe: THandle;
  Buffer: array[0..4095] of Byte;
  BytesRead: DWORD;
  TempBytes: TBytes;
  Output: string;
  ExitCode: DWORD;
begin
  Result := False;
  Output := '';
  ReadPipe := INVALID_HANDLE_VALUE;
  WritePipe := INVALID_HANDLE_VALUE;

  try
    // Configurar seguridad para heredar handles
    SecurityAttr.nLength := SizeOf(SecurityAttr);
    SecurityAttr.bInheritHandle := True;
    SecurityAttr.lpSecurityDescriptor := nil;

    // Crear pipe
    if not CreatePipe(ReadPipe, WritePipe, @SecurityAttr, 0) then
    begin
      LogMessage('Error creando pipe: ' + IntToStr(GetLastError));
      Exit;
    end;

    // Configurar StartupInfo
    ZeroMemory(@StartupInfo, SizeOf(StartupInfo));
    StartupInfo.cb := SizeOf(StartupInfo);
    StartupInfo.hStdOutput := WritePipe;
    StartupInfo.hStdError := WritePipe;
    StartupInfo.hStdInput := GetStdHandle(STD_INPUT_HANDLE);
    StartupInfo.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
    StartupInfo.wShowWindow := SW_HIDE;

    // Crear proceso
    if not CreateProcess(nil, PChar(CommandLine), nil, nil, True, 0, nil,
                        PChar(DirIni), StartupInfo, ProcessInfo) then
    begin
      LogMessage('Error al ejecutar: ' + IntToStr(GetLastError));
      Exit;
    end;

    try
      // Cerrar el extremo de escritura del pipe inmediatamente
      CloseHandle(WritePipe);
      WritePipe := INVALID_HANDLE_VALUE;

      // Leer salida hasta que el proceso termine
      repeat
        Application.ProcessMessages;

        // Intentar leer con timeout
        if ReadFile(ReadPipe, Buffer, SizeOf(Buffer), BytesRead, nil) and (BytesRead > 0) then
        begin
          SetLength(TempBytes, BytesRead);
          Move(Buffer[0], TempBytes[0], BytesRead);
          Output := Output + TEncoding.UTF8.GetString(TempBytes); // UTF8 es más seguro
        end;

      until WaitForSingleObject(ProcessInfo.hProcess, 100) <> WAIT_TIMEOUT;

      // Verificar código de salida
      if GetExitCodeProcess(ProcessInfo.hProcess, ExitCode) then
      begin
        LogMessage('Proceso terminado con código: ' + IntToStr(ExitCode));
        Result := (ExitCode = 0); // Éxito solo si código de salida es 0
      end;

      LogMessage('Salida del proceso:' + sLineBreak + Output);

    finally
      CloseHandle(ProcessInfo.hProcess);
      CloseHandle(ProcessInfo.hThread);
    end;

  finally
    // Cleanup garantizado
    if ReadPipe <> INVALID_HANDLE_VALUE then
      CloseHandle(ReadPipe);
    if WritePipe <> INVALID_HANDLE_VALUE then
      CloseHandle(WritePipe);
  end;
end;

(*function TfrmPublish.ExecuteCommand2(const CommandLine, DirIni: string): Boolean;
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  SecurityAttr: TSecurityAttributes;
  ReadPipe, WritePipe: THandle;
  Buffer: array[0..4095] of Byte;
  BytesRead: DWORD;
  TempBytes: TBytes;
  Output: string;
begin
  Result := False;
  Output := '';

  // Seguridad para heredar handles
  SecurityAttr.nLength := SizeOf(SecurityAttr);
  SecurityAttr.bInheritHandle := True;
  SecurityAttr.lpSecurityDescriptor := nil;

  // Crear pipe
  if not CreatePipe(ReadPipe, WritePipe, @SecurityAttr, 0) then
    Exit;

  // Configurar StartupInfo
  ZeroMemory(@StartupInfo, SizeOf(StartupInfo));
  StartupInfo.cb := SizeOf(StartupInfo);
  StartupInfo.hStdOutput := WritePipe;
  StartupInfo.hStdError := WritePipe; // Captura también stderr
  StartupInfo.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := SW_HIDE;

  // Crear proceso
  if CreateProcess(nil, PChar(CommandLine), nil, nil, True, 0, nil, PChar(DirIni),
    StartupInfo, ProcessInfo) then
  begin
    CloseHandle(WritePipe); // Cerramos escritura

    // Leer salida
    repeat
      Application.ProcessMessages;
      if PeekNamedPipe(ReadPipe, nil, 0, nil, @BytesRead, nil) and (BytesRead > 0) then
      begin
        ZeroMemory(@Buffer, SizeOf(Buffer));
        ReadFile(ReadPipe, Buffer, SizeOf(Buffer), BytesRead, nil);
        SetLength(TempBytes, BytesRead);
        Move(Buffer[0], TempBytes[0], BytesRead);
        Output := Output + TEncoding.Default.GetString(TempBytes);
      end;
    until WaitForSingleObject(ProcessInfo.hProcess, 50) <> WAIT_TIMEOUT;

    // Leer cualquier resto de salida
    repeat
      ReadFile(ReadPipe, Buffer, SizeOf(Buffer), BytesRead, nil);
      if BytesRead > 0 then
      begin
        SetLength(TempBytes, BytesRead);
        Move(Buffer[0], TempBytes[0], BytesRead);
        Output := Output + TEncoding.Default.GetString(TempBytes);
      end;
    until BytesRead = 0;

    // Cerrar handles
    CloseHandle(ReadPipe);
    CloseHandle(ProcessInfo.hProcess);
    CloseHandle(ProcessInfo.hThread);

    LogMessage('Salida del proceso:' + sLineBreak + Output);
    Result := True;
  end
  else
  begin
    LogMessage('Error al ejecutar: ' + IntToStr(GetLastError));
    CloseHandle(ReadPipe);
    CloseHandle(WritePipe);
  end;
end;*)

// Función alternativa más simple usando ShellExecute (sin capturar salida)
function TfrmPublish.ExecuteCommand(const Command, Parameters, DirIni: string): Boolean;
var
  SEInfo: TShellExecuteInfo;
  ExitCode: DWORD;
  ExecuteFile, StartIn: string;
begin
  ExecuteFile := Command;
  StartIn := DirIni;

  FillChar(SEInfo, SizeOf(SEInfo), 0);
  SEInfo.cbSize := SizeOf(TShellExecuteInfo);
  SEInfo.fMask := SEE_MASK_NOCLOSEPROCESS;
  SEInfo.Wnd := Application.Handle;
  SEInfo.lpVerb := 'open';
  SEInfo.lpFile := PChar(ExecuteFile);
  SEInfo.lpParameters := PChar(Parameters);
  SEInfo.lpDirectory := PChar(StartIn);
  //SEInfo.nShow := SW_SHOWNORMAL;
  SEInfo.nShow := SW_HIDE;
  if ShellExecuteEx(@SEInfo) then
    repeat
      Application.ProcessMessages;
      GetExitCodeProcess(SEInfo.hProcess, ExitCode);
      Result := True;
    until (ExitCode <> STILL_ACTIVE)
  else
  begin
    LogMessage('Error: ' + IntToStr(GetLastError));
    Result := False;
  end;
end;

procedure TfrmPublish.LogMessage(const Msg: string);
begin
  m1.Lines.Add('[' + TimeToStr(Now) + '] ' + Msg);
end;

procedure TfrmPublish.btnCompileClick(Sender: TObject);
var
  NewVersion: string;
  CompileDateTime, ExeFile, OutputExe: string;
begin
  // Validar campos
  if not FileExists(edtProjectPath.Text) then
  begin
    m1.Lines.Add('Seleccione un archivo de proyecto válido (.dpr)');
    Exit;
  end;
  if chkVersionarVariable.Checked = False then
    if not FileExists(edtLibVarGlobPath.Text) then
    begin
      m1.Lines.Add('Seleccione el archivo inLibVarGlob.pas');
      Exit;
    end;
  btnCompile.Enabled := False;
  try
    NewVersion := edtVersion.Text;
    m1.Lines.Add('=== INICIANDO COMPILACIÓN ===');
    // Paso 1: Actualizar versión en el archivo
//    ProgressBar1.Position := 25;
    if chkVersionarVariable.Checked = False then
      if not UpdateVersionInFile(edtLibVarGlobPath.Text, NewVersion) then
      begin
        m1.Lines.Add('ERROR: No se pudo actualizar la versión');
        Exit;
      end
      else
      begin
        m1.Lines.Add('Actualizando versión en ' + ExtractFileName(edtLibVarGlobPath.Text));
        m1.Lines.Add('Versión actualizada correctamente');
        m1.Lines.Add('Nueva versión: ' + NewVersion);
      end;
    // Paso 2: Compilar proyecto
//    ProgressBar1.Position := 50;
    m1.Lines.Add('Iniciando compilación del proyecto...');
    if CompileProject then
    begin
      m1.Lines.Add('=== COMPILACIÓN EXITOSA ===');
      // Paso 3: Enviar a VirusTotal si está habilitado
      if chkSendToVirusTotal.Checked then
      begin
        EnviarVirusTotal;
      end;
//      ProgressBar1.Position := 100;
      m1.Lines.Add('Proceso completado exitosamente!' + #13#10 +
                  'Versión: ' + NewVersion);
    end
    else
    begin
      m1.Lines.Add('ERROR: Fallo en la compilación');
      m1.Lines.Add('Error en la compilación. Revise el log.');
    end;
  finally
//    ProgressBar1.Visible := False;
    btnCompile.Enabled := True;
  end;
end;

procedure TfrmPublish.EnviarVirusTotal;
var
  ExeFile, OutputExe:string;
begin
  //        ProgressBar1.Position := 85;
  m1.Lines.Add('Enviando a VirusTotal...');
  if Trim(edtVirusTotalAPIKey.Text) = '' then
  begin
    m1.Lines.Add('ADVERTENCIA: No se proporcionó API Key de VirusTotal');
  end
  else
  begin
    ExeFile := ChangeFileExt(edtProjectPath.Text, '.exe');
    OutputExe := ExtractFilePath(edtProjectPath.Text) +
                              'Win32\Release\' + ExtractFileName(ExeFile);
    if FileExists(OutputExe) then
    begin
      if SendToVirusTotal(OutputExe) then
        m1.Lines.Add('Archivo enviado a VirusTotal correctamente')
      else
        m1.Lines.Add('ERROR: Fallo al enviar a VirusTotal');
    end
    else
    begin
      m1.Lines.Add('ERROR: No se encontró el ejecutable compilado: ' + OutputExe);
    end;
  end;
end;

function TfrmPublish.SendToVirusTotal(FilePath: string): Boolean;
var
  HTTPClient: THTTPClient;
  Response: IHTTPResponse;
  JSONResponse: TJSONObject;
  AnalysisID: string;
  FileStream: TFileStream;
  Boundary: string;
  RequestBody: TStringStream;
  FileContent: TBytes;
  DataObj: TJSONObject;
  ResultSummary:string;
begin
  Result := False;
  if not FileExists(FilePath) then
  begin
    m1.Lines.Add('ERROR: Archivo no encontrado: ' + FilePath);
    Exit;
  end;
  HTTPClient := THTTPClient.Create;
  try
    // Configurar headers
    HTTPClient.CustomHeaders['x-apikey'] := Trim(edtVirusTotalAPIKey.Text);
    // Generar boundary para multipart
    Boundary := '----FormBoundary' + FormatDateTime('yyyymmddhhnnsszzz', Now);
    HTTPClient.ContentType := 'multipart/form-data; boundary=' + Boundary;
    // Leer archivo
    FileStream := TFileStream.Create(FilePath, fmOpenRead);
    try
      SetLength(FileContent, FileStream.Size);
      FileStream.ReadBuffer(FileContent[0], FileStream.Size);
      m1.Lines.Add('Subiendo archivo a VirusTotal...');
      m1.Lines.Add('Archivo: ' + ExtractFileName(FilePath));
      m1.Lines.Add('Tamaño: ' + FormatFloat('#,##0', FileStream.Size / 1024) + ' KB');
    finally
      FileStream.Free;
    end;
    // Construir body multipart manualmente
    RequestBody := TStringStream.Create('', TEncoding.UTF8);
    try
      // Inicio del boundary
      RequestBody.WriteString('--' + Boundary + #13#10);
      RequestBody.WriteString('Content-Disposition: form-data; name="file"; filename="' + ExtractFileName(FilePath) + '"' + #13#10);
      RequestBody.WriteString('Content-Type: application/octet-stream' + #13#10);
      RequestBody.WriteString(#13#10);
      // Contenido del archivo
      RequestBody.Write(FileContent, Length(FileContent));
      // Final del boundary
      RequestBody.WriteString(#13#10 + '--' + Boundary + '--' + #13#10);
      try
        // Enviar archivo
        Response := HTTPClient.Post('https://www.virustotal.com/api/v3/files', RequestBody);
        if Response.StatusCode = 200 then
        begin
          m1.Lines.Add('Respuesta de VirusTotal recibida');
          // Parsear respuesta JSON
          JSONResponse := TJSONObject.ParseJSONValue(Response.ContentAsString) as TJSONObject;
          if Assigned(JSONResponse) then
          try
            if JSONResponse.TryGetValue('data', DataObj) then
            begin
              if DataObj.TryGetValue('id', AnalysisID) then
              begin
                m1.Lines.Add('ID de análisis: ' + AnalysisID);
                m1.Lines.Add('URL del análisis: https://www.virustotal.com/gui/file-analysis/' + AnalysisID);
                // Esperar un momento y obtener resultado inicial
                m1.Lines.Add('Esperando resultado inicial...');
                Sleep(10000);
                ResultSummary := GetAnalysisResult(AnalysisID);
                if ResultSummary <> '' then
                  m1.Lines.Add('Resultado: ' + ResultSummary);
                Result := True;
              end
              else
              begin
                m1.Lines.Add('ERROR: No se recibió ID de análisis');
              end;
            end
            else
            begin
              m1.Lines.Add('ERROR en respuesta: ' + Response.ContentAsString);
            end;
          finally
            JSONResponse.Free;
          end;
        end
        else
        begin
          m1.Lines.Add('ERROR HTTP: ' + IntToStr(Response.StatusCode) + ' - ' + Response.StatusText);
          m1.Lines.Add('Respuesta: ' + Response.ContentAsString);
        end;
      except
        on E: Exception do
        begin
          m1.Lines.Add('ERROR al enviar a VirusTotal: ' + E.Message);
        end;
      end;
    finally
      RequestBody.Free;
    end;
  finally
    Sleep(0);
  end;
end;

function TfrmPublish.GetAnalysisResult(const AnalysisID: string): string;
var
  HTTPClient: THTTPClient;
  Response: IHTTPResponse;
  JSONResponse, DataObj, AttributesObj, StatsJSON: TJSONObject;
  Value: TJSONValue;
  Malicious, Suspicious, Harmless, Undetected: Integer;
begin
  Result := '';
  HTTPClient := THTTPClient.Create;
  try
    HTTPClient.CustomHeaders['x-apikey'] := Trim(edtVirusTotalAPIKey.Text);
    try
      Response := HTTPClient.Get('https://www.virustotal.com/api/v3/analyses/' + AnalysisID);
      if Response.StatusCode = 200 then
      begin
        JSONResponse := TJSONObject.ParseJSONValue(Response.ContentAsString) as TJSONObject;
        if Assigned(JSONResponse) then
        try
          if JSONResponse.TryGetValue('data', DataObj) then
          begin
            if DataObj.TryGetValue('attributes', AttributesObj) then
            begin
              if AttributesObj.TryGetValue('stats', StatsJSON) then
              begin
                Malicious := 0;
                Suspicious := 0;
                Harmless := 0;
                Undetected := 0;
                if StatsJSON.TryGetValue('malicious', Value) then
                  Malicious := Value.AsType<Integer>;
                if StatsJSON.TryGetValue('suspicious', Value) then
                  Suspicious := Value.AsType<Integer>;
                if StatsJSON.TryGetValue('harmless', Value) then
                  Harmless := Value.AsType<Integer>;
                if StatsJSON.TryGetValue('undetected', Value) then
                  Undetected := Value.AsType<Integer>;
                Result := Format('Malicioso: %d, Sospechoso: %d, Inofensivo: %d, No detectado: %d',
                                [Malicious, Suspicious, Harmless, Undetected]);

                if (Malicious > 0) or (Suspicious > 0) then
                  Result := '⚠️ ' + Result
                else
                  Result := '✅ ' + Result;
              end;
            end;
          end;
        finally
          JSONResponse.Free;
        end;
      end
      else
      begin
        m1.Lines.Add('ERROR HTTP al obtener resultado: ' + IntToStr(Response.StatusCode));
      end;
    except
      on E: Exception do
      begin
        m1.Lines.Add('ERROR al obtener resultado: ' + E.Message);
      end;
    end;
  finally
    HTTPClient.Free;
  end;
end;

end.
