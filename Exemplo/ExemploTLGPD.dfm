object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'i9 LGPD'
  ClientHeight = 344
  ClientWidth = 825
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 0
    Top = 89
    Width = 825
    Height = 225
    Align = alClient
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'codigo'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'nome'
        Width = 150
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'RG'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CPF'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'telefone'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'data_nascimento'
        Visible = True
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 825
    Height = 41
    Align = alTop
    Color = clHighlight
    ParentBackground = False
    TabOrder = 1
    object Label1: TLabel
      Left = 182
      Top = 9
      Width = 460
      Height = 23
      Caption = 'i9 TLGPD - Componente para Prote'#231#227'o de Dados'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 825
    Height = 48
    Align = alTop
    TabOrder = 2
    object Button1: TButton
      Left = 16
      Top = 10
      Width = 97
      Height = 25
      Caption = 'M'#225'scarar Dados'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 247
      Top = 10
      Width = 114
      Height = 25
      Caption = 'Aplicar Criptografia'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 367
      Top = 10
      Width = 123
      Height = 25
      Caption = 'Decifrar Dados'
      TabOrder = 2
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 119
      Top = 10
      Width = 114
      Height = 25
      Caption = 'Remover M'#225'scaras'
      TabOrder = 3
      OnClick = Button4Click
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 314
    Width = 825
    Height = 30
    Align = alBottom
    TabOrder = 3
    object DBNavigator1: TDBNavigator
      Left = 584
      Top = 1
      Width = 240
      Height = 28
      DataSource = DataSource1
      Align = alRight
      TabOrder = 0
    end
  end
  object tabClientes: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 400
    Top = 176
    object tabClientescodigo: TIntegerField
      FieldName = 'codigo'
    end
    object tabClientesnome: TStringField
      FieldName = 'nome'
      Size = 100
    end
    object tabClientesRG: TStringField
      FieldName = 'RG'
    end
    object tabClientesCPF: TStringField
      FieldName = 'CPF'
    end
    object tabClientestelefone: TStringField
      FieldName = 'telefone'
    end
    object tabClientesdata_nascimento: TDateField
      FieldName = 'data_nascimento'
    end
  end
  object DataSource1: TDataSource
    DataSet = tabClientes
    Left = 184
    Top = 160
  end
  object LGPD1: TLGPD
    Dataset = tabClientes
    Dados = <
      item
        Field = tabClientescodigo
        Nome = 'codigo'
        Criptografar = False
      end
      item
        Field = tabClientesnome
        Nome = 'nome'
        Criptografar = True
      end
      item
        Field = tabClientesRG
        Nome = 'RG'
        Criptografar = True
      end
      item
        Field = tabClientesCPF
        Nome = 'CPF'
        Criptografar = True
      end
      item
        Field = tabClientestelefone
        Nome = 'telefone'
        Criptografar = True
      end
      item
        Field = tabClientesdata_nascimento
        Nome = 'data_nascimento'
        Criptografar = False
      end>
    Mascara = '*'
    Chave = 223
    Left = 752
    Top = 128
  end
end
