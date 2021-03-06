unit LGPD;

interface
  uses
    Data.DB,
    System.Classes,
    System.SysUtils,
    LGPD.Helpers;

type
  TOnCriptografarCampo = procedure(AValorOriginal: string) of object;

  TDado = class(TCollectionItem)
  private
    FNome          : string;
    FField         : TField;
    FCriptografar  : Boolean;
    FOnCriptografar: TOnCriptografarCampo;
    FCriptografado : string;
    FChave         : Word;
    procedure SetNome(const Value: string);
    function GetCriptografado: string;
  protected
    property Chave: Word read FChave write FChave;
    function GetDisplayName: string; override;
  public
    property Criptografado: string read GetCriptografado;
    function Decifrar: string;
  published
    property Field         : TField  read FField        write FField;
    property Nome          : string  read FNome         write SetNome;
    property Criptografar  : Boolean read FCriptografar write FCriptografar;
  end;

  TLGPD = class;

  TDados = class(TCollection)
  private
    FLGPD: TLGPD;
    function GetItem(Index: Integer): TDado;
    procedure SetItem(Index: Integer; Value: TDado);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(ALGPD: TLGPD);
    function Add: TDado;
    property Items[Index: Integer]: TDado read GetItem write SetItem; default;
  end;

  TOnCriptografarCampos = procedure(const ADados: TDados) of object;

  TLGPD = class(TComponent)
  private
    FDataset: TDataset;
    FDados  : TDados;
    FMascara: Char;
    FChave  : Word;

    FOnCriptografar: TOnCriptografarCampos;
    procedure SetItems(Value: TDados);
    procedure SetDataset(const Value: TDataset);
    function DadoExists(const AField: TField): Boolean; overload;
    function GetDado(const AFieldName: string): TDado; overload;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure SetLGPDValue(Sender: TField; var Text: string; DisplayText: Boolean);

    procedure MascararDados;
    procedure RemoverMascaras;
    procedure AdicionarDados;

    procedure CriptografarDados;
    procedure DecifrarDados;

    function Valor(const ANome: string): TDado;
  published
    property Dataset : TDataset read FDataset write SetDataset;
    property Dados   : TDados   read FDados   write FDados;
    property Mascara : Char     read FMascara write FMascara;
    property Chave   : Word     read FChave   write FChave;

    property onCriptografar: TOnCriptografarCampos read FOnCriptografar write FOnCriptografar;
  end;

procedure Register;

implementation


procedure Register;
begin
  RegisterComponents('iNoveFast', [TLGPD]);
end;

function TLGPD.DadoExists(const AField: TField): Boolean;
var
  FDadoIndex : Integer;
begin
  Result := False;

  for FDadoIndex := 0 to (Self.Dados.Count -1) do
    if AField.FieldName = Self.Dados.Items[FDadoIndex].Field.FieldName then
    begin
      Result := True;
      Break;
    end;
end;

function TDado.Decifrar: string;
begin
  Result := '';

  if not Assigned(Self.Field) then
    Exit;

  if Self.Field.IsNull then
    Exit;

  Result := DecryptStr(Self.Field.AsString, Self.Chave);
end;

function TDado.GetCriptografado: string;
var
  oValue: string;
begin
  Result  := '';

  if not Assigned(Self.Field) then
    Exit;

  if Self.Field.IsNull then
    Exit;

  FCriptografado := Self.Field.AsString;
  Result := EncryptStr(FCriptografado, Self.Chave);
end;

function TDado.GetDisplayName: string;
begin
  Result := Nome;
  if Result = '' then
    Result := inherited GetDisplayName;
end;

procedure TDado.SetNome(const Value: string);
begin
  if FNome <> Value then
    FNome := Value;
end;

{ TDados }
function TDados.Add: TDado;
begin
  Result := TDado(inherited Add);
end;

constructor TDados.Create(ALGPD: TLGPD);
begin
  inherited Create(TDado);

  FLGPD := ALGPD;
end;

function TDados.GetItem(Index: Integer): TDado;
begin
  Result := TDado(inherited GetItem(Index));
end;

function TDados.GetOwner: TPersistent;
begin
  Result := FLGPD;
end;

procedure TDados.SetItem(Index: Integer; Value: TDado);
begin
  inherited SetItem(Index, Value);
end;

{ TLGPD }
procedure TLGPD.AdicionarDados;
var
  FFieldIndex: TField;
  FDadoIndex : Integer;
begin
  if not Assigned(FDados) then
    FDados := TDados.Create(Self);

  if Dados.Count > 0 then
    Exit;

  for FFieldIndex in FDataset.Fields do
    with Dados.Add do
    begin
      Field := FFieldIndex;
      Nome  := FFieldIndex.FieldName;
      Chave := Self.Chave;
      Criptografar := True;
    end;
end;

constructor TLGPD.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FDados := TDados.Create(Self);
  Self.Mascara := '*';
  Self.Chave   := 223;
end;

procedure TLGPD.CriptografarDados;
var
  oDado: TDado;
  oField: TField;
begin
  if not Assigned(Self.Dataset) then
    Exit;

  if Self.Dados.Count <= 0  then
    Exit;

  try
    Self.Dataset.DisableControls;
    Self.Dataset.First;

    while not Self.Dataset.Eof do
    begin
      Self.Dataset.Edit;
      for oField in Self.Dataset.Fields do
      begin
        oDado := GetDado(oField.FieldName);
        if Assigned(oDado) then
        begin
          if oDado.Criptografar then
          begin
            if TField(oDado.Field).DataType in [ftString, ftWideString, ftMemo, ftFmtMemo] then
              oField.Value := oDado.Criptografado;
          end;
        end;
      end;
      Self.Dataset.Post;

      Self.Dataset.Next;
    end;
  finally
    Self.Dataset.First;
    Self.Dataset.EnableControls;
  end;

  if Assigned(FOnCriptografar) then
    FOnCriptografar(Self.Dados);
end;

procedure TLGPD.DecifrarDados;
var
  oDado: TDado;
  oField: TField;
begin
  if not Assigned(Self.Dataset) then
    Exit;

  if Self.Dados.Count <= 0  then
    Exit;
  try
    Self.Dataset.DisableControls;
    Self.Dataset.First;

    while not Self.Dataset.Eof do
    begin
      Self.Dataset.Edit;
      for oField in Self.Dataset.Fields do
      begin
        oDado := GetDado(oField.FieldName);
        if Assigned(oDado) then
        begin
          if oDado.Criptografar then
            if TField(oDado.Field).DataType in [ftString, ftWideString, ftMemo, ftFmtMemo] then
              oField.Value := oDado.Decifrar;
        end;
      end;
      Self.Dataset.Post;

      Self.Dataset.Next;
    end;
  finally
    Self.Dataset.First;
    Self.Dataset.EnableControls;
  end;
end;

destructor TLGPD.Destroy;
begin
  FDados.Free;

  inherited Destroy;
end;

function TLGPD.GetDado(const AFieldName: string): TDado;
var
  FResultIndex : Integer;
begin
  Result := nil;
  for FResultIndex := 0 to (Self.Dados.Count -1) do
    if AFieldName = Self.Dados.Items[FResultIndex].Field.FieldName then
    begin
      Result := Self.Dados.Items[FResultIndex];
      Break;
    end;
end;

procedure TLGPD.MascararDados;
var
  FFieldIndex: TField;
begin
  if not Assigned(FDados) then
    FDados := TDados.Create(Self);

  for FFieldIndex in FDataset.Fields do
    if DadoExists(FFieldIndex) then
        FFieldIndex.OnGetText := SetLGPDValue;

  FDataset.First;
  FDataset.Last;
  FDataset.First;
end;

procedure TLGPD.RemoverMascaras;
var
  FFieldIndex: TField;
begin
  if not Assigned(FDados) then
    FDados := TDados.Create(Self);

  for FFieldIndex in FDataset.Fields do
    if DadoExists(FFieldIndex) then
        FFieldIndex.OnGetText := nil;

  FDataset.First;
  FDataset.Last;
  FDataset.First;
end;

procedure TLGPD.SetDataset(const Value: TDataset);
begin
  FDataset := Value;

  if not Assigned(FDataset) then
  begin
    if Assigned(FDados) then
      Self.Dados.ClearAndResetID;

    Exit;
  end;

  AdicionarDados;
end;

procedure TLGPD.SetItems(Value: TDados);
begin
  FDados.Assign(Value);
end;

procedure TLGPD.SetLGPDValue(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  if not Sender.IsNull then
    Text := StringOfChar(Self.Mascara, Sender.Size);
end;

function TLGPD.Valor(const ANome: string): TDado;
begin
  Result := GetDado(ANome);
end;

end.
