unit inMtoPublish;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.NetConsts,
  System.Classes, Vcl.Graphics, System.Masks, ShellAPI, Registry, System.Types,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, clGZip, clTcpClient,
  clSFtp, sevenzip, System.IniFiles, Vcl.ComCtrls, JvgPage, System.Net.URLClient,
  System.IOUtils, System.StrUtils, System.DateUtils, System.Net.HttpClient,
  System.Net.HttpClientComponent, System.JSON, JvDialogs, clTcpClientSsh,
  Vcl.ExtCtrls;

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
    chkVersionarVariable: TCheckBox;
    btnAnalizar: TButton;
    edtAnalisisID: TEdit;
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
    edtExtension1: TEdit;
    lstExtensiones1: TListBox;
    btnAddExt1: TButton;
    btnDeleteExt1: TButton;
    btnSelectProject1: TButton;
    edtExtension: TEdit;
    lstExtensiones: TListBox;
    btnAddExt: TButton;
    btnDeleteExt: TButton;
    lblExtensiones: TLabel;
    spl1: TSplitter;
    lbl5: TLabel;
    edtProjectPath1: TEdit;
    lbl21: TLabel;
    btnSelectProject2: TButton;
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
  private
    sOrigen, sDestino, sPassword, sServer, sServerPort,
    sFolderDest, sUserFtp, sPassFtp, sVersion, sProjFile, sGlobFile:string;
    sVirusTotalAPI : string;
    aFiles:TStringList;
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
    function ExecuteCommand2(const CommandLine, DirIni: string): Boolean;
    function SendToVirusTotal(FilePath: string): Boolean;
    function GetAnalysisResult(const AnalysisID: string): string;
    procedure EnviarVirusTotal;
    function ForceFileAnalysis(const FileHash: string): Boolean;
    function GetDelphiRegistryPaths: string;
    function ReadCompleteDelphiPaths(const DelphiVersion: string): TDelphiPaths;
    function CleanDuplicatePaths(const PathsString: string): string;
  private
    FDelphiPaths: TDelphiPaths;
    F7zDLLHandle: THandle;
  end;

var
  frmPublish: TfrmPublish;

implementation

{$R *.dfm}
{$R recursos.res}

function TfrmPublish.ReadCompleteDelphiPaths(const DelphiVersion: string): TDelphiPaths;
var
  Registry: TRegistry;
  RegistryKey: string;
  SearchPath, BrowsingPath, DebugPath: string;
  PackageDCPOutput, PackageBPLOutput: string;
  Temp: string;
begin
  // Inicializar resultado
  Result.UnitPaths := '';
  Result.ResourcePaths := '';
  Result.IncludePaths := '';
  Result.ObjectPaths := '';
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    RegistryKey := Format('SOFTWARE\Embarcadero\BDS\%s\Library\Win32', [DelphiVersion]);

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
          if Result.UnitPaths <> '' then Result.UnitPaths := Result.UnitPaths + ';';
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
      var IncludeSubDir := IncludeTrailingPathDelimiter(CleanPath) + 'Include';
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
  M1.Lines.Add('');
  M1.Lines.Add('ESTADÍSTICAS DEL ARCHIVO:');
  M1.Lines.Add(StringOfChar('=', 40));
  M1.Lines.Add('Archivos: ' + IntToStr(TotalFiles));
  M1.Lines.Add('Carpetas: ' + IntToStr(TotalFolders));
  M1.Lines.Add('Tamaño original total: ' + FormatFileSize(TotalOriginalSize));
  M1.Lines.Add('Tamaño comprimido total: ' + FormatFileSize(TotalCompressedSize));

  if TotalOriginalSize > 0 then
  begin
    CompressionRatio := ((TotalOriginalSize - TotalCompressedSize) / TotalOriginalSize) * 100;
    M1.Lines.Add('Ratio de compresión: ' + FormatFloat('0.0', CompressionRatio) + '%');
    M1.Lines.Add('Factor de compresión: ' + FormatFloat('0.0', TotalOriginalSize / TotalCompressedSize) + ':1');
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
    M1.Lines.Add('CONTENIDO DEL ARCHIVO: ' + ExtractFileName(edtDestino.Text) + ' (ORDENADO ALFABÉTICAMENTE)');
    M1.Lines.Add(StringOfChar('=', 110));
    M1.Lines.Add('');

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
          FileItems[I].Extension := 'CARPETA';
          Inc(TotalFolders);
        end;
      end;

      // ORDENAR los elementos alfabéticamente
      SortFileItems(FileItems, Arch.NumberOfItems);

      // MOSTRAR el listado ordenado
      M1.Lines.Add('Número total de elementos: ' + IntToStr(Arch.NumberOfItems));
      M1.Lines.Add('');
      M1.Lines.Add(Format('%-40s %12s %16s %s',
        ['NOMBRE', 'TAMAÑO','MODIFICADO', 'TIPO']));
      M1.Lines.Add(StringOfChar('-', 80));

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
          M1.Lines.Add(Format('%s[%s]%s %12s %16s %s',
            [Indent, Copy(FileItem.Name, 1, 35-Length(Indent)),
             StringOfChar(' ', 35-Length(Indent)-Length(FileItem.Name)),
             SizeStr, FileItem.ModificationDate, FileItem.Extension]));
        end
        else
        begin
          M1.Lines.Add(Format('%s%s%s %12s %16s %s',
            [Indent, Copy(FileItem.Name, 1, 35-Length(Indent)),
             StringOfChar(' ', 35-Length(Indent)-Length(FileItem.Name)),
             SizeStr, FileItem.ModificationDate, FileItem.Extension]));
        end;
      end;

      M1.Lines.Add(StringOfChar('-', 80));

      // Mostrar estadísticas finales
      M1.Lines.Add('');
      M1.Lines.Add('ESTADÍSTICAS DEL ARCHIVO:');
      M1.Lines.Add(StringOfChar('=', 40));
      M1.Lines.Add('Archivos: ' + IntToStr(TotalFiles));
      M1.Lines.Add('Carpetas: ' + IntToStr(TotalFolders));
      M1.Lines.Add('Tamaño original total: ' + FormatFileSize(TotalOriginalSize));

      if TotalCompressedSize > 0 then
      begin
        M1.Lines.Add('Tamaño comprimido total: ' + FormatFileSize(TotalCompressedSize));
        if TotalOriginalSize > 0 then
        begin
          var OverallRatio := ((TotalOriginalSize - TotalCompressedSize) / TotalOriginalSize) * 100;
          M1.Lines.Add('Ratio de compresión: ' + FormatFloat('0.0', OverallRatio) + '%');
          if TotalCompressedSize > 0 then
            M1.Lines.Add('Factor de compresión: ' + FormatFloat('0.0', TotalOriginalSize / TotalCompressedSize) + ':1');
        end;
      end
      else
      begin
        M1.Lines.Add('Tamaño comprimido: No disponible individualmente');
      end;

      M1.Lines.Add('');
      M1.Lines.Add('Listado completado exitosamente (ordenado alfabéticamente)');

    except
      on E:Exception do
      begin
        M1.Lines.Add(Format('ERROR: [%s] %s', [E.ClassName, E.Message]));
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

procedure TfrmPublish.btnOrigenClick(Sender: TObject);
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

procedure TfrmPublish.btnAnalizarClick(Sender: TObject);
begin
  m1.Lines.Add('Resultado inicial...');

  var ResultSummary := GetAnalysisResult(edtAnalisisId.Text);
  if ResultSummary <> '' then
    m1.Lines.Add('Resultado: ' + ResultSummary);
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

procedure TfrmPublish.btnSelectLibVarGlobClick(Sender: TObject);
begin
//
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
begin
  // Extraer DLL del recurso
  DLLPath := ExtraerDLLDeRecurso;
  F7zDLLHandle := LoadLibrary(PChar(DLLPath));
  if F7zDLLHandle = 0 then
    raise Exception.Create('Error cargando 7z.dll');
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
  sVirusTotalAPI := leCadINI('Other', 'APIVirusTotal', '000000000000000000');
   //Leer extensiones del INI (guardadas como string separado por comas)
  extensiones := leCadIni('Files', 'Extensions', '*.exe,*.dll,*.txt');
   //Cargar extensiones en el ListBox
  lstExtensiones.Items.Clear;
  lstExtensiones.Items.CommaText := extensiones;
end;
procedure TfrmPublish.LogMessage(const Msg: string);
begin
  m1.Lines.Add(Msg);
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
  BasePaths := '"c:\program files (x86)\embarcadero\studio\20.0\lib\Win32\release"';
  BasePaths := BasePaths + ';"c:\program files (x86)\embarcadero\studio\20.0\Imports"';
  BasePaths := BasePaths + ';"C:\Users\Public\Documents\Embarcadero\Studio\20.0\Dcp"';
  BasePaths := BasePaths + ';"c:\program files (x86)\embarcadero\studio\20.0\include"';

  // Leer configuración completa del registro
  DelphiPaths := ReadCompleteDelphiPaths('20.0');

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
  DelphiBin: string;
  ResponseFile: string;
  ResponseFileContent: TStringList;
  AllPaths: string;
begin
  Result := False;
  ProjectDir := ExtractFilePath(edtProjectPath.Text);
  ProjectName := ExtractFileName(edtProjectPath.Text);
  DelphiBin := 'c:\program files (x86)\embarcadero\studio\20.0\bin';
  LogMessage('=== CONFIGURACIÓN DE COMPILACIÓN ===');
  LogMessage('Versión Delphi: 10.3');
  LogMessage('Compilador: ' + DelphiBin + '\dcc32.exe');
  LogMessage('Directorio de trabajo: ' + ProjectDir);
  LogMessage('Archivo proyecto: ' + ProjectName);
  // Crear archivo de respuesta temporal
  ResponseFile := ProjectDir + 'compile_temp.rsp';
  ResponseFileContent := TStringList.Create;
  try
    // Obtener paths organizados del registro (esto popula FDelphiPaths)
    AllPaths := GetDelphiRegistryPaths;
    // Construir contenido del archivo de respuesta con parámetros apropiados
    ResponseFileContent.Add('-$D0');
    ResponseFileContent.Add('-$L-');
    ResponseFileContent.Add('-$Y-');
    ResponseFileContent.Add('--no-config');
    ResponseFileContent.Add('-B');
    ResponseFileContent.Add('-Q');
    ResponseFileContent.Add('-TX.exe');
    ResponseFileContent.Add('-AGenerics.Collections=System.Generics.Collections;Generics.Defaults=System.Generics.Defaults;WinTypes=Winapi.Windows;WinProcs=Winapi.Windows;DbiTypes=BDE;DbiProcs=BDE;DbiErrs=BDE');
    ResponseFileContent.Add('-DRELEASE');
    ResponseFileContent.Add('-E.\Win32\Release');
    // INCLUDE PATHS (-I) - Solo para archivos .inc
    if FDelphiPaths.IncludePaths <> '' then
    begin
      var IncludeArray := CleanDuplicatePaths(FDelphiPaths.IncludePaths).Split([';']);
      for var IncPath in IncludeArray do
        if Trim(IncPath) <> '' then
          ResponseFileContent.Add('-I' + IncPath);
    end;
    ResponseFileContent.Add('-LEC:\Users\Public\Documents\Embarcadero\Studio\20.0\Bpl');
    ResponseFileContent.Add('-LNC:\Users\Public\Documents\Embarcadero\Studio\20.0\Dcp');
    ResponseFileContent.Add('-NU.\Win32\Release');
    ResponseFileContent.Add('-NSWinapi;System.Win;Data.Win;Datasnap.Win;Web.Win;Soap.Win;Xml.Win;Bde;System;Xml;Data;Datasnap;Web;Soap;Vcl;Vcl.Imaging;Vcl.Touch;Vcl.Samples;Vcl.Shell;');
    // RESOURCE PATHS (-R) - Para archivos .res como JvConsts.res
    if FDelphiPaths.ResourcePaths <> '' then
    begin
      var ResourceArray := CleanDuplicatePaths(FDelphiPaths.ResourcePaths).Split([';']);
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
    ResponseFileContent.Add('-NBC:\Users\Public\Documents\Embarcadero\Studio\20.0\Dcp');
    ResponseFileContent.Add('-NHC:\Users\Public\Documents\Embarcadero\Studio\20.0\hpp\Win32');
    ResponseFileContent.Add('-NO.\Win32\Release');
    ResponseFileContent.Add('"' + ProjectName + '"');
    // Guardar archivo de respuesta
    ResponseFileContent.SaveToFile(ResponseFile);
    LogMessage('Archivo de respuesta creado: ' + ResponseFile);
    LogMessage('Total líneas en archivo de respuesta: ' + IntToStr(ResponseFileContent.Count));
    // Comando usando archivo de respuesta
    Command := '"' + DelphiBin + '\dcc32.exe" @"' + ResponseFile + '"';
    LogMessage('Comando: ' + Command);
    m1.Lines.Add('Ejecutando compilación...');
    ForceDirectories(ProjectDir + '\Win32\Release');
    try
      Result := ExecuteCommand2(Command, ProjectDir);
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

function TfrmPublish.ExecuteCommand2(const CommandLine, DirIni: string): Boolean;
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  SecurityAttr: TSecurityAttributes;
  ReadPipe, WritePipe: THandle;
  Buffer: array[0..8191] of Byte;  // Buffer más grande
  BytesRead, BytesAvailable: DWORD;
  TempBytes: TBytes;
  Output: TStringBuilder;  // Usar StringBuilder para mejor rendimiento
  ExitCode: DWORD;
  ProcessRunning: Boolean;
  WaitResult: DWORD;
const
  BUFFER_SIZE = 8192;
  READ_TIMEOUT = 100;  // ms
begin
  Result := False;
  Output := TStringBuilder.Create;
  ReadPipe := INVALID_HANDLE_VALUE;
  WritePipe := INVALID_HANDLE_VALUE;
  try
    // Configurar seguridad para heredar handles
    SecurityAttr.nLength := SizeOf(SecurityAttr);
    SecurityAttr.bInheritHandle := True;
    SecurityAttr.lpSecurityDescriptor := nil;
    // Crear pipe con buffer más grande
    if not CreatePipe(ReadPipe, WritePipe, @SecurityAttr, BUFFER_SIZE * 4) then
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
    if not CreateProcess(nil, PChar(CommandLine), nil, nil, True,
                        CREATE_NO_WINDOW, nil, PChar(DirIni), StartupInfo, ProcessInfo) then
    begin
      LogMessage('Error al ejecutar: ' + IntToStr(GetLastError));
      Exit;
    end;
    try
      // Cerrar el extremo de escritura del pipe inmediatamente
      CloseHandle(WritePipe);
      WritePipe := INVALID_HANDLE_VALUE;
      ProcessRunning := True;
      // Bucle principal de lectura
      while ProcessRunning do
      begin
        Application.ProcessMessages;
        // Verificar si el proceso sigue ejecutándose
        WaitResult := WaitForSingleObject(ProcessInfo.hProcess, 0);
        ProcessRunning := (WaitResult = WAIT_TIMEOUT);
        // Verificar si hay datos disponibles en el pipe
        if PeekNamedPipe(ReadPipe, nil, 0, nil, @BytesAvailable, nil) then
        begin
          if BytesAvailable > 0 then
          begin
            // Leer datos disponibles
            ZeroMemory(@Buffer, SizeOf(Buffer));
            if ReadFile(ReadPipe, Buffer, SizeOf(Buffer) - 1, BytesRead, nil) and (BytesRead > 0) then
            begin
              SetLength(TempBytes, BytesRead);
              Move(Buffer[0], TempBytes[0], BytesRead);
              // Intentar diferentes codificaciones
              try
                Output.Append(TEncoding.UTF8.GetString(TempBytes));
              except
                try
                  Output.Append(TEncoding.Default.GetString(TempBytes));
                except
                  // Como último recurso, convertir byte a byte
                  for var i := 0 to BytesRead - 1 do
                    Output.Append(Chr(Buffer[i]));
                end;
              end;
            end;
          end
          else if not ProcessRunning then
          begin
            // El proceso terminó y no hay más datos
            Break;
          end;
        end
        else if not ProcessRunning then
        begin
          // Error en PeekNamedPipe y proceso terminado
          Break;
        end;
        // Pequeña pausa para evitar consumir demasiada CPU
        if BytesAvailable = 0 then
          Sleep(READ_TIMEOUT);
      end;
      // Leer cualquier dato restante después de que termine el proceso
      repeat
        if PeekNamedPipe(ReadPipe, nil, 0, nil, @BytesAvailable, nil) and (BytesAvailable > 0) then
        begin
          ZeroMemory(@Buffer, SizeOf(Buffer));
          if ReadFile(ReadPipe, Buffer, SizeOf(Buffer) - 1, BytesRead, nil) and (BytesRead > 0) then
          begin
            SetLength(TempBytes, BytesRead);
            Move(Buffer[0], TempBytes[0], BytesRead);
            try
              Output.Append(TEncoding.UTF8.GetString(TempBytes));
            except
              Output.Append(TEncoding.Default.GetString(TempBytes));
            end;
          end;
        end
        else
          Break;
      until False;
      // Verificar código de salida
      if GetExitCodeProcess(ProcessInfo.hProcess, ExitCode) then
      begin
        LogMessage('Proceso terminado con código: ' + IntToStr(ExitCode));
        Result := (ExitCode = 0);
      end;
      // Mostrar toda la salida capturada
      var CompleteOutput := Output.ToString;
      LogMessage('=== SALIDA COMPLETA DEL PROCESO ===');
      LogMessage('Longitud total: ' + IntToStr(Length(CompleteOutput)) + ' caracteres');
      LogMessage(CompleteOutput);
      LogMessage('=== FIN SALIDA PROCESO ===');
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
    Output.Free;
  end;
end;

procedure TfrmPublish.btnCompileClick(Sender: TObject);
var
  NewVersion: string;
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
                LogMessage('ID de análisis: ' + AnalysisID);
                LogMessage('URL del análisis: https://www.virustotal.com/gui/file-analysis/' + AnalysisID);
                // Esperar un momento y obtener resultado inicial
                ForceFileAnalysis(AnalysisID);
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

end.
