unit ExemploTLGPD;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.Mask,
  LGPD, Vcl.Menus;

type
  TForm1 = class(TForm)
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    DBNavigator1: TDBNavigator;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    tabClientes: TFDMemTable;
    tabClientescodigo: TIntegerField;
    tabClientesnome: TStringField;
    tabClientesRG: TStringField;
    tabClientesCPF: TStringField;
    tabClientestelefone: TStringField;
    tabClientesdata_nascimento: TDateField;
    DataSource1: TDataSource;
    LGPD1: TLGPD;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  LGPD1.MascararDados;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  LGPD1.CriptografarDados;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  LGPD1.DecifrarDados;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  LGPD1.RemoverMascaras;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  tabClientes.CreateDataSet;
  tabClientes.Open;
  tabClientes.Edit;
  tabClientes.InsertRecord([5, 'JERUNDIO GEROINO',      '06184465082', '460234766', '11991954655', Date ]);
  tabClientes.InsertRecord([4, 'GUMERCINDO MILOVAN',    '77144697064', '426388902', '1865478952',  Date ]);
  tabClientes.InsertRecord([3, 'JUBILEUZO PETRIUS',     '81635121051', '142643245', '1278965412',  Date ]);
  tabClientes.InsertRecord([2, 'CIPRIANO TORTELO DE SÁ','48958009039', '437011689', '14852369741', Date ]);
  tabClientes.InsertRecord([1, 'PAFUNCIO ELBANEIZ',     '48026902076', '256888851', '11998877665', Date ]);
end;

end.
