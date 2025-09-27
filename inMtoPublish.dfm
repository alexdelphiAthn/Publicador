object frmPublish: TfrmPublish
  Left = 0
  Top = 0
  Caption = 'Publicaci'#243'n de ejecutables y c'#243'digo fuente'
  ClientHeight = 606
  ClientWidth = 1071
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 21
  object spl1: TSplitter
    Left = 0
    Top = 428
    Width = 1071
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    Beveled = True
    Color = clBackground
    ParentColor = False
    ExplicitTop = 0
    ExplicitWidth = 431
  end
  object m1: TMemo
    Left = 0
    Top = 431
    Width = 1071
    Height = 175
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'JetBrains Mono'
    Font.Style = []
    Lines.Strings = (
      'm1')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
    ExplicitTop = 430
    ExplicitWidth = 896
  end
  object jpcPestanas: TJvgPageControl
    Left = 0
    Top = 0
    Width = 1071
    Height = 428
    ActivePage = tsFicheros
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    TabOrder = 1
    TabStop = False
    TabStyle.Borders = [fsdLeft, fsdTop, fsdRight, fsdBottom]
    TabStyle.BevelInner = bvNone
    TabStyle.BevelOuter = bvNone
    TabStyle.Bold = False
    TabStyle.BackgrColor = clBtnShadow
    TabStyle.Font.Charset = DEFAULT_CHARSET
    TabStyle.Font.Color = clBtnHighlight
    TabStyle.Font.Height = -11
    TabStyle.Font.Name = 'Arial'
    TabStyle.Font.Style = []
    TabStyle.CaptionHAlign = fhaCenter
    TabStyle.Gradient.Active = False
    TabStyle.Gradient.Orientation = fgdHorizontal
    TabSelectedStyle.Borders = [fsdLeft, fsdTop, fsdRight, fsdBottom]
    TabSelectedStyle.BevelInner = bvNone
    TabSelectedStyle.BevelOuter = bvNone
    TabSelectedStyle.Bold = False
    TabSelectedStyle.BackgrColor = clBtnFace
    TabSelectedStyle.Font.Charset = DEFAULT_CHARSET
    TabSelectedStyle.Font.Color = clBtnText
    TabSelectedStyle.Font.Height = -11
    TabSelectedStyle.Font.Name = 'Arial'
    TabSelectedStyle.Font.Style = []
    TabSelectedStyle.CaptionHAlign = fhaCenter
    TabSelectedStyle.Gradient.Active = False
    TabSelectedStyle.Gradient.Orientation = fgdHorizontal
    Options = [ftoAutoFontDirection, ftoExcludeGlyphs]
    ExplicitWidth = 900
    ExplicitHeight = 431
    object tsFicheros: TTabSheet
      Caption = 'Ficheros C'#243'digo Fuente'
      object lblOrigen: TLabel
        Left = 16
        Top = 18
        Width = 106
        Height = 21
        Caption = 'Carpeta Origen'
      end
      object lblOrigen1: TLabel
        Left = 16
        Top = 66
        Width = 108
        Height = 21
        Caption = 'Fichero Destino'
      end
      object lblPassword: TLabel
        Left = 16
        Top = 117
        Width = 223
        Height = 21
        Caption = 'Contrase'#241'a Fichero comprimido'
      end
      object lblExtensiones: TLabel
        Left = 608
        Top = 4
        Width = 60
        Height = 21
        Caption = 'Patrones'
      end
      object edtOrigen: TEdit
        Left = 16
        Top = 39
        Width = 281
        Height = 29
        TabOrder = 0
      end
      object btn3: TButton
        Left = 295
        Top = 41
        Width = 26
        Height = 25
        Caption = '...'
        TabOrder = 1
      end
      object btnComprimir: TButton
        Left = 80
        Top = 208
        Width = 449
        Height = 25
        Caption = 'Comprimir'
        TabOrder = 2
        OnClick = btnComprimirClick
      end
      object btnCheck: TButton
        Left = 344
        Top = 89
        Width = 185
        Height = 25
        Caption = 'Probar Listar interior 7z'
        TabOrder = 3
        OnClick = btnCheckClick
      end
      object edtDestino: TEdit
        Left = 16
        Top = 87
        Width = 281
        Height = 29
        TabOrder = 4
      end
      object btnDestino: TButton
        Left = 295
        Top = 89
        Width = 26
        Height = 25
        Caption = '...'
        TabOrder = 5
        OnClick = btnDestinoClick
      end
      object edtPassword: TEdit
        Left = 16
        Top = 138
        Width = 281
        Height = 29
        TabOrder = 6
      end
      object edtExtension: TEdit
        Left = 608
        Top = 31
        Width = 97
        Height = 29
        TabOrder = 7
      end
      object lstExtensiones: TListBox
        Left = 608
        Top = 66
        Width = 97
        Height = 211
        ItemHeight = 21
        Items.Strings = (
          '*.pas'
          '*.dfm'
          '*.txt'
          '*.dpr'
          '*.dproj'
          '*.sql'
          '*.ini'
          '*.docx')
        TabOrder = 8
      end
      object btnAddExt: TButton
        Left = 711
        Top = 67
        Width = 90
        Height = 25
        Caption = 'A'#241'adir'
        TabOrder = 9
        OnClick = btnAddExtClick
      end
      object btnDeleteExt: TButton
        Left = 711
        Top = 252
        Width = 90
        Height = 25
        Caption = 'Quitar'
        TabOrder = 10
        OnClick = btnDeleteExtClick
      end
    end
    object tsFTP: TTabSheet
      Caption = 'Conexi'#243'n sFTP'
      ImageIndex = 1
      object lblPassword1: TLabel
        Left = 13
        Top = 34
        Width = 95
        Height = 21
        Caption = 'Servidor sFTP'
      end
      object lblPuerto: TLabel
        Left = 221
        Top = 34
        Width = 82
        Height = 21
        Caption = 'Puerto sFTP'
      end
      object lblCarpetaRemot: TLabel
        Left = 317
        Top = 34
        Width = 112
        Height = 21
        Caption = 'Carpeta Remota'
      end
      object lblPassword11: TLabel
        Left = 13
        Top = 84
        Width = 90
        Height = 21
        Caption = 'Usuario sFTP'
      end
      object lblPassFTP: TLabel
        Left = 13
        Top = 132
        Width = 102
        Height = 21
        Caption = 'Password sFTP'
      end
      object edtServer: TEdit
        Left = 13
        Top = 55
        Width = 185
        Height = 29
        TabOrder = 0
      end
      object edtPuerto: TEdit
        Left = 221
        Top = 55
        Width = 73
        Height = 29
        NumbersOnly = True
        TabOrder = 1
      end
      object edtCarpetaRemota: TEdit
        Left = 317
        Top = 55
        Width = 281
        Height = 29
        TabOrder = 2
      end
      object edtUsuario: TEdit
        Left = 13
        Top = 105
        Width = 281
        Height = 29
        TabOrder = 3
      end
      object edtPassFTP: TEdit
        Left = 13
        Top = 156
        Width = 281
        Height = 29
        TabOrder = 4
      end
      object btnEnviarFTP: TButton
        Left = 80
        Top = 208
        Width = 449
        Height = 25
        Caption = 'Enviar Fichero Destino'
        TabOrder = 5
        OnClick = btnEnviarFTPClick
      end
    end
    object tsCompilacion: TTabSheet
      Caption = 'Compilacion'
      ImageIndex = 3
      object grp1: TGroupBox
        Left = 3
        Top = -13
        Width = 849
        Height = 334
        Caption = ' Configuraci'#243'n '
        TabOrder = 0
        object lbl1: TLabel
          Left = 88
          Top = 24
          Width = 55
          Height = 21
          Caption = 'Versi'#243'n:'
        end
        object lbl2: TLabel
          Left = 22
          Top = 56
          Width = 121
          Height = 21
          Caption = 'Archivo Proyecto:'
        end
        object lbl3: TLabel
          Left = 23
          Top = 88
          Width = 120
          Height = 21
          Caption = 'inLibVarGlob.pas:'
        end
        object lbl4: TLabel
          Left = 16
          Top = 120
          Width = 127
          Height = 21
          Caption = 'VirusTotal API Key:'
        end
        object edtVersion: TEdit
          Left = 152
          Top = 22
          Width = 161
          Height = 29
          TabOrder = 0
          Text = '109.112014092025'
        end
        object edtProjectPath: TEdit
          Left = 152
          Top = 54
          Width = 400
          Height = 29
          TabOrder = 1
        end
        object btnSelectProject: TButton
          Left = 558
          Top = 52
          Width = 99
          Height = 25
          Caption = 'Seleccionar'
          TabOrder = 2
          OnClick = btnSelectProjectClick
        end
        object edtLibVarGlobPath: TEdit
          Left = 152
          Top = 86
          Width = 400
          Height = 29
          TabOrder = 3
        end
        object btnSelectLibVarGlob: TButton
          Left = 558
          Top = 84
          Width = 99
          Height = 25
          Caption = 'Seleccionar'
          TabOrder = 4
          OnClick = btnSelectLibVarGlobClick
        end
        object edtVirusTotalAPIKey: TEdit
          Left = 152
          Top = 118
          Width = 553
          Height = 29
          TabOrder = 5
        end
        object chkSendToVirusTotal: TCheckBox
          Left = 152
          Top = 154
          Width = 497
          Height = 17
          Caption = 'Enviar a VirusTotal autom'#225'ticamente despu'#233's de la compilaci'#243'n'
          TabOrder = 6
        end
        object btnCompile: TButton
          Left = 80
          Top = 208
          Width = 449
          Height = 25
          Caption = 'COMPILAR Y CONSTRUIR EXE RELEASE'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 7
          OnClick = btnCompileClick
        end
        object btnGetDate: TButton
          Left = 319
          Top = 25
          Width = 147
          Height = 25
          Caption = 'Obtener Fecha y Hora '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 8
          OnClick = btnGetDateClick
        end
        object btnVirusTotal: TButton
          Left = 622
          Top = 208
          Width = 179
          Height = 25
          Caption = 'ENVIAR A VIRUSTOTAL'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 9
          OnClick = btnVirusTotalClick
        end
        object chkVersionarVariable: TCheckBox
          Left = 678
          Top = 88
          Width = 329
          Height = 17
          Caption = 'No Versionar Vble.'
          Checked = True
          State = cbChecked
          TabOrder = 10
        end
        object btnAnalizar: TButton
          Left = 622
          Top = 153
          Width = 211
          Height = 25
          Caption = 'ANALIZAR RESPUESTA VIRUSTOTAL'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 11
          OnClick = btnAnalizarClick
        end
        object edtAnalisisID: TEdit
          Left = 720
          Top = 118
          Width = 97
          Height = 29
          TabOrder = 12
        end
      end
    end
    object tsPublicarExe: TTabSheet
      Caption = 'Publicar ejecutable'
      ImageIndex = 4
      object lbl5: TLabel
        Left = 16
        Top = 13
        Width = 263
        Height = 21
        Caption = 'Ficheros que acompa'#241'an al ejecutable'
      end
      object lbl21: TLabel
        Left = 394
        Top = 43
        Width = 88
        Height = 21
        Caption = 'Carpeta final'
      end
      object edtExtension1: TEdit
        Left = 16
        Top = 40
        Width = 201
        Height = 29
        TabOrder = 0
      end
      object lstExtensiones1: TListBox
        Left = 16
        Top = 74
        Width = 201
        Height = 211
        ItemHeight = 21
        Items.Strings = (
          'C:\DISCO DURO\proyectos\subocasoft\script_109.sql'
          'C:\DISCO DURO\proyectos\subocasoft\SUBOCASOFT VERSION 109.docx')
        TabOrder = 1
      end
      object btnAddExt1: TButton
        Left = 223
        Top = 74
        Width = 122
        Height = 25
        Caption = 'A'#241'adir fichero'
        TabOrder = 2
        OnClick = btnAddExtClick
      end
      object btnDeleteExt1: TButton
        Left = 223
        Top = 260
        Width = 74
        Height = 25
        Caption = 'Quitar'
        TabOrder = 3
        OnClick = btnDeleteExtClick
      end
      object btnSelectProject1: TButton
        Left = 223
        Top = 43
        Width = 74
        Height = 25
        Caption = 'Buscar'
        TabOrder = 4
        OnClick = btnSelectProjectClick
      end
      object edtProjectPath1: TEdit
        Left = 488
        Top = 40
        Width = 400
        Height = 29
        TabOrder = 5
        Text = 'C:\DISCO DURO\proyectos\subocasoft'
      end
      object btnSelectProject2: TButton
        Left = 894
        Top = 38
        Width = 99
        Height = 25
        Caption = 'Seleccionar'
        TabOrder = 6
        OnClick = btnSelectProjectClick
      end
    end
  end
  object clsftp3: TclSFtp
    SshAgent = 'Clever_Internet_Suite'
    CharSet = 'utf-8'
    Left = 176
    Top = 560
  end
  object sd7z: TSaveDialog
    Filter = 'Archivo Comprimido 7z (*.7z)|*.7z'
    Left = 72
    Top = 560
  end
  object flpndlg1: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = [fdoPickFolders, fdoForceFileSystem, fdoPathMustExist]
    Left = 16
    Top = 560
  end
  object sFtpClient: TclSFtp
    SshAgent = 'Clever_Internet_Suite'
    CharSet = 'utf-8'
    OnVerifyServer = sFtpClientVerifyServer
    Left = 120
    Top = 560
  end
  object dlgOpenPoject: TJvOpenDialog
    Filter = 'Proyecto Delphi dpr (*.dpr)|*.dpr'
    Options = [ofReadOnly, ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Height = 0
    Width = 0
    Left = 448
    Top = 312
  end
  object dlgSelectFolder: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = [fdoPickFolders, fdoForceFileSystem, fdoPathMustExist]
    Left = 504
    Top = 312
  end
  object dlgOpenLibVarGlob: TJvOpenDialog
    Filter = 'Archivo Pascal (*.pas)|*.pas'
    Options = [ofReadOnly, ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Height = 0
    Width = 0
    Left = 560
    Top = 312
  end
end
