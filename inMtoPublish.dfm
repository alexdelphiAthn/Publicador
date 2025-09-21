object frmPublish: TfrmPublish
  Left = 0
  Top = 0
  Caption = 'Publicaci'#243'n de Ejecutables y c'#243'digo fuente'
  ClientHeight = 606
  ClientWidth = 900
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 21
  object m1: TMemo
    Left = 0
    Top = 431
    Width = 900
    Height = 175
    Align = alBottom
    Lines.Strings = (
      'm1')
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object jpcPestanas: TJvgPageControl
    Left = 0
    Top = 0
    Width = 900
    Height = 431
    ActivePage = tsCompilacion
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
    object tsFicheros: TTabSheet
      Caption = 'Ficheros C'#243'digo Fuente'
      ExplicitLeft = 8
      ExplicitTop = 30
      object lblOrigen: TLabel
        Left = 16
        Top = 18
        Width = 48
        Height = 21
        Caption = 'Origen'
      end
      object lblOrigen1: TLabel
        Left = 16
        Top = 66
        Width = 53
        Height = 21
        Caption = 'Destino'
      end
      object lblPassword: TLabel
        Left = 16
        Top = 117
        Width = 134
        Height = 21
        Caption = 'Contrase'#241'a Fichero'
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
        OnClick = btn3Click
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
        Caption = 'Listar interior 7z'
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
    end
    object tsPatrones: TTabSheet
      Caption = 'Patrones a incluir de c'#243'digo Fuente'
      ImageIndex = 2
      ExplicitWidth = 697
      ExplicitHeight = 321
      object lblExtensiones: TLabel
        Left = 149
        Top = 8
        Width = 60
        Height = 21
        Caption = 'Patrones'
      end
      object edtExtension: TEdit
        Left = 72
        Top = 32
        Width = 137
        Height = 29
        TabOrder = 0
      end
      object btnAddExt: TButton
        Left = 215
        Top = 35
        Width = 178
        Height = 25
        Caption = 'A'#241'adir'
        TabOrder = 1
        OnClick = btnAddExtClick
      end
      object lstExtensiones: TListBox
        Left = 96
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
        TabOrder = 2
      end
      object btnDeleteExt: TButton
        Left = 111
        Top = 283
        Width = 74
        Height = 25
        Caption = 'Quitar'
        TabOrder = 3
        OnClick = btnDeleteExtClick
      end
    end
    object tsCompilacion: TTabSheet
      Caption = 'Compilacion'
      ImageIndex = 3
      object grp1: TGroupBox
        Left = 3
        Top = 3
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
          Width = 200
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
        end
        object edtVirusTotalAPIKey: TEdit
          Left = 152
          Top = 118
          Width = 553
          Height = 29
          TabOrder = 5
          Text = '75235df774ef7701c060df42028c5de89a592cd0f6cf96da0a04a90a62a38f68'
        end
        object chkSendToVirusTotal: TCheckBox
          Left = 152
          Top = 160
          Width = 329
          Height = 17
          Caption = 'Enviar a VirusTotal autom'#225'ticamente'
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
          Left = 358
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
        end
      end
    end
    object tsFTP: TTabSheet
      Caption = 'Conexi'#243'n sFTP'
      ImageIndex = 1
      ExplicitLeft = -156
      ExplicitTop = 16
      ExplicitWidth = 625
      ExplicitHeight = 246
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
  end
  object clsftp3: TclSFtp
    SshAgent = 'Clever_Internet_Suite'
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
    OnVerifyServer = sFtpClientVerifyServer
    Left = 120
    Top = 560
  end
end
