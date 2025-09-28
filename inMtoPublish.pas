{*****************************************************************************
 *                                                                           *
 *                    ALEJANDRO LAORDEN HIDALGO                              *
 *              Ingeniero en Informática de Gestión                          *
 *                           © 2025                                          *
 *                  alejandro.laorden@proton.me                              *
 *                                                                           *
 *****************************************************************************}

unit inMtoPublish;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.NetConsts, JclSysUtils, JclBase, System.RegularExpressions,
  System.Classes, Vcl.Graphics, System.Masks, ShellAPI, Registry, System.Types,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, clGZip, clTcpClient,
  clSFtp, sevenzip, System.IniFiles, Vcl.ComCtrls, JvgPage, System.Net.URLClient,
  System.IOUtils, System.StrUtils, System.DateUtils, System.Net.HttpClient,
  System.Net.HttpClientComponent, System.JSON, JvDialogs, clTcpClientSsh,
  Vcl.ExtCtrls, JvExStdCtrls, JvCombobox, Vcl.Menus;

type
  TDelphiPaths = record
    UnitPaths: string;      // Para -U
    ResourcePaths: string;  // Para -R
    IncludePaths: string;   // Para -I
    ObjectPaths: string;    // Para -O (raramente usado)
  end;
  TFileItem = record
    Name: string;
    FullPath: string;
    Size: Int64;
    PackedSize: Int64;
    ModificationDate: string;
    IsFolder: Boolean;
    Extension: string;
    IndentLevel: Integer;
  end;
  TfrmPublish = class(TForm)
    clsftp3: TclSFtp;
    m1: TMemo;
    sd7z: TSaveDialog;
    flpndlg1: TFileOpenDialog;
    sFtpClient: TclSFtp;
    dlgOpenPoject: TJvOpenDialog;
    dlgSelectFolder: TFileOpenDialog;
    dlgOpenLibVarGlob: TJvOpenDialog;
    jpcPestanas: TJvgPageControl;
    tsFicheros: TTabSheet;
    lblOrigen: TLabel;
    lblOrigen1: TLabel;
    lblPassword: TLabel;
    edtOrigen: TEdit;
    btn3: TButton;
    btnComprimir: TButton;
    btnCheck: TButton;
    edtDestino: TEdit;
    btnDestino: TButton;
    edtPassword: TEdit;
    tsCompilacion: TTabSheet;
    grp1: TGroupBox;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    edtVersion: TEdit;
    edtProjectPath: TEdit;
    btnSelectProject: TButton;
    edtLibVarGlobPath: TEdit;
    btnSelectLibVarGlob: TButton;
    btnCompile: TButton;
    btnGetDate: TButton;
    chkVersionarVariable: TCheckBox;
    tsFTP: TTabSheet;
    lblPassword1: TLabel;
    lblPuerto: TLabel;
    lblCarpetaRemot: TLabel;
    lblPassword11: TLabel;
    lblPassFTP: TLabel;
    edtServer: TEdit;
    edtPuerto: TEdit;
    edtCarpetaRemota: TEdit;
    edtUsuario: TEdit;
    edtPassFTP: TEdit;
    btnEnviarFTP: TButton;
    tsPublicarExe: TTabSheet;
    edtAddExe: TEdit;
    lstFilesExe: TListBox;
    btnAddExe: TButton;
    btnDeleteExe: TButton;
    btnSelectFileAdd: TButton;
    edtExtension: TEdit;
    lstExtensiones: TListBox;
    btnAddExt: TButton;
    btnDeleteExt: TButton;
    lblExtensiones: TLabel;
    spl1: TSplitter;
    lbl5: TLabel;
    edtExeDestPath: TEdit;
    lbl21: TLabel;
    btnSelectFolderCopyExe: TButton;
    btnComprimirExe: TButton;
    chkSendToVirusTotal: TCheckBox;
    edtVirusTotalAPIKey: TEdit;
    lbl4: TLabel;
    btnAnalizar: TButton;
    btnVirusTotal: TButton;
    edtAnalisisID: TEdit;
    btnEnviarFTPExe: TButton;
    lbl22: TLabel;
    edtBasePath: TEdit;
    lbl221: TLabel;
    edtCommonPath: TEdit;
    lbl222: TLabel;
    lbl223: TLabel;
    lbl224: TLabel;
    edtPlatForm: TEdit;
    lbl225: TLabel;
    lbl226: TLabel;
    edtConfig: TEdit;
    lbl2211: TLabel;
    edtOutputExe: TEdit;
    lbl22111: TLabel;
    edtParamAdd: TEdit;
    edtCompilerName: TEdit;
    edtVersionDelphi: TEdit;
    tsPerfiles: TTabSheet;
    cmbPerfiles: TJvComboBox;
    lbl6: TLabel;
    lblPerfilActual: TLabel;
    btnNuevoPerfil: TButton;
    btnBorrarPerfil: TButton;
    btnUsarPerfil: TButton;
    pm1: TPopupMenu;
    mnuIrDireccion: TMenuItem;
    mnuSeparador1: TMenuItem;
    mnuAbrirExplorador: TMenuItem;
    mnuVerEditor: TMenuItem;
    procedure btnBorrarPerfilClick(Sender: TObject);
    procedure btnNuevoPerfilClick(Sender: TObject);
    procedure btnCheckClick(Sender: TObject);
    procedure btnComprimirClick(Sender: TObject);
    procedure btnOrigenClick(Sender: TObject);
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
    procedure btnAnalizarClick(Sender: TObject);
    procedure btnSelectLibVarGlobClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnUsarPerfilClick(Sender: TObject);
    procedure btnAddExeClick(Sender: TObject);
    procedure btnDeleteExeClick(Sender: TObject);
    procedure btnSelectFileAddClick(Sender: TObject);
    procedure btnSelectFolderCopyExeClick(Sender: TObject);
    procedure btnComprimirEClick(Sender: TObject);
    procedure btnEnviarFTPExeClick(Sender: TObject);
    procedure mnuVerEditorClick(Sender: TObject);
    procedure mnuAbrirExploradorClick(Sender: TObject);
    procedure mnuIrDireccionClick(Sender: TObject);
    procedure pm1Popup(Sender: TObject);
  private
    FTextoLineaSeleccionada:string;
    FLineaSeleccionada:Integer;
    FURLEncontrada: string;
    sCurrentProfile:string;
    sOrigen, sDestino, sPassword, sServer, sServerPort, sExeDestPath,
    sAnalisisID, sFolderDest, sUserFtp, sPassFtp, sVersion, sProjFile,
    sGlobFile:string;
    sVirusTotalAPI : string;
    aFiles:TStringList;
    sDelphiBasePath: string;      // C:\Program Files (x86)\Embarcadero\Studio\20.0
    sDelphiCommonPath: string;    // C:\Users\Public\Documents\Embarcadero\Studio\20.0
    sCompilerName: string;        // dcc32.exe o dcc64.exe
    sDelphiVersion: string;       // 20.0, 21.0, 22.0, etc.
    sPlatform: string;            // Win32, Win64, Android, etc.
      // Configuración de compilación
    sBuildConfiguration: string;  // Release, Debug
    sOutputDirectory: string;     // .\Win32\Release, .\Win64\Release, etc.
    sAdditionalParams: string;    // Parámetros extra del compilador
  private
    function FormatFileSize(Size: Int64): string;
    procedure LogMessage(const Msg: string);
    procedure ShowArchiveStatistics(Arch: I7zInArchive);
    procedure RecorrerCarpetasConTDirectory(const CarpetaRaiz: string);
    function ExtraerDLLDeRecurso: string;
    procedure MakeDll;
    procedure grabarIni;
    procedure leerIni;
    procedure InitControls;
    function leCadINI (clave, cadena : string; defecto : string) : string;
    procedure esCadINI (clave, cadena, valor : string);
    function UpdateVersionInFile(const FileName,
                                 NewVersion: string): Boolean;
    function CompileProject: Boolean;
    //function ExecuteCommand2(const CommandLine, DirIni: string): Boolean;
    function ExecuteCommand3(const CommandLine, DirIni: string): Boolean;
    function SendToVirusTotal(FilePath: string): Boolean;
    function GetAnalysisResult(const AnalysisID: string): string;
    procedure EnviarVirusTotal;
    function ForceFileAnalysis(const FileHash: string): Boolean;
    function GetDelphiRegistryPaths: string;
    function ReadCompleteDelphiPaths(const DelphiVersion: string): TDelphiPaths;
    function CleanDuplicatePaths(const PathsString: string): string;
    procedure ProcessOutputLine(const Text: string);
    procedure UpdateProfileCombo;
    function ParsearLineaError(const Linea: string;
                                out NombreArchivo: string;
                                out NumeroLinea: Integer): Boolean;
    procedure AbrirEnNotepad(const RutaArchivo: string; Linea: Integer);
    function ExtraerRutaDesdeLineaDPR(const Linea, CarpetaBase: string): string;
    procedure InitProfile;
    function ObtenerRutaCompleta(const NombreArchivo: string): string;
    procedure AbrirEnExplorador(const Ruta: string);
    function ExtraerURL(const Texto: string): string;
    function DetectarRutaArchivo(const Linea: string;
                                 out RutaArchivo: string): Boolean;
    function EsURLValida(const URL: string): Boolean;
  private
    FDelphiPaths: TDelphiPaths;
    F7zDLLHandle: THandle;
  end;

var
  frmPublish: TfrmPublish;

implementation

uses
  inLibLog;

{$R *.dfm}
{$R recursos.res}

function TfrmPublish.ExtraerURL(const Texto: string): string;
var
  RegEx: TRegEx;
  Match: TMatch;
  URLsEncontradas: TArray<string>;
  i: Integer;
begin
  Result := '';

  // Patrones para diferentes tipos de URLs
  SetLength(URLsEncontradas, 0);

  // 1. URLs completas con protocolo
  RegEx := TRegEx.Create('(https?://[^\s<>"{}|\\^`\[\]]+)', [roIgnoreCase]);
  Match := RegEx.Match(Texto);
  if Match.Success then
  begin
    SetLength(URLsEncontradas, Length(URLsEncontradas) + 1);
    URLsEncontradas[High(URLsEncontradas)] := Match.Value;
  end;

  // 2. URLs sin protocolo pero con www
  if Length(URLsEncontradas) = 0 then
  begin
    RegEx := TRegEx.Create('(www\.[^\s<>"{}|\\^`\[\]]+)', [roIgnoreCase]);
    Match := RegEx.Match(Texto);
    if Match.Success then
    begin
      SetLength(URLsEncontradas, Length(URLsEncontradas) + 1);
      URLsEncontradas[High(URLsEncontradas)] := 'http://' + Match.Value;
    end;
  end;

  // 3. IPs con puerto (para servidores locales)
  if Length(URLsEncontradas) = 0 then
  begin
    RegEx := TRegEx.Create('((?:\d{1,3}\.){3}\d{1,3}(?::\d+)?(?:/[^\s]*)?)', [roIgnoreCase]);
    Match := RegEx.Match(Texto);
    if Match.Success then
    begin
      SetLength(URLsEncontradas, Length(URLsEncontradas) + 1);
      URLsEncontradas[High(URLsEncontradas)] := 'http://' + Match.Value;
    end;
  end;

  // 4. localhost con puerto
  if Length(URLsEncontradas) = 0 then
  begin
    RegEx := TRegEx.Create('(localhost:\d+(?:/[^\s]*)?)', [roIgnoreCase]);
    Match := RegEx.Match(Texto);
    if Match.Success then
    begin
      SetLength(URLsEncontradas, Length(URLsEncontradas) + 1);
      URLsEncontradas[High(URLsEncontradas)] := 'http://' + Match.Value;
    end;
  end;

  // Devolver la primera URL válida encontrada
  for i := 0 to High(URLsEncontradas) do
  begin
    if EsURLValida(URLsEncontradas[i]) then
    begin
      Result := URLsEncontradas[i];
      Break;
    end;
  end;
end;

function TfrmPublish.EsURLValida(const URL: string): Boolean;
var
  URLLower: string;
begin
  URLLower := LowerCase(URL);

  Result := (Pos('http://', URLLower) = 1) or
            (Pos('https://', URLLower) = 1) or
            (Pos('ftp://', URLLower) = 1);

  // Verificar que no termine en caracteres extraños
  if Result then
  begin
    var UltimoChar := URL[Length(URL)];
    Result := not CharInSet(UltimoChar, ['.', ',', ';', ')', ']', '}', '!',
                                         '?']);
  end;
end;

function TfrmPublish.ParsearLineaError(const Linea: string;
                                     out NombreArchivo: string;
                                     out NumeroLinea: Integer): Boolean;
var
  PosParentesis, PosPunto: Integer;
  ParteFinal, NumeroStr: string;
begin
  Result := False;
  NombreArchivo := '';
  NumeroLinea := 0;

  // Método 1: Buscar patrón de error del compilador: NombreArchivo.pas(número)
  PosParentesis := Pos('(', Linea);
  if PosParentesis > 0 then
  begin
    ParteFinal := Copy(Linea, 1, PosParentesis - 1);
    PosPunto := LastDelimiter('.', ParteFinal);

    if PosPunto > 0 then
    begin
      if (Pos('.pas', LowerCase(ParteFinal)) > 0) or
         (Pos('.dpr', LowerCase(ParteFinal)) > 0) or
         (Pos('.inc', LowerCase(ParteFinal)) > 0) then
      begin
        var InicioArchivo := PosPunto;
        while (InicioArchivo > 1) and (ParteFinal[InicioArchivo - 1] <> ' ') do
          Dec(InicioArchivo);

        NombreArchivo := Copy(ParteFinal, InicioArchivo, Length(ParteFinal) - InicioArchivo + 1);

        var FinParentesis := Pos(')', Linea, PosParentesis);
        if FinParentesis > PosParentesis then
        begin
          NumeroStr := Copy(Linea, PosParentesis + 1, FinParentesis - PosParentesis - 1);
          TryStrToInt(NumeroStr, NumeroLinea);
        end;
        Result := True;
        Exit;
      end;
    end;
  end;

  // Método 2: Buscar cualquier ruta de archivo (C:\ruta\archivo.ext)
  if not Result then
  begin
    Result := DetectarRutaArchivo(Linea, NombreArchivo);
    NumeroLinea := 0;
  end;
end;

procedure TfrmPublish.btnBorrarPerfilClick(Sender: TObject);
var
  ProfileName, AppName, ProfileFile: string;
begin
  if cmbPerfiles.ItemIndex < 0 then
    Exit;
  ProfileName := cmbPerfiles.Text;
  if MessageDlg('¿Está seguro de eliminar el perfil "' + ProfileName + '"?' + #13#10 +
                'Esta acción no se puede deshacer.',
                mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    AppName := TPath.GetFileNameWithoutExtension(ExtractFileName(ParamStr(0)));
    ProfileFile := ExtractFilePath(ParamStr(0)) + AppName + '_' +
                                                           ProfileName + '.ini';
    if FileExists(ProfileFile) then
    begin
      if DeleteFile(ProfileFile) then
      begin
        LogMessage('Perfil eliminado: ' + ProfileName);
        // Si estamos usando el perfil que se está borrando, cambiar a por defecto
        if sCurrentProfile = ProfileName then
        begin
          sCurrentProfile := '';
          lblPerfilActual.Caption := 'Perfil actual: (Por defecto)';
          LeerIni;
          InitControls;
        end;
        UpdateProfileCombo;
        LogMessage('Perfil eliminado correctamente');
      end
      else
        LogMessage('No se pudo eliminar el archivo del perfil');
    end
    else
      LogMessage('El archivo del perfil no existe');
  end;
end;

//procedure TfrmPublish.UpdateButtonStates;
//begin
//  btnBorrarPerfil.Enabled := (cmbPerfiles.ItemIndex >= 0) and (cmbPerfiles.Items.Count > 0);
//  btnUsarPerfil.Enabled := (cmbPerfiles.ItemIndex >= 0) and
//                           (cmbPerfiles.Text <> sCurrentProfile);
//end;

procedure TfrmPublish.UpdateProfileCombo;
var
  SearchRec: TSearchRec;
  AppPath, AppName: string;
  FileName, ProfileName: string;
  UnderscorePos: Integer;
  CurrentSelection: string;
begin
  // Guardar selección actual
  CurrentSelection := '';
  if cmbPerfiles.ItemIndex >= 0 then
    CurrentSelection := cmbPerfiles.Text;
  // Limpiar combo
  cmbPerfiles.Items.Clear;
  AppPath := ExtractFilePath(ParamStr(0));
  AppName := TPath.GetFileNameWithoutExtension(ExtractFileName(ParamStr(0)));
  // Buscar archivos con el patrón: AppName_*.ini
  if FindFirst(AppPath + AppName + '_*.ini', faAnyFile, SearchRec) = 0 then
  begin
    repeat
      FileName := TPath.GetFileNameWithoutExtension(SearchRec.Name);
      // Extraer el nombre del perfil después del guión bajo
      UnderscorePos := Pos('_', FileName);
      if UnderscorePos > 0 then
      begin
        ProfileName := Copy(FileName, UnderscorePos + 1, Length(FileName));
        if ProfileName <> '' then
          cmbPerfiles.Items.Add(ProfileName);
      end;
    until FindNext(SearchRec) <> 0;
    FindClose(SearchRec);
  end;
  // Ordenar alfabéticamente
  cmbPerfiles.Sorted := True;
  // Restaurar selección si existe
  if (CurrentSelection <> '') and (cmbPerfiles.Items.IndexOf(CurrentSelection) >= 0) then
    cmbPerfiles.ItemIndex := cmbPerfiles.Items.IndexOf(CurrentSelection)
  else if cmbPerfiles.Items.Count > 0 then
    cmbPerfiles.ItemIndex := 0;
  // Actualizar estado de botones
//  UpdateButtonStates;
end;

procedure TfrmPublish.btnNuevoPerfilClick(Sender: TObject);
var
  NombrePerfil: string;
  AppName, CurrentFile, NewFile: string;
begin
  NombrePerfil := InputBox('Nuevo Perfil', 'Ingrese el nombre del nuevo perfil:', '');
  if Trim(NombrePerfil) = '' then
    Exit;
  // Validar caracteres
  if (Pos('\', NombrePerfil) > 0) or (Pos('/', NombrePerfil) > 0) or
     (Pos(':', NombrePerfil) > 0) or (Pos('*', NombrePerfil) > 0) or
     (Pos('?', NombrePerfil) > 0) or (Pos('"', NombrePerfil) > 0) or
     (Pos('<', NombrePerfil) > 0) or (Pos('>', NombrePerfil) > 0) or
     (Pos('|', NombrePerfil) > 0) or (Pos('_', NombrePerfil) > 0) then
  begin
    ShowMessage('El nombre del perfil contiene caracteres no válidos');
    Exit;
  end;
  AppName := TPath.GetFileNameWithoutExtension(ExtractFileName(ParamStr(0)));
  NewFile := ExtractFilePath(ParamStr(0)) + AppName + '_' + NombrePerfil + '.ini';
  // Verificar si ya existe
  if FileExists(NewFile) then
  begin
    ShowMessage('Ya existe un perfil con ese nombre');
    Exit;
  end;
  // Guardar configuración actual primero
  GrabarIni;
  // Copiar desde el perfil actual
  if sCurrentProfile <> '' then
    CurrentFile := ExtractFilePath(ParamStr(0)) + AppName + '_' + sCurrentProfile + '.ini'
  else
    CurrentFile := ExtractFilePath(ParamStr(0)) + AppName + '.ini';
  // Copiar archivo
  if FileExists(CurrentFile) then
  begin
    if CopyFile(PChar(CurrentFile), PChar(NewFile), False) then
    begin
      UpdateProfileCombo;
      cmbPerfiles.ItemIndex := cmbPerfiles.Items.IndexOf(NombrePerfil);
      ShowMessage('Perfil "' + NombrePerfil + '" creado correctamente');
      LogMessage('Nuevo perfil creado: ' + NombrePerfil);
    end
    else
      ShowMessage('Error al crear el perfil');
  end
  else
  begin
    ShowMessage('No se pudo encontrar el perfil actual para copiar');
  end;
end;

function TfrmPublish.ReadCompleteDelphiPaths(const DelphiVersion: string): TDelphiPaths;
var
  Registry: TRegistry;
  RegistryKey: string;
  SearchPath, BrowsingPath, DebugPath: string;
  PackageDCPOutput, PackageBPLOutput: string;
  Temp, PlatformPath: string;
begin
  // Inicializar resultado
  Result.UnitPaths := '';
  Result.ResourcePaths := '';
  Result.IncludePaths := '';
  Result.ObjectPaths := '';
  Registry := TRegistry.Create;
  try
    if (edtPlatForm.Text = 'Win64') then
      PlatformPath := 'Win64'
    else
      PlatformPath := 'Win32';
    Registry.RootKey := HKEY_CURRENT_USER;
    RegistryKey := Format('SOFTWARE\Embarcadero\BDS\%s\Library\%s',
                                                 [DelphiVersion, PlatformPath]);
    Result.UnitPaths := Format('"%s\lib\%s\%s"',
                              [edtBasePath.Text, PlatformPath, edtConfig.Text]);
    Result.UnitPaths := Result.UnitPaths + Format(';"%s\Imports"',
                                                            [edtBasePath.Text]);
    Result.UnitPaths := Result.UnitPaths + Format(';"%s\Dcp"',
                                                          [edtCommonPath.Text]);
    Result.UnitPaths := Result.UnitPaths + Format(';"%s\include"',
                                                            [edtBasePath.Text]);
    if Registry.OpenKeyReadOnly(RegistryKey) then
    begin
      // UNIT PATHS (-U) - Combinación de Search Path + Browsing Path
      if Registry.ValueExists('Search Path') then
      begin
        SearchPath := Registry.ReadString('Search Path');
        Result.UnitPaths := SearchPath;
        LogMessage('Registry Search Path: ' + SearchPath);
      end;
      if Registry.ValueExists('Browsing Path') then
      begin
        BrowsingPath := Registry.ReadString('Browsing Path');
        LogMessage('Registry Browsing Path: ' + BrowsingPath);
        if (BrowsingPath <> '') and (Pos(BrowsingPath, Result.UnitPaths) = 0) then
        begin
          if Result.UnitPaths <> '' then
            Result.UnitPaths := Result.UnitPaths + ';';
          Result.UnitPaths := Result.UnitPaths + BrowsingPath;
        end;
      end;
      // DEBUG DCU PATH - También se agrega a Unit Paths en modo release
      if Registry.ValueExists('Debug DCU Path') then
      begin
        DebugPath := Registry.ReadString('Debug DCU Path');
        LogMessage('Registry Debug DCU Path: ' + DebugPath);
      end;

      // PACKAGE PATHS - Para encontrar archivos .res y .dcp
      if Registry.ValueExists('Package DCP Output') then
      begin
        PackageDCPOutput := Registry.ReadString('Package DCP Output');
        LogMessage('Registry Package DCP Output: ' + PackageDCPOutput);
        // Los DCP van a Unit Paths
        if PackageDCPOutput <> '' then
        begin
          if Result.UnitPaths <> '' then Result.UnitPaths := Result.UnitPaths + ';';
          Result.UnitPaths := Result.UnitPaths + PackageDCPOutput;
        end;
      end;

      if Registry.ValueExists('Package BPL Output') then
      begin
        PackageBPLOutput := Registry.ReadString('Package BPL Output');
        LogMessage('Registry Package BPL Output: ' + PackageBPLOutput);
      end;

      Registry.CloseKey;
    end;

    // LEER ENVIRONMENT VARIABLES DEL REGISTRO (importante para $(BDS), $(BDSLIB), etc.)
    RegistryKey := Format('SOFTWARE\Embarcadero\BDS\%s\Environment Variables', [DelphiVersion]);
    if Registry.OpenKeyReadOnly(RegistryKey) then
    begin
      var EnvVars := TStringList.Create;
      try
        Registry.GetValueNames(EnvVars);
        LogMessage('Variables de entorno encontradas: ' + IntToStr(EnvVars.Count));
        for var VarName in EnvVars do
        begin
          Temp := Registry.ReadString(VarName);
          LogMessage(VarName + '=' + Temp);
          // Expandir variables en los paths ya obtenidos
          Result.UnitPaths := StringReplace(Result.UnitPaths, '$(' + VarName + ')', Temp, [rfReplaceAll, rfIgnoreCase]);
        end;
      finally
        EnvVars.Free;
      end;
      Registry.CloseKey;
    end;

  except
    on E: Exception do
      LogMessage('Error leyendo registro completo: ' + E.Message);
  end;
  Registry.Free;
  // DETERMINAR RESOURCE PATHS dinámicamente
  // Los recursos suelen estar en las mismas carpetas que las unidades,
  // pero también en subcarpetas específicas como /Resources
  Result.ResourcePaths := Result.UnitPaths; // Usar los mismos paths como base
  // Agregar variaciones específicas para recursos
  var UnitPathArray := Result.UnitPaths.Split([';']);
  for var UPath in UnitPathArray do
  begin
    var CleanPath := StringReplace(UPath, '"', '', [rfReplaceAll]);
    if CleanPath <> '' then
    begin
      // Verificar si existe subcarpeta Resources
      var ResourcesSubDir := IncludeTrailingPathDelimiter(CleanPath) + 'Resources';
      if DirectoryExists(ResourcesSubDir) then
      begin
        Result.ResourcePaths := Result.ResourcePaths + ';"' + ResourcesSubDir + '"';
        LogMessage('Agregado path de recursos: ' + ResourcesSubDir);
      end;
      // Verificar si existe subcarpeta Res
      var ResSubDir := IncludeTrailingPathDelimiter(CleanPath) + 'Res';
      if DirectoryExists(ResSubDir) then
      begin
        Result.ResourcePaths := Result.ResourcePaths + ';"' + ResSubDir + '"';
        LogMessage('Agregado path de recursos: ' + ResSubDir);
      end;
    end;
  end;
  // INCLUDE PATHS - Generalmente subcarpetas de los unit paths
  Result.IncludePaths := Result.UnitPaths; // Base
  for var UPath in UnitPathArray do
  begin
    var CleanPath := StringReplace(UPath, '"', '', [rfReplaceAll]);
    if CleanPath <> '' then
    begin
      var IncludeSubDir :=
                       IncludeTrailingPathDelimiter(CleanPath) + 'Include';
      if DirectoryExists(IncludeSubDir) then
      begin
        Result.IncludePaths := Result.IncludePaths + ';"' + IncludeSubDir + '"';
      end;
    end;
  end;
  LogMessage('=== PATHS FINALES ===');
  LogMessage('Unit Paths: ' + Result.UnitPaths);
  LogMessage('Resource Paths: ' + Result.ResourcePaths);
  LogMessage('Include Paths: ' + Result.IncludePaths);
end;

function TfrmPublish.CleanDuplicatePaths(const PathsString: string): string;
var
  TempPaths: TArray<string>;
  CleanedPaths: TStringList;
  i: Integer;
  CurrentPath: string;
begin
  CleanedPaths := TStringList.Create;
  try
    TempPaths := PathsString.Split([';']);
    for i := 0 to High(TempPaths) do
    begin
      CurrentPath := Trim(TempPaths[i]);
      if (CurrentPath <> '') and (CleanedPaths.IndexOf(CurrentPath) = -1)
                 and (CleanedPaths.IndexOf('"' + CurrentPath + '"') = -1)   then
      begin
        var PathToCheck := StringReplace(CurrentPath, '"', '', [rfReplaceAll]);
        if DirectoryExists(PathToCheck) or ContainsText(PathToCheck, '$') then
        begin
          if (Pos(' ', PAthtoCheck) > 0) then
            PAthToCheck := '"' + PathToCheck + '"';
          if Length(PathToCheck) > 259 then
            LogMessage('Ruta muy larga'+'('+ IntToStr(Length(PathToCheck))+')'+': '+ PathToCheck);
          CleanedPaths.Add(PathToCheck);
        end;
      end;
    end;
    Result := String.Join(';', CleanedPaths.ToStringArray);
    LogMessage('Total paths procesados: ' + IntToStr(CleanedPaths.Count));
  finally
    CleanedPaths.Free;
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
  InitProfile;
  leerIni;
  InitControls;
end;

procedure TfrmPublish.FormDestroy(Sender: TObject);
begin
  if F7zDLLHandle <> 0 then
    FreeLibrary(F7zDLLHandle);
end;

//https://jachguate.wordpress.com/2012/12/10/7zip-y-delphi/

function TfrmPublish.FormatFileSize(Size: Int64): string;
begin
  if Size < 1024 then
    Result := IntToStr(Size) + ' B'
  else if Size < 1024 * 1024 then
    Result := FormatFloat('#,##0.0', Size / 1024) + ' KB'
  else if Size < 1024 * 1024 * 1024 then
    Result := FormatFloat('#,##0.0', Size / (1024 * 1024)) + ' MB'
  else
    Result := FormatFloat('#,##0.0', Size / (1024 * 1024 * 1024)) + ' GB';
end;

procedure TfrmPublish.ShowArchiveStatistics(Arch: I7zInArchive);
var
  I: Integer;
  TotalFiles, TotalFolders: Integer;
  TotalOriginalSize, TotalCompressedSize: Int64;
  PropValue: OleVariant;
  FileSize, CompressedSize: Int64;
  CompressionRatio: Double;
begin
  TotalFiles := 0;
  TotalFolders := 0;
  TotalOriginalSize := 0;
  TotalCompressedSize := 0;

  // Contar archivos y calcular tamaños totales
  for I := 0 to Arch.NumberOfItems - 1 do
  begin
    if Arch.ItemIsFolder[I] then
      Inc(TotalFolders)
    else
    begin
      Inc(TotalFiles);
      FileSize := Arch.ItemSize[I];
      TotalOriginalSize := TotalOriginalSize + FileSize;

      try
        Arch.InArchive.GetProperty(I, kpidPackedSize, PropValue);
        if not (VarIsNull(PropValue) or VarIsEmpty(PropValue)) then
        begin
          CompressedSize := PropValue;
          TotalCompressedSize := TotalCompressedSize + CompressedSize;
        end;
      except
        // Ignorar errores
      end;
    end;
  end;

  // Mostrar estadísticas
  LogMessage('');
  LogMessage('ESTADÍSTICAS DEL ARCHIVO:');
  LogMessage(StringOfChar('=', 40));
  LogMessage('Archivos: ' + IntToStr(TotalFiles));
  LogMessage('Carpetas: ' + IntToStr(TotalFolders));
  LogMessage('Tamaño original total: ' + FormatFileSize(TotalOriginalSize));
  LogMessage('Tamaño comprimido total: ' + FormatFileSize(TotalCompressedSize));

  if TotalOriginalSize > 0 then
  begin
    CompressionRatio := ((TotalOriginalSize - TotalCompressedSize) / TotalOriginalSize) * 100;
    LogMessage('Ratio de compresión: ' + FormatFloat('0.0', CompressionRatio) + '%');
    LogMessage('Factor de compresión: ' + FormatFloat('0.0', TotalOriginalSize / TotalCompressedSize) + ':1');
  end;
end;

procedure TfrmPublish.btnCheckClick(Sender: TObject);
var
  Arch: I7zInArchive;
  I, J: Integer;
  ItemPath: string;
  ItemSize, PackedSize: Int64;
  IsFolder: Boolean;
  SizeStr, PackedStr, TypeStr, DateStr: string;
  Indent: string;
  FolderLevel: Integer;
  PropValue: OleVariant;
  TotalFiles, TotalFolders: Integer;
  TotalOriginalSize, TotalCompressedSize: Int64;
  FileItems: array of TFileItem;
  FileItem: TFileItem;

  function GetCompressionRatio(Original, Compressed: Int64): string;
  var
    Ratio: Double;
  begin
    if (Original <= 0) or (Compressed <= 0) then
      Result := 'N/A'
    else
    begin
      Ratio := ((Original - Compressed) / Original) * 100;
      if (Ratio < -100) or (Ratio > 100) then
        Result := 'N/A'
      else
        Result := FormatFloat('0.0', Ratio) + '%';
    end;
  end;

  function CalculateIndentLevel(const Path: string): Integer;
  var
    I: Integer;
  begin
    Result := 0;
    for I := 1 to Length(Path) do
      if (Path[I] = '/') or (Path[I] = '\') then
        Inc(Result);
  end;

  function GetFileModificationDate(Archive: I7zInArchive; Index: Integer): string;
  var
    PropVar: OleVariant;
    FileTime: TFileTime;
    SystemTime: TSystemTime;
    DateTime: TDateTime;
    VarData: TVarData;
  begin
    Result := 'N/A';
    try
      Archive.InArchive.GetProperty(Index, kpidLastWriteTime, PropVar);

      if not (VarIsNull(PropVar) or VarIsEmpty(PropVar)) then
      begin
        VarData := TVarData(PropVar);

        // El tipo 64 (VT_FILETIME) necesita manejo especial
        if VarData.VType = 64 then
        begin
          // Para VT_FILETIME, los datos están en VarData.VInt64
          FileTime.dwLowDateTime := LongWord(VarData.VInt64 and $FFFFFFFF);
          FileTime.dwHighDateTime := LongWord((VarData.VInt64 shr 32) and $FFFFFFFF);

          if FileTimeToLocalFileTime(FileTime, FileTime) then
          begin
            if FileTimeToSystemTime(FileTime, SystemTime) then
            begin
              DateTime := SystemTimeToDateTime(SystemTime);
              Result := FormatDateTime('dd/mm/yyyy hh:nn', DateTime);
            end;
          end;
        end
        else
        begin
          case VarData.VType of
            varDate:
            begin
              DateTime := PropVar;
              Result := FormatDateTime('dd/mm/yyyy hh:nn', DateTime);
            end;
            varInt64, varUInt64:
            begin
              FileTime.dwLowDateTime := LongWord(VarData.VInt64 and $FFFFFFFF);
              FileTime.dwHighDateTime := LongWord((VarData.VInt64 shr 32) and $FFFFFFFF);

              if FileTimeToLocalFileTime(FileTime, FileTime) then
              begin
                if FileTimeToSystemTime(FileTime, SystemTime) then
                begin
                  DateTime := SystemTimeToDateTime(SystemTime);
                  Result := FormatDateTime('dd/mm/yyyy hh:nn', DateTime);
                end;
              end;
            end;
          end;
        end;
      end;
    except
      Result := 'N/A';
    end;
  end;

  function GetPackedSizeFromArchive(Archive: I7zInArchive; Index: Integer): Int64;
  var
    PropVar: OleVariant;
  begin
    Result := 0;
    try
      Archive.InArchive.GetProperty(Index, kpidPackedSize, PropVar);

      if not (VarIsNull(PropVar) or VarIsEmpty(PropVar)) then
      begin
        case VarType(PropVar) of
          varByte, varSmallint, varInteger, varSingle, varDouble, varCurrency, varDate:
            Result := PropVar;
          varInt64:
            Result := PropVar;
          varUnknown, varDispatch:
            Result := 0;
        else
          try
            Result := PropVar;
          except
            Result := 0;
          end;
        end;

        if (Result < 0) or (Result > MaxInt) then
          Result := 0;
      end;
    except
      Result := 0;
    end;
  end;

  // Función para ordenar los elementos alfabéticamente
  procedure SortFileItems(var Items: array of TFileItem; Count: Integer);
  var
    I, J: Integer;
    Temp: TFileItem;
  begin
    // Algoritmo de ordenamiento burbuja simple
    for I := 0 to Count - 2 do
    begin
      for J := 0 to Count - 2 - I do
      begin
        // Primero ordenar por carpetas (carpetas primero), luego alfabéticamente
        if ((Items[J].IsFolder = Items[J + 1].IsFolder) and
           (CompareText(Items[J].Name, Items[J + 1].Name) > 0)) or
           ((not Items[J].IsFolder) and Items[J + 1].IsFolder) then
        begin
          Temp := Items[J];
          Items[J] := Items[J + 1];
          Items[J + 1] := Temp;
        end;
      end;
    end;
  end;

begin
  if not FileExists(edtDestino.Text) then
  begin
    ShowMessage('El fichero comprimido: ' + edtDestino.Text + ' no existe');
  end
  else
  begin
    M1.Lines.Clear;
    LogMessage('CONTENIDO DEL ARCHIVO: ' + ExtractFileName(edtDestino.Text) + ' (ORDENADO ALFABÉTICAMENTE)');
    LogMessage(StringOfChar('=', 110));
    LogMessage('');

    try
      Arch := CreateInArchive(CLSID_CFormat7z);
      Arch.OpenFile(edtDestino.Text);
      Arch.SetPassword(edtPassword.Text);

      // Inicializar contadores para estadísticas
      TotalFiles := 0;
      TotalFolders := 0;
      TotalOriginalSize := 0;
      TotalCompressedSize := 0;

      // Dimensionar el array para todos los elementos
      SetLength(FileItems, Arch.NumberOfItems);

      // PRIMERA PASADA: Recoger toda la información
      for I := 0 to Arch.NumberOfItems - 1 do
      begin
        ItemPath := Arch.ItemPath[I];
        IsFolder := Arch.ItemIsFolder[I];

        // Llenar la estructura de datos
        FileItems[I].Name := ExtractFileName(ItemPath);
        FileItems[I].FullPath := ItemPath;
        FileItems[I].IsFolder := IsFolder;
        FileItems[I].ModificationDate := GetFileModificationDate(Arch, I);
        FileItems[I].IndentLevel := CalculateIndentLevel(ItemPath);

        if not IsFolder then
        begin
          FileItems[I].Size := Arch.ItemSize[I];
          FileItems[I].PackedSize := GetPackedSizeFromArchive(Arch, I);
          FileItems[I].Extension := UpperCase(ExtractFileExt(ItemPath));

          // Actualizar contadores
          Inc(TotalFiles);
          TotalOriginalSize := TotalOriginalSize + FileItems[I].Size;
          if FileItems[I].PackedSize > 0 then
            TotalCompressedSize := TotalCompressedSize + FileItems[I].PackedSize;
        end
        else
        begin
          FileItems[I].Size := 0;
          FileItems[I].PackedSize := 0;
          Inc(TotalFolders);
        end;
      end;

      // ORDENAR los elementos alfabéticamente
      SortFileItems(FileItems, Arch.NumberOfItems);

      // MOSTRAR el listado ordenado
      LogMessage('Número total de elementos: ' + IntToStr(Arch.NumberOfItems));
      LogMessage('');
      LogMessage(Format('%-40s %12s %16s',
        ['NOMBRE', 'TAMAÑO','MODIFICADO']));
      LogMessage(StringOfChar('-', 80));

      for I := 0 to Arch.NumberOfItems - 1 do
      begin
        FileItem := FileItems[I];

        // Calcular indentación
        Indent := StringOfChar(' ', FileItem.IndentLevel * 2);

        // Formatear tamaño
        if FileItem.IsFolder then
          SizeStr := '<DIR>'
        else
          SizeStr := FormatFileSize(FileItem.Size);

        // Mostrar información del elemento
        if FileItem.IsFolder then
        begin
          LogMessage(Format('%s[%s]%s %12s %16s',
            [Indent, Copy(FileItem.Name, 1, 35-Length(Indent)),
             StringOfChar(' ', 35-Length(Indent)-Length(FileItem.Name)),
             SizeStr, FileItem.ModificationDate]));
        end
        else
        begin
          LogMessage(Format('%s%s%s %12s %16s',
            [Indent, Copy(FileItem.Name, 1, 35-Length(Indent)),
             StringOfChar(' ', 35-Length(Indent)-Length(FileItem.Name)),
             SizeStr, FileItem.ModificationDate]));
        end;
      end;

      LogMessage(StringOfChar('-', 80));

      // Mostrar estadísticas finales
      LogMessage('');
      LogMessage('ESTADÍSTICAS DEL ARCHIVO:');
      LogMessage(StringOfChar('=', 40));
      LogMessage('Archivos: ' + IntToStr(TotalFiles));
      LogMessage('Carpetas: ' + IntToStr(TotalFolders));
      LogMessage('Tamaño original total: ' + FormatFileSize(TotalOriginalSize));

      if TotalCompressedSize > 0 then
      begin
        LogMessage('Tamaño comprimido total: ' + FormatFileSize(TotalCompressedSize));
        if TotalOriginalSize > 0 then
        begin
          var OverallRatio := ((TotalOriginalSize - TotalCompressedSize) / TotalOriginalSize) * 100;
          LogMessage('Ratio de compresión: ' + FormatFloat('0.0', OverallRatio) + '%');
          if TotalCompressedSize > 0 then
            LogMessage('Factor de compresión: ' + FormatFloat('0.0', TotalOriginalSize / TotalCompressedSize) + ':1');
        end;
      end
      else
      begin
        LogMessage('Tamaño comprimido: No disponible individualmente');
      end;

      LogMessage('');
      LogMessage('Listado completado exitosamente (ordenado alfabéticamente)');

    except
      on E:Exception do
      begin
        LogMessage('Error al listar contenido del archivo: ' + E.Message);
      end;
    end;
  end;
end;

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
        LogMessage('Archivo: ' + Archivo);
      end;
    end;
    // Obtener todas las subcarpetas
    Carpetas := TDirectory.GetDirectories(CarpetaRaiz);
    for Carpeta in Carpetas do
    begin
      LogMessage('Carpeta: ' + Carpeta);
      // Llamada recursiva para procesar subcarpetas
      RecorrerCarpetasConTDirectory(Carpeta);
    end;
  except
    on E: Exception do
      LogMessage('Error: ' + E.Message);
  end;
end;

procedure TfrmPublish.sFtpClientVerifyServer(Sender: TObject; const AHost, AKeyType,
  AFingerPrint, AHostKey: string; var AVerified: Boolean);
begin
  AVerified := True;
  LogMessage('Servidor: ' + AHost + ' - Fingerprint: ' + AFingerPrint);
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
      LogMessage(AFileName);
      M1.Update;
    end;
    LogMessage(StringOfChar('=', 30));
    LogMessage('Finalizado');
    Arch.SaveToFile(edtDestino.Text);
//  end;
end;

procedure TfrmPublish.btnComprimirEClick(Sender: TObject);
var
  ExeFolder, ProjectName, ExeFileName, CompressedFileName: string;
  ExeSourcePath, ExeDestPath: string;
  Arch: I7zOutArchive;
  i: Integer;
  FilesToCompress: TStringList;
  DestFile, RelativePath: string;
  Version: string;
begin
  // Validar carpeta destino
  if not DirectoryExists(edtExeDestPath.Text) then
  begin
    LogMessage('ERROR: La carpeta destino no existe: ' + edtExeDestPath.Text);
    Exit;
  end;
  try
    LogMessage('=== INICIANDO COMPRESIÓN DE EJECUTABLE ===');
    // Obtener nombre del proyecto sin extensión
    ProjectName := TPath.GetFileNameWithoutExtension(edtProjectPath.Text);
    // Generar marca de tiempo
    Version := edtVersion.Text;
    // Construir ruta del ejecutable compilado
    if ContainsText(edtOutputExe.Text, '.\') then
      ExeSourcePath := ExtractFilePath(edtProjectPath.Text) + edtOutputExe.Text + '\' + ProjectName + '.exe'
    else
      ExeSourcePath := edtOutputExe.Text + '\' + ProjectName + '.exe';
    // Verificar que existe el ejecutable
    if not FileExists(ExeSourcePath) then
    begin
      LogMessage('ERROR: No se encontró el ejecutable: ' + ExeSourcePath);
      LogMessage('Compile primero el proyecto');
      Exit;
    end;
    LogMessage('Ejecutable encontrado: ' + ExeSourcePath);
    // PASO 1: Copiar ejecutable a carpeta destino
    ExeDestPath := IncludeTrailingPathDelimiter(edtExeDestPath.Text) +
                                                           ProjectName + '.exe';
    LogMessage('Copiando ejecutable a: ' + ExeDestPath);
    if not CopyFile(PChar(ExeSourcePath), PChar(ExeDestPath), False) then
    begin
      LogMessage('ERROR: No se pudo copiar el ejecutable, ¿faltan permisos?');
      Exit;
    end;
    LogMessage('✓ Ejecutable copiado correctamente');
    // PASO 2: Copiar archivos adicionales
    LogMessage('Copiando archivos adicionales...');
    for i := 0 to lstFilesExe.Items.Count - 1 do
    begin
      var SourceFile := lstFilesExe.Items[i];
      if FileExists(SourceFile) then
      begin
        DestFile := IncludeTrailingPathDelimiter(edtExeDestPath.Text) +
                                                 ExtractFileName(SourceFile);
        if not SameText(SourceFile, DestFile) then
          if CopyFile(PChar(SourceFile), PChar(DestFile), False) then
            LogMessage('✓ Copiado: ' + ExtractFileName(SourceFile))
          else
            LogMessage('✗ Error copiando: ' + ExtractFileName(SourceFile));
      end
      else
        LogMessage('✗ No existe: ' + SourceFile);
    end;
    // PASO 3: Crear lista de archivos a comprimir
    FilesToCompress := TStringList.Create;
    try
      // Agregar ejecutable
      FilesToCompress.Add(ExeDestPath);
      // Agregar archivos adicionales que se copiaron exitosamente
      for i := 0 to lstFilesExe.Items.Count - 1 do
      begin
        DestFile := IncludeTrailingPathDelimiter(edtExeDestPath.Text) +
                   ExtractFileName(lstFilesExe.Items[i]);
        if FileExists(DestFile) then
          FilesToCompress.Add(DestFile);
      end;
      LogMessage('Total archivos a comprimir: ' +
                                               IntToStr(FilesToCompress.Count));
      // PASO 4: Crear archivo comprimido
      CompressedFileName := IncludeTrailingPathDelimiter(edtExeDestPath.Text) +
                ProjectName + '_' + edtVersion.Text + '.7z';
      LogMessage('Creando archivo comprimido: ' +
                                           ExtractFileName(CompressedFileName));
      Arch := CreateOutArchive(CLSID_CFormat7z);
      SetCompressionLevel(Arch, 9);
      SevenZipSetCompressionMethod(Arch, m7LZMA);
      // Usar la misma contraseña que en la pestaña de archivos fuente
//      if edtPassword.Text <> '' then
//      begin
//        Arch.SetPassword(edtPassword.Text);
//        LogMessage('Archivo protegido con contraseña');
//      end;
      // Agregar archivos al comprimido
      var BaseDir := IncludeTrailingPathDelimiter(edtExeDestPath.Text);
      var BaseDirLen := Length(BaseDir);
      for var FileName in FilesToCompress do
      begin
        // Crear ruta relativa (solo nombre del archivo)
        RelativePath := ExtractFileName(FileName);
        Arch.AddFile(FileName, RelativePath);
        LogMessage('Agregado al archivo: ' + RelativePath);
      end;
      // Guardar archivo comprimido
      Arch.SaveToFile(CompressedFileName);
      LogMessage('✓ Archivo comprimido creado: ' +
                                           ExtractFileName(CompressedFileName));
      // PASO 5: Enviar a VirusTotal si está habilitado
      if chkSendToVirusTotal.Checked and (Trim(edtVirusTotalAPIKey.Text) <> '') then
      begin
        LogMessage('Enviando a VirusTotal...');
        if SendToVirusTotal(ExeDestPath) then
          LogMessage('✓ Archivo enviado a VirusTotal correctamente')
        else
          LogMessage('✗ Error al enviar a VirusTotal');
      end;
      LogMessage('');
      LogMessage('=== PROCESO COMPLETADO EXITOSAMENTE ===');
      LogMessage('Ejecutable: ' + ProjectName + '.exe');
      LogMessage('Archivos adicionales: ' + IntToStr(lstFilesExe.Items.Count));
      LogMessage('Archivo comprimido: ' + ExtractFileName(CompressedFileName));
      LogMessage('Ubicación: ' + edtExeDestPath.Text);
    finally
      FilesToCompress.Free;
    end;
  except
    on E: Exception do
    begin
      LogMessage('ERROR CRÍTICO: ' + E.Message);
      ShowMessage('Error durante la compresión: ' + E.Message);
    end;
  end;
  btnComprimirExe.Enabled := True;
end;

procedure TfrmPublish.btnOrigenClick(Sender: TObject);
begin
  flpndlg1.DefaultFolder := edtOrigen.Text;
  if flpndlg1.Execute then
    edtOrigen.Text := flpndlg1.FileName;
end;

procedure TfrmPublish.btnAddExeClick(Sender: TObject);
begin
  if (edtAddExe.Text <> '') then
    if lstFilesExe.Items.IndexOf(edtAddExe.Text) = -1 then
    begin
      lstFilesExe.Items.Add(edtAddExe.Text);
      edtAddExe.Clear;
      LogMessage('Archivo agregado: ' + ExtractFileName(edtAddExe.Text));
    end
    else
    begin
      ShowMessage('El archivo ya está en la lista');
      edtAddExe.Clear;
    end;
end;

procedure TfrmPublish.btnAddExtClick(Sender: TObject);
begin
  if (edtExtension.Text <> '')  then
    lstExtensiones.Items.Add(edtExtension.Text);
end;

procedure TfrmPublish.btnAnalizarClick(Sender: TObject);
begin
  LogMessage('Resultado inicial...');

  var ResultSummary := GetAnalysisResult(edtAnalisisId.Text);
  if ResultSummary <> '' then
    LogMessage('Resultado: ' + ResultSummary);
end;

procedure TfrmPublish.btnDeleteExeClick(Sender: TObject);
begin
  if lstFilesExe.ItemIndex >= 0 then
    lstFilesExe.Items.Delete(lstFilesExe.ItemIndex);
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
      LogMessage('Conectado al servidor SFTP');
      // Cambiar al directorio remoto donde quieres subir el archivo (opcional)
      if ((edtCarpetaRemota.Text <> '') or (edtCarpetaRemota.Text <> '/')) then
        SftpClient.ChangeCurrentDir(edtCarpetaRemota.Text);
      // Enviar el archivo
      sNameFile := ExtractFileName(edtDestino.Text);
      SftpClient.PutFile(edtDestino.Text, sNameFile);
      LogMessage('Archivo '+sNameFile+' enviado correctamente');
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

procedure TfrmPublish.btnEnviarFTPExeClick(Sender: TObject);
var
  sNameFile, CompressedFileName, ProjectName:string;
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
      LogMessage('Conectado al servidor SFTP');
      // Cambiar al directorio remoto donde quieres subir el archivo (opcional)
      if ((edtCarpetaRemota.Text <> '') or (edtCarpetaRemota.Text <> '/')) then
        SftpClient.ChangeCurrentDir(edtCarpetaRemota.Text);
      // Enviar el archivo
      sNameFile := ExtractFileName(edtDestino.Text);
      SftpClient.PutFile(edtDestino.Text, sNameFile);
      LogMessage('Archivo '+sNameFile+' enviado correctamente');
      ProjectName := TPath.GetFileNameWithoutExtension((edtProjectPath.Text));
      CompressedFileName := IncludeTrailingPathDelimiter(edtExeDestPath.Text) +
                ProjectName + '_' + edtVersion.Text + '.7z';
      SftpClient.PutFile(CompressedFileName,
                                          ExtractFileName(CompressedFileName));
      LogMessage('Archivo '+CompressedFileName+' enviado correctamente');
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

procedure TfrmPublish.btnSelectFileAddClick(Sender: TObject);
begin
  if dlgOpenPoject.Execute() then
    edtAddExe.Text := dlgOpenPoject.FileName;
  btnAddExeClick(Sender);
end;

procedure TfrmPublish.btnSelectFolderCopyExeClick(Sender: TObject);
begin
  dlgSelectFolder.DefaultFolder := edtExeDestPath.Text;
  if dlgSelectFolder.Execute then
    edtExeDestPath.Text := dlgSelectFolder.FileName;
end;

procedure TfrmPublish.btnSelectLibVarGlobClick(Sender: TObject);
begin
  dlgOpenPoject.Filter := 'Ficheros pascal .pas (*.pas)|*.pas';
  if dlgOpenPoject.Execute() then
    edtLibVarGlobPath.Text := dlgOpenPoject.FileName;
end;

procedure TfrmPublish.btnSelectProjectClick(Sender: TObject);
begin
  dlgOpenPoject.Filter := 'Proyecto Delphi dpr (*.dpr)|*.dpr';
  if dlgOpenPoject.Execute() then
    edtProjectPath.Text := dlgOpenPoject.FileName;
end;

procedure TfrmPublish.btnUsarPerfilClick(Sender: TObject);
var
  ProfileName: string;
begin
  if cmbPerfiles.ItemIndex < 0 then
    Exit;
  ProfileName := cmbPerfiles.Text;
  // Guardar configuración actual antes de cambiar
    GrabarIni;
  // Cambiar al nuevo perfil
  sCurrentProfile := ProfileName;
  LeerIni;
  InitControls;
  lblPerfilActual.Caption := 'Perfil actual: ' + ProfileName;
  LogMessage('Perfil cambiado a: ' + ProfileName);
  // Guardar último perfil usado
  var AppName := TPath.GetFileNameWithoutExtension(ExtractFileName(ParamStr(0)));
  with TIniFile.Create(ExtractFilePath(ParamStr(0)) + AppName + '.ini') do
  try
    WriteString('General', 'LastProfile', ProfileName);
  finally
    Free;
  end;
//  UpdateButtonStates;
  //ShowMessage('Perfil cargado: ' + ProfileName);
end;

procedure TfrmPublish.btnVirusTotalClick(Sender: TObject);
begin
  EnviarVirusTotal;
end;

procedure TfrmPublish.MakeDll;
var
  DLLPath: string;
begin
  // Extraer DLL del recurso
  DLLPath := ExtraerDLLDeRecurso;
  F7zDLLHandle := LoadLibrary(PChar(DLLPath));
  if F7zDLLHandle = 0 then
    raise Exception.Create('Error cargando 7z.dll');
end;

function TfrmPublish.ObtenerRutaCompleta(const NombreArchivo: string): string;
var
  CarpetaProyecto: string;
begin
  CarpetaProyecto := edtProjectPath.Text;

  // Si ya es una ruta completa, usarla directamente
  if TPath.IsPathRooted(NombreArchivo) then
  begin
    Result := NombreArchivo;
    Exit;
  end;

  // Si es una ruta relativa, combinar con carpeta del proyecto
  if not TDirectory.Exists(CarpetaProyecto) then
  begin
    Result := NombreArchivo; // Fallback
    Exit;
  end;

  // Intentar en la misma carpeta del proyecto
  Result := TPath.Combine(CarpetaProyecto, ExtractFileName(NombreArchivo));
  if TFile.Exists(Result) then
    Exit;

  // Si no está ahí, buscar en el archivo DPR (método original si lo necesitas)
  // ... resto del código si es necesario

  // Si no se encuentra, devolver ruta combinada
  Result := TPath.Combine(CarpetaProyecto, NombreArchivo);
end;

function TfrmPublish.ExtraerRutaDesdeLineaDPR(const Linea, CarpetaBase: string): string;
var
  PosIn, PosComilla1, PosComilla2: Integer;
  RutaRelativa: string;
begin
  Result := '';
  // Buscar patrón: NombreUnit in 'ruta/archivo.pas'
  PosIn := Pos(' in ', LowerCase(Linea));
  if PosIn > 0 then
  begin
    PosComilla1 := Pos('''', Linea, PosIn);
    if PosComilla1 > 0 then
    begin
      PosComilla2 := Pos('''', Linea, PosComilla1 + 1);
      if PosComilla2 > PosComilla1 then
      begin
        RutaRelativa := Copy(Linea, PosComilla1 + 1, PosComilla2 - PosComilla1 - 1);
        // Convertir ruta relativa a absoluta
        if ExtractFilePath(RutaRelativa) = '' then
          Result := IncludeTrailingPathDelimiter(CarpetaBase) + RutaRelativa
        else
          Result := ExpandFileName(IncludeTrailingPathDelimiter(CarpetaBase) + RutaRelativa);
      end;
    end;
  end;
end;

procedure TfrmPublish.AbrirEnNotepad(const RutaArchivo: string; Linea: Integer);
var
  Parametros: string;
begin
  Parametros := Format('"%s" -n%d', [RutaArchivo, Linea]);
  ShellExecute(Handle, 'open', 'notepad++.exe', PChar(Parametros), nil, SW_SHOWNORMAL);
end;

procedure TfrmPublish.mnuAbrirExploradorClick(Sender: TObject);
var
  NombreArchivo, RutaCompleta: string;
  NumeroLinea: Integer;
begin
  if ParsearLineaError(FTextoLineaSeleccionada, NombreArchivo, NumeroLinea) then
  begin
    RutaCompleta := ObtenerRutaCompleta(NombreArchivo);
    AbrirEnExplorador(RutaCompleta);
  end;
end;

procedure TfrmPublish.AbrirEnExplorador(const Ruta: string);
var
  Parametros: string;
  CarpetaRuta: string;
begin
  if FileExists(Ruta) then
  begin
    // Si el archivo existe, abrir explorador y seleccionar el archivo
    Parametros := '/select,"' + Ruta + '"';
    ShellExecute(Handle, 'open', 'explorer.exe',
                                         PChar(Parametros), nil, SW_SHOWNORMAL);
  end
  else
  begin
    // Si no existe el archivo, intentar abrir la carpeta
    CarpetaRuta := TPath.GetDirectoryName(Ruta);
    if TDirectory.Exists(CarpetaRuta) then
    begin
      Parametros := '"' + CarpetaRuta + '"';
      ShellExecute(Handle, 'open', 'explorer.exe',
                                         PChar(Parametros), nil, SW_SHOWNORMAL);
    end
    else
    begin
      // Si tampoco existe la carpeta, abrir carpeta del proyecto
      if TDirectory.Exists(TPath.GetDirectoryName(edtProjectPath.Text)) then
      begin
        Parametros := '/select,"' +
          TPath.Combine(TPath.GetDirectoryName(edtProjectPath.Text),Ruta) + '"';
        ShellExecute(Handle, 'open', 'explorer.exe',
                     PChar(Parametros), nil, SW_SHOWNORMAL);
      end;
    end;
  end;
end;

function TfrmPublish.DetectarRutaArchivo(const Linea: string; out RutaArchivo: string): Boolean;
var
  i: Integer;
  function ExtraerRutaDesdePos(const Linea: string; PosInicio: Integer): string;
  var
    PosFin: Integer;
    RutaCandidato: string;
    CaracteresInvalidos: TArray<Char>;
    i: Integer;
    EsValido: Boolean;
  begin
    Result := '';
    CaracteresInvalidos := TPath.GetInvalidPathChars();

    // Buscar el final de la ruta
    PosFin := PosInicio;
    while PosFin <= Length(Linea) do
    begin
      // Verificar si el carácter es válido para rutas
      EsValido := True;
      for i := 0 to High(CaracteresInvalidos) do
      begin
        if Linea[PosFin] = CaracteresInvalidos[i] then
        begin
          EsValido := False;
          Break;
        end;
      end;

      // También parar en espacios seguidos de caracteres que indican fin de ruta
      if (Linea[PosFin] = ' ') and (PosFin < Length(Linea)) then
      begin
        if CharInSet(Linea[PosFin + 1], [',', ';', ')', ']', #13, #10]) then
          Break;
      end;

      if not EsValido then
        Break;

      Inc(PosFin);
    end;

    Dec(PosFin); // Ajustar posición

    if PosFin > PosInicio then
    begin
      RutaCandidato := Copy(Linea, PosInicio, PosFin - PosInicio + 1);
      RutaCandidato := Trim(RutaCandidato);

      // Usar TPath para validar
      try
        if TPath.IsPathRooted(RutaCandidato) and
           (TPath.HasExtension(RutaCandidato) or
            TDirectory.Exists(TPath.GetDirectoryName(RutaCandidato))) then
          Result := RutaCandidato;
      except
        // Si TPath lanza excepción, la ruta no es válida
        Result := '';
      end;
    end;
  end;
begin
  Result := False;
  RutaArchivo := '';

  // Buscar patrón C:\ o D:\ etc.
  for i := 1 to Length(Linea) - 2 do
  begin
    if (Linea[i] in ['A'..'Z', 'a'..'z']) and
       (Linea[i + 1] = ':') and
       (Linea[i + 2] = '\') then
    begin
      // Encontró inicio de ruta, extraer la ruta completa
      RutaArchivo := ExtraerRutaDesdePos(Linea, i);
      if (RutaArchivo <> '') and TPath.IsPathRooted(RutaArchivo) then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;
end;

procedure TfrmPublish.mnuIrDireccionClick(Sender: TObject);
begin
  if FURLEncontrada <> '' then
  begin
    try
      ShellExecute(Handle, 'open', PChar(FURLEncontrada), nil, nil, SW_SHOWNORMAL);
    except
      on E: Exception do
        ShowMessage('Error al abrir la URL: ' + E.Message);
    end;
  end;
end;

procedure TfrmPublish.mnuVerEditorClick(Sender: TObject);
var
  NombreArchivo, RutaCompleta: string;
  NumeroLinea: Integer;
begin
  var sCarpeta := TPath.GetDirectoryName(edtProjectPath.Text);
  if ParsearLineaError(FTextoLineaSeleccionada, NombreArchivo, NumeroLinea) then
  begin
    RutaCompleta := sCarpeta +'\'+ NombreArchivo;

    if FileExists(RutaCompleta) then
    begin
      if NumeroLinea > 0 then
        AbrirEnNotepad(RutaCompleta, NumeroLinea)
      else
        AbrirEnNotepad(RutaCompleta, 1); // Si no hay línea, ir al inicio
    end
    else
      LogMessage('Archivo no encontrado: ' + RutaCompleta);
  end;
end;

procedure TfrmPublish.pm1Popup(Sender: TObject);
var
  IndiceLinea: Integer;
  NombreArchivo: string;
  NumeroLinea: Integer;
  URLEncontrada: string;
  PuntoMouse: TPoint;
begin
  GetCursorPos(PuntoMouse);
  PuntoMouse := M1.ScreenToClient(PuntoMouse);
  // Intentar varios métodos hasta que uno funcione
  IndiceLinea := -1;
  // Método 1: Posición del cursor
  try
    IndiceLinea := M1.Perform(EM_LINEFROMCHAR, M1.SelStart, 0);
  except
    IndiceLinea := -1;
  end;
  if (IndiceLinea >= 0) and (IndiceLinea < M1.Lines.Count) then
  begin
    FTextoLineaSeleccionada := M1.Lines[IndiceLinea];

    // Buscar URL en la línea
    URLEncontrada := ExtraerURL(FTextoLineaSeleccionada);
    if URLEncontrada <> '' then
    begin
      FURLEncontrada := URLEncontrada;
      mnuIrDireccion.Enabled := True;
      mnuIrDireccion.Caption := 'Ir a: ' + Copy(URLEncontrada, 1, 40) +
                               IfThen(Length(URLEncontrada) > 40, '...', '');
    end
    else
    begin
      mnuIrDireccion.Enabled := False;
      mnuIrDireccion.Caption := 'Ir a Dirección';
    end;

    // Verificar si la línea contiene ruta de archivo
    if ParsearLineaError(FTextoLineaSeleccionada, NombreArchivo, NumeroLinea) then
    begin
      mnuAbrirExplorador.Enabled := True;
      mnuAbrirExplorador.Caption := 'Abrir en Explorador (' + ExtractFileName(NombreArchivo) + ')';

      // Solo mostrar editor para archivos de código
      var Extension := LowerCase(ExtractFileExt(NombreArchivo));
      if (Extension = '.pas') or (Extension = '.dpr') or (Extension = '.inc') then
      begin
        mnuVerEditor.Enabled := True;
        if NumeroLinea > 0 then
          mnuVerEditor.Caption := 'Ver en Editor (línea ' + IntToStr(NumeroLinea) + ')'
        else
          mnuVerEditor.Caption := 'Ver en Editor';
      end
      else
      begin
        mnuVerEditor.Enabled := False;
        mnuVerEditor.Caption := 'Ver en Editor';
      end;
    end
    else
    begin
      mnuAbrirExplorador.Enabled := False;
      mnuVerEditor.Enabled := False;
      mnuAbrirExplorador.Caption := 'Abrir en Explorador';
      mnuVerEditor.Caption := 'Ver en Editor';
    end;
  end;
end;

function TfrmPublish.leCadINI(clave, cadena: string; defecto: string): string;
var
  sIniFile: string;
  AppName: string;
begin
  AppName := TPath.GetFileNameWithoutExtension(ExtractFileName(ParamStr(0)));
  if sCurrentProfile <> '' then
    sIniFile := ExtractFilePath(ParamStr(0)) +
                                        AppName + '_' + sCurrentProfile + '.ini'
  else
    sIniFile := ExtractFilePath(ParamStr(0)) + AppName + '.ini';
  with TIniFile.Create(sIniFile) do
  try
    Result := ReadString(clave, cadena, defecto);
    if Result = defecto then
      esCadINI(clave, cadena, defecto);
  finally
    Free;
  end;
end;

procedure TfrmPublish.esCadINI(clave, cadena, valor: string);
var
  sIniFile: string;
  AppName: string;
begin
  AppName := TPath.GetFileNameWithoutExtension(ExtractFileName(ParamStr(0)));
  if sCurrentProfile <> '' then
    sIniFile := ExtractFilePath(ParamStr(0)) +
                                        AppName + '_' + sCurrentProfile + '.ini'
  else
    sIniFile := ExtractFilePath(ParamStr(0)) + AppName + '.ini';
  with TIniFile.Create(sIniFile) do
  try
    WriteString(clave, cadena, valor);
  finally
    Free;
  end;
end;

procedure TfrmPublish.leerIni;
var
  extensiones: string;
begin
  sOrigen      := leCadIni('Basic', 'DirSource', 'c:\');
  sDestino     := leCadIni('Basic', 'DirDestination', 'c:\');
  sPassword    := leCadIni('Basic', 'PasswordZip', 'passZip');
  sServer      := leCadIni('sFTP', 'Server', 'server.com');
  sServerPort  := leCadIni('sFTP', 'Port', '21');
  sUserFtp     := leCadIni('sFTP', 'User', 'user_ftp');
  sPassFtp     := leCadIni('sFTP', 'FtpPasswd', 'passftp');
  sFolderDest  := leCadIni('sFTP', 'FolderDest', '/');
  sVersion     := leCadIni('Compilation', 'Version', '109');
  sProjFile    := leCadINI('Compilation', 'ProjectFile', 'c:\MyProject');
  sGlobFile    := leCadINI('Compilation', 'LibGlobFile', '');
  sVirusTotalAPI := leCadINI('Other', 'VirusTotalAPI', '000000000000000000');
   //Leer extensiones del INI (guardadas como string separado por comas)
  extensiones := leCadIni('Files', 'Extensions', '*.exe,*.dll,*.txt');
   //Cargar extensiones en el ListBox
  lstExtensiones.Items.Clear;
  lstExtensiones.Items.CommaText := extensiones;
  sDelphiBasePath := leCadIni('Compiler', 'DelphiBasePath', 'c:\program files (x86)\embarcadero\studio\20.0');
  sDelphiCommonPath := leCadIni('Compiler', 'DelphiCommonPath', 'C:\Users\Public\Documents\Embarcadero\Studio\20.0');
  sCompilerName := leCadIni('Compiler', 'CompilerName', 'dcc32.exe');
  sDelphiVersion := leCadIni('Compiler', 'DelphiVersion', '20.0');
  sPlatform := leCadIni('Compiler', 'Platform', 'Win32');
  sBuildConfiguration := leCadIni('Compiler', 'BuildConfiguration', 'Release');
  sOutputDirectory := leCadIni('Compiler', 'OutputDirectory', '.\Win32\Release');
  sAdditionalParams := leCadIni('Compiler', 'AdditionalParams', '');

    // Agregar estos nuevos parámetros:
  sExeDestPath := leCadIni('PublishExe', 'ExeDestPath', 'c:\publish\');
  sAnalisisID := leCadIni('PublishExe', 'AnalisisID', '');
  // Leer archivos adicionales del exe (similar a extensiones)
  var filesExe := leCadIni('PublishExe', 'FilesExe', '');
  lstFilesExe.Items.Clear;
  if filesExe <> '' then
  begin
    lstFilesExe.Items.StrictDelimiter := True;
    lstFilesExe.Items.Delimiter := ',';
    lstFilesExe.Items.QuoteChar := '"';
    lstFilesExe.Items.CommaText := filesExe;
  end;
end;

procedure TfrmPublish.LogMessage(const Msg: string);
begin
  m1.Lines.Add(Msg);
  Log.LogInfo(Msg);
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
  //compiler
  edtBasePath.Text := sDelphiBasePath;
  edtCommonPath.Text := sDelphiCommonPath;
  edtCompilerName.Text := sCompilerName;
  edtVersionDelphi.Text := sDelphiVersion;
  edtPlatForm.Text := sPlatform;
  edtConfig.Text := sBuildConfiguration;
  edtOutputExe.Text := sOutputDirectory;
  edtParamAdd.Text := sAdditionalParams;
  edtExeDestPath.Text := sExeDestPath;
  edtAnalisisID.Text := sAnalisisID;
end;

procedure TfrmPublish.InitProfile;
var
  ProfileFromParam: string;
  AppName: string;
begin
  // Verificar parámetro de línea de comandos
  ProfileFromParam := '';
  if ParamCount >= 1 then
    ProfileFromParam := ParamStr(1);
  // Cargar perfiles disponibles
  UpdateProfileCombo;
  if ProfileFromParam <> '' then
  begin
    // Usar perfil desde parámetro
    AppName := TPath.GetFileNameWithoutExtension(ExtractFileName(ParamStr(0)));
    if FileExists(ExtractFilePath(ParamStr(0)) + AppName + '_' + ProfileFromParam + '.ini') then
    begin
      sCurrentProfile := ProfileFromParam;
      cmbPerfiles.ItemIndex := cmbPerfiles.Items.IndexOf(ProfileFromParam);
    end
    else
    begin
      sCurrentProfile := '';
      LogMessage('Perfil especificado no encontrado: ' + ProfileFromParam);
    end;
  end
  else
  begin
    // Cargar último perfil usado
    AppName := TPath.GetFileNameWithoutExtension(ExtractFileName(ParamStr(0)));
    with TIniFile.Create(ExtractFilePath(ParamStr(0)) + AppName + '.ini') do
    try
      var LastProfile := ReadString('General', 'LastProfile', '');
      if (LastProfile <> '') and (cmbPerfiles.Items.IndexOf(LastProfile) >= 0) then
      begin
        sCurrentProfile := LastProfile;
        cmbPerfiles.ItemIndex := cmbPerfiles.Items.IndexOf(LastProfile);
      end
      else
        sCurrentProfile := '';
    finally
      Free;
    end;
  end;
  if sCurrentProfile <> '' then
    lblPerfilActual.Caption := 'Perfil actual: ' + sCurrentProfile
  else
    lblPerfilActual.Caption := 'Perfil actual: (Por defecto)';
  //UpdateButtonStates;
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
  sDelphiBasePath := edtBasePath.Text;
  sDelphiCommonPath := edtCommonPath.Text;
  sCompilerName := edtCompilerName.Text;
  sDelphiVersion := edtVersionDelphi.Text;
  sPlatform := edtPlatForm.Text;
  sBuildConfiguration := edtConfig.Text;
  sOutputDirectory := edtOutputExe.Text;
  sAdditionalParams := edtParamAdd.Text;
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
  esCadINI('Other', 'VirusTotalAPI', sVirusTotalAPI);
  //compiler
  esCadIni('Compiler', 'DelphiBasePath',      sDelphiBasePath);
  esCadIni('Compiler', 'DelphiCommonPath',    sDelphiCommonPath);
  esCadIni('Compiler', 'CompilerName',        sCompilerName);
  esCadIni('Compiler', 'DelphiVersion',       sDelphiVersion);
  esCadIni('Compiler', 'Platform',            sPlatform);
  esCadIni('Compiler', 'BuildConfiguration',  sBuildConfiguration);
  esCadIni('Compiler', 'OutputDirectory',     sOutputDirectory);
  esCadIni('Compiler', 'AdditionalParams',    sAdditionalParams);

  sExeDestPath := edtExeDestPath.Text;
  sAnalisisID := edtAnalisisID.Text;
  // Convertir lista de archivos exe a string separado por comas
  var tempList: TStringList;
  var filesExe := '';
  tempList := TStringList.Create;
  try
    tempList.StrictDelimiter := True;
    tempList.Delimiter := ',';
    tempList.QuoteChar := '"';
    tempList.Assign(lstFilesExe.Items);
    filesExe := tempList.CommaText;
  finally
    tempList.Free;
  end;
  // Agregar estas nuevas entradas:
  esCadIni('PublishExe', 'ExeDestPath', sExeDestPath);
  esCadIni('PublishExe', 'AnalisisID', sAnalisisID);
  esCadIni('PublishExe', 'FilesExe', filesExe);
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
  if (not FileExists(FileName)) then
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
        LogMessage('Línea original: ' + Line);
        LogMessage('Nueva línea: ' + FileContent[i]);
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
      LogMessage('ERROR: No se encontró la variable Fversion en el archivo');
    end;
  finally
    FileContent.Free;
  end;
end;

function TfrmPublish.GetDelphiRegistryPaths: string;
var
  DelphiPaths: TDelphiPaths;
  BasePaths: string;
begin
  // Paths base obligatorios de Delphi
  BasePaths := Format('"' + IncludeTrailingBackslash(edtBasePath.Text) +
                              'lib\%s\%s"', [edtPlatForm.Text, edtConfig.Text]);
  BasePaths := BasePaths + ';"' + IncludeTrailingBackslash(edtBasePath.Text) +
                                                                     'Imports"';
  BasePaths := BasePaths + ';"'+IncludeTrailingBackslash(edtCommonPath.Text) +
                                                                         'Dcp"';
  BasePaths := BasePaths + ';"' + IncludeTrailingBackslash(edtBasePath.Text) +
                                                                     'include"';
  // Leer configuración completa del registro
  DelphiPaths := ReadCompleteDelphiPaths(edtVersionDelphi.Text);
  if DelphiPaths.UnitPaths <> '' then
  begin
    LogMessage('Usando paths del registro de Delphi');
    Result := BasePaths + ';' + DelphiPaths.UnitPaths;
  end
  else
  begin
    LogMessage('Usando solo paths base');
    Result := BasePaths;
  end;
  Result := CleanDuplicatePaths(Result);
  // Guardar los paths organizados para usar en la compilación
  FDelphiPaths := DelphiPaths; // Variable de clase para usar después
end;

function TfrmPublish.CompileProject: Boolean;
var
  Command: WideString;
  ProjectDir: string;
  ProjectName: string;
  DelphiBin, PathDcu: string;
  ResponseFile: string;
  ResponseFileContent: TStringList;
  AllPaths: string;
begin
  Result := False;
  ProjectDir := ExtractFilePath(edtProjectPath.Text);
  ProjectName := ExtractFileName(edtProjectPath.Text);
  DelphiBin := IncludeTrailingPathDelimiter(edtBasePath.Text) + 'bin';
  LogMessage('=== CONFIGURACIÓN DE COMPILACIÓN ===');
  LogMessage('Versión Delphi: 10.3');
  LogMessage('Compilador: ' + DelphiBin + '\' + edtCompilerName.Text);
  LogMessage('Directorio de trabajo: ' + ProjectDir);
  LogMessage('Archivo proyecto: ' + ProjectName);
  // Crear archivo de respuesta temporal
  ResponseFile := ProjectDir + 'compile_temp.rsp';
  ResponseFileContent := TStringList.Create;
  try
    // Obtener paths organizados del registro (esto popula FDelphiPaths)
    AllPaths := GetDelphiRegistryPaths;
    // Construir contenido del archivo de respuesta con parámetros apropiados
    //ResponseFileContent.Add('-$D0');
    ResponseFileContent.Add('-$L-');
    ResponseFileContent.Add('-$Y-');
    ResponseFileContent.Add('--no-config');
    ResponseFileContent.Add('-B');
    ResponseFileContent.Add('-Q');
    ResponseFileContent.Add('-TX.exe');
    ResponseFileContent.Add('-AGenerics.Collections=' +
                            'System.Generics.Collections;'+
                            'Generics.Defaults=System.Generics.Defaults;' +
                            'WinTypes=Winapi.Windows;WinProcs=Winapi.Windows;' +
                            'DbiTypes=BDE;DbiProcs=BDE;DbiErrs=BDE');
    if SameText(edtConfig.Text, 'Debug') then
    begin
      ResponseFileContent.Add('-DDEBUG');
      ResponseFileContent.Add('-$D+');  // Debug info
      ResponseFileContent.Add('-$O-');  // No optimization
    end
    else
    begin
      ResponseFileContent.Add('-DRELEASE');
      ResponseFileContent.Add('-$D0');  // No debug info
      ResponseFileContent.Add('-$O+');  // Optimization
    end;
    //ResponseFileContent.Add('-E.\Win32\Release');
    ResponseFileContent.Add('-E' + edtOutputExe.Text);
    // INCLUDE PATHS (-I) - Solo para archivos .inc
    if FDelphiPaths.IncludePaths <> '' then
    begin
      var IncludeArray := CleanDuplicatePaths(
                                        FDelphiPaths.IncludePaths).Split([';']);
      for var IncPath in IncludeArray do
        if Trim(IncPath) <> '' then
          ResponseFileContent.Add('-I' + IncPath);
    end;
    //ResponseFileContent.Add('-LEC:\Users\Public\Documents\Embarcadero\Studio\20.0\Bpl');
    ResponseFileContent.Add('-LE'+
                        IncludeTrailingPathDelimiter(edtCommonPath.Text)+'Bpl');
    ResponseFileContent.Add('-LN'+
                        IncludeTrailingPathDelimiter(edtCommonPath.Text)+'Dcp');
    if ContainsText(edtOutputExe.Text, '.\') then
         ForceDirectories(IncludeTrailingPathDelimiter(ProjectDir) +
                         Format('%s\%s\dcu',[edtPlatForm.Text, edtConfig.Text]))
    else
      ForceDirectories(IncludeTrailingPathDelimiter(edtOutputExe.Text) + 'dcu');
    PathDcu := '-NU' + edtOutputExe.Text +'\'+ 'dcu';
    ResponseFileContent.Add(PathDcu);
    ResponseFileContent.Add('-NSWinapi;System.Win;Data.Win;Datasnap.Win;' +
                            'Web.Win;Soap.Win;Xml.Win;Bde;System;Xml;Data;'+
                            'Datasnap;Web;Soap;Vcl;Vcl.Imaging;Vcl.Touch;'+
                            'Vcl.Samples;Vcl.Shell;');
    // RESOURCE PATHS (-R) - Para archivos .res como JvConsts.res
    if FDelphiPaths.ResourcePaths <> '' then
    begin
      var ResourceArray :=
                   CleanDuplicatePaths(FDelphiPaths.ResourcePaths).Split([';']);
      for var ResPath in ResourceArray do
        if Trim(ResPath) <> '' then
          ResponseFileContent.Add('-R' + ResPath);
    end;
    // UNIT PATHS (-U) - Para archivos .pas y .dcu
    if FDelphiPaths.UnitPaths <> '' then
    begin
      var UnitArray := CleanDuplicatePaths(FDelphiPaths.UnitPaths).Split([';']);
      for var UnitPath in UnitArray do
        if Trim(UnitPath) <> '' then
          ResponseFileContent.Add('-U' + UnitPath);
    end;
    ResponseFileContent.Add('-NB'+
                        IncludeTrailingPathDelimiter(edtCommonPath.Text)+'Dcp');
    ResponseFileContent.Add('-NH'+
      IncludeTrailingPathDelimiter(edtCommonPath.Text) +
                                          Format('hpp\%s', [edtPlatForm.Text]));
    ResponseFileContent.Add(Format('-NO.\%s\%s',
                                            [edtPlatForm.Text, edtConfig.text]));
    ResponseFileContent.Add('"' + ProjectName + '"');
    // Guardar archivo de respuesta
    ResponseFileContent.SaveToFile(ResponseFile);
    LogMessage('Archivo de respuesta creado: ' + ResponseFile);
    LogMessage('Total líneas en archivo de respuesta: ' +
                                           IntToStr(ResponseFileContent.Count));
    // Comando usando archivo de respuesta
    Command := '"' + DelphiBin + '\'+edtCompilerName.Text+
                                                    '" @"' + ResponseFile + '"';
    LogMessage('Comando: ' + Command);
    LogMessage('Ejecutando compilación...');
    if ContainsText(edtOutputExe.Text, '.\')  then
      ForceDirectories(ProjectDir + Format('%s\%s',
                                            [edtPlatForm.Text, edtConfig.Text]))
    else
      ForceDirectories(edtOutputExe.Text);
    try
      //var Process: TJclConsoleApplication;
      Result := ExecuteCommand3(Command, ProjectDir);
      if Result then
        LogMessage('¡Compilación exitosa!')
      else
        LogMessage('Error en compilación - revisar log detallado');
    finally
      // Mantener archivo para debug si hay error
      if not Result then
        LogMessage('Archivo de respuesta conservado para debugging: ' + ResponseFile)
      else
        if FileExists(ResponseFile) then
          DeleteFile(ResponseFile);
    end;
  finally
    ResponseFileContent.Free;
  end;
end;

procedure TfrmPublish.btnCompileClick(Sender: TObject);
var
  NewVersion: string;
begin
  // Validar campos
  if not FileExists(edtProjectPath.Text) then
  begin
    LogMessage('Seleccione un archivo de proyecto válido (.dpr)');
    Exit;
  end;
  if chkVersionarVariable.Checked = False then
    if not FileExists(edtLibVarGlobPath.Text) then
    begin
      LogMessage('Seleccione el archivo inLibVarGlob.pas');
      Exit;
    end;
  btnCompile.Enabled := False;
  try
    NewVersion := edtVersion.Text;
    LogMessage('=== INICIANDO COMPILACIÓN ===');
    // Paso 1: Actualizar versión en el archivo
//    ProgressBar1.Position := 25;
    if chkVersionarVariable.Checked = False then
      if not UpdateVersionInFile(edtLibVarGlobPath.Text, NewVersion) then
      begin
        LogMessage('ERROR: No se pudo actualizar la versión');
        Exit;
      end
      else
      begin
        LogMessage('Actualizando versión en ' + ExtractFileName(edtLibVarGlobPath.Text));
        LogMessage('Versión actualizada correctamente');
        LogMessage('Nueva versión: ' + NewVersion);
      end;
    // Paso 2: Compilar proyecto
//    ProgressBar1.Position := 50;
    LogMessage('Iniciando compilación del proyecto...');
    if CompileProject then
    begin
      LogMessage('=== COMPILACIÓN EXITOSA ===');
      // Paso 3: Enviar a VirusTotal si está habilitado
//      if chkSendToVirusTotal.Checked then
//      begin
//        EnviarVirusTotal;
//      end;
//      ProgressBar1.Position := 100;
      LogMessage('Proceso completado exitosamente!' + #13#10 +
                  'Versión: ' + NewVersion);
    end
    else
    begin
      LogMessage('ERROR: Fallo en la compilación');
      LogMessage('Error en la compilación. Revise el log.');
    end;
  finally
//    ProgressBar1.Visible := False;
    btnCompile.Enabled := True;
  end;
end;

procedure TfrmPublish.EnviarVirusTotal;
var
  ProjectName, CompressedFileName:string;
begin
  //        ProgressBar1.Position := 85;
  LogMessage('Enviando a VirusTotal...');
  if Trim(edtVirusTotalAPIKey.Text) = '' then
  begin
    LogMessage('ADVERTENCIA: No se proporcionó API Key de VirusTotal');
  end
  else
  begin
    ProjectName := TPath.GetFileNameWithoutExtension(edtProjectPath.Text);
    CompressedFileName := IncludeTrailingPathDelimiter(edtExeDestPath.Text) +
                          ProjectName + '_' + edtVersion.Text + '.7z';
    if FileExists(CompressedFileName) then
    begin
      if SendToVirusTotal(CompressedFileName) then
        LogMessage('Archivo enviado a VirusTotal correctamente')
      else
        LogMessage('ERROR: Fallo al enviar a VirusTotal');
    end
    else
    begin
      LogMessage('ERROR: No se encontró el ejecutable comprimido: ' +
                                                            CompressedFileName);
    end;
  end;
end;

// Función para forzar el análisis de comportamiento
function TfrmPublish.ForceFileAnalysis(const FileHash: string): Boolean;
var
  HTTPClient: THTTPClient;
  Response: IHTTPResponse;
  RequestBody: TStringStream;
begin
  Result := False;
  HTTPClient := THTTPClient.Create;
  try
    HTTPClient.CustomHeaders['x-apikey'] := Trim(edtVirusTotalAPIKey.Text);
    HTTPClient.ContentType := 'application/x-www-form-urlencoded';
    RequestBody := TStringStream.Create('');
    try
      LogMessage('🚀 Forzando análisis de comportamiento en sandbox...');

      // Forzar análisis del archivo
      Response := HTTPClient.Post('https://www.virustotal.com/api/v3/files/' + FileHash + '/analyse',
                                 RequestBody);
      if Response.StatusCode = 200 then
      begin
        LogMessage('✅ Análisis de comportamiento iniciado');
        Result := True;
      end
      else if Response.StatusCode = 429 then
      begin
        LogMessage('⚠️ Rate limit alcanzado - el análisis puede tardar más');
        Result := True; // Aún así consideramos que es exitoso
      end
      else
      begin
        LogMessage('❌ Error al forzar análisis: ' + IntToStr(Response.StatusCode));
        LogMessage('Respuesta: ' + Response.ContentAsString);
      end;
    finally
      RequestBody.Free;
    end;
  finally
    HTTPClient.Free;
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
  RequestBody: TMemoryStream;
  FileContent: TBytes;
  DataObj: TJSONObject;
  ContentStr: AnsiString;
begin
  Result := False;
  if not FileExists(FilePath) then
  begin
    LogMessage('ERROR: Archivo no encontrado: ' + FilePath);
    Exit;
  end;
  HTTPClient := THTTPClient.Create;
  try
    // Configurar headers
    HTTPClient.CustomHeaders['x-apikey'] := Trim(edtVirusTotalAPIKey.Text);
    // Generar boundary para multipart
    Boundary := 'FormBoundary' + FormatDateTime('yyyymmddhhnnsszzz', Now);
    HTTPClient.ContentType := 'multipart/form-data; boundary=' + Boundary;
    // Leer archivo
    FileStream := TFileStream.Create(FilePath, fmOpenRead);
    try
      SetLength(FileContent, FileStream.Size);
      FileStream.ReadBuffer(FileContent[0], FileStream.Size);
      LogMessage('Subiendo archivo a VirusTotal...');
      LogMessage('Archivo: ' + ExtractFileName(FilePath));
      LogMessage('Tamaño: ' + FormatFloat('#,##0', FileStream.Size / 1024) + ' KB');
    finally
      FileStream.Free;
    end;
    // Construir body multipart manualmente usando TMemoryStream
    RequestBody := TMemoryStream.Create;
    try
      // Inicio del boundary
      ContentStr := AnsiString('--' + Boundary + #13#10);
      RequestBody.Write(ContentStr[1], Length(ContentStr));
      // Headers del archivo
      ContentStr := AnsiString('Content-Disposition: form-data; name="file"; filename="' +
                               ExtractFileName(FilePath) + '"' + #13#10);
      RequestBody.Write(ContentStr[1], Length(ContentStr));
      ContentStr := AnsiString('Content-Type: application/octet-stream' + #13#10#13#10);
      RequestBody.Write(ContentStr[1], Length(ContentStr));
      // Contenido del archivo
      RequestBody.Write(FileContent[0], Length(FileContent));
      // Final del boundary
      ContentStr := AnsiString(#13#10 + '--' + Boundary + '--' + #13#10);
      RequestBody.Write(ContentStr[1], Length(ContentStr));
      // Resetear posición del stream
      RequestBody.Position := 0;
      try
        // Enviar archivo
        Response := HTTPClient.Post('https://www.virustotal.com/api/v3/files', RequestBody);
        if Response.StatusCode = 200 then
        begin
          LogMessage('Respuesta de VirusTotal recibida');
          // Parsear respuesta JSON
          JSONResponse := TJSONObject.ParseJSONValue(Response.ContentAsString) as TJSONObject;
          if Assigned(JSONResponse) then
          try
            if JSONResponse.TryGetValue('data', DataObj) then
            begin
              if DataObj.TryGetValue('id', AnalysisID) then
              begin
                edtAnalisisID.Text := AnalysisID;
                LogMessage('ID de análisis: ' + AnalysisID);
                LogMessage('URL del análisis: https://www.virustotal.com/gui/file-analysis/' + AnalysisID);
                // Esperar un momento y obtener resultado inicial
//                ForceFileAnalysis(AnalysisID);
                Result := True;
              end
              else
              begin
                LogMessage('ERROR: No se recibió ID de análisis');
              end;
            end
            else
            begin
              LogMessage('ERROR en respuesta: ' + Response.ContentAsString);
            end;
          finally
            JSONResponse.Free;
          end;
        end
        else
        begin
          LogMessage('ERROR HTTP: ' + IntToStr(Response.StatusCode) + ' - ' + Response.StatusText);
          LogMessage('Respuesta: ' + Response.ContentAsString);
        end;
      except
        on E: Exception do
        begin
          LogMessage('ERROR al enviar a VirusTotal: ' + E.Message);
        end;
      end;
    finally
      RequestBody.Free;
    end;
  finally
    HTTPClient.Free;
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
        LogMessage('ERROR HTTP al obtener resultado: ' + IntToStr(Response.StatusCode));
      end;
    except
      on E: Exception do
      begin
        LogMessage('ERROR al obtener resultado: ' + E.Message);
      end;
    end;
  finally
    HTTPClient.Free;
  end;
end;

//FUNCIONES Y PROC DLL
function TfrmPublish.ExecuteCommand3(const CommandLine, DirIni: string): Boolean;
var
  ExitCode: Cardinal;
  CurrentDir: string;
begin
  Result := False;
  try
    if DirIni <> '' then
    begin
      CurrentDir := GetCurrentDir;
      SetCurrentDir(DirIni);
    end;
    LogMessage('Ejecutando: ' + CommandLine);
    // Usar Execute con callback para procesamiento línea por línea
    ExitCode := Execute(CommandLine, ProcessOutputLine);
    LogMessage('Código de salida: ' + IntToStr(ExitCode));
    Result := (ExitCode = 0);
  except
    on E: Exception do
    begin
      LogMessage('Error: ' + E.Message);
      Result := False;
    end;
  end;
  if (DirIni <> '') and (CurrentDir <> '') then
    SetCurrentDir(CurrentDir);
end;
// Método para procesar cada línea
procedure TfrmPublish.ProcessOutputLine(const Text: string);
begin
  LogMessage(Text); // Procesar cada línea conforme llega
end;

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
      LogMessage('Error extrayendo DLL: ' + E.Message);
      Result := '';
    end;
  end;
end;

end.
