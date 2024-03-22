unit Main;

interface

uses
  Spring,
  Spring.Collections,

  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
  private
    FOnEventMouseMove: Event<TMouseMoveEvent>;
    procedure ChangeCaption(X, Y: Integer);
    procedure ChangeColor(X, Y: Integer);
    procedure NotifyEventChange(Sender: TObject);
  public

  end;

  TStringsHelper = class helper for TStrings
    procedure AddBlankLine;
  end;

  TDateTimeHelper = record helper for TDateTime
    function ToString: string;
  end;

  TNullableDateTimeHelper = record helper for TNullableDateTime
    function AsDateTimeStr: string;
  end;

var
  Form1: TForm1;

implementation

uses
  EventSubscriber;

{$R *.dfm}

{ TStringsHelper }

procedure TStringsHelper.AddBlankLine;
begin
  Self.Add(EmptyStr);
end;

{ TNullableDateTimeHelper }

function TNullableDateTimeHelper.AsDateTimeStr: string;
begin
  if Self.HasValue then
    Result := DAteTimeToStr(Self)
  else
    Result := EmptyStr;
end;

{ TDateTimeHelper }

function TDateTimeHelper.ToString: string;
begin
  Result := DateTimeToStr(Self);
end;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;

  SetLength(TrueBoolStrs, 1);
  TrueBoolStrs := ['Verdadeiro'];

  SetLength(FalseBoolStrs, 1);
  FalseBoolStrs := ['Falso'];

  Memo1.Clear;
end;


{$region 'Nullable'}

procedure TForm1.Button1Click(Sender: TObject);
var
  Data: TNullableDateTime;
begin
  Data := nil;
  Memo1.Lines.Add('Conteudo da variavel: ' + Data.ToString);
  Memo1.Lines.Add('Possui valor? ' + Data.HasValue.ToString(TUseBoolStrs.True));
  Memo1.Lines.Add('Com Valor Default? ' + Data.GetValueOrDefault.ToString);
  Memo1.Lines.Add('Com Valor Default por parametro? ' + Data.GetValueOrDefault(Now).ToString);
  Memo1.Lines.AddBlankLine;

  Data := Now;
  Memo1.Lines.Add('Conteudo da variavel: ' + Data.ToString);
  Memo1.Lines.Add('Possui valor? ' + Data.HasValue.ToString(TUseBoolStrs.True));
  Memo1.Lines.Add('Conversão direta: ' + Data.AsDateTimeStr);
  Memo1.Lines.Add('Conversão usando Value: ' + Data.Value.ToString);
  Memo1.Lines.AddBlankLine;

end;

{$endregion}

{$region 'Event'}

procedure TForm1.ChangeCaption(X, Y: Integer);
begin
  Self.Caption := Format('Coordenada %d - %d', [X, Y]);
end;

procedure TForm1.ChangeColor(X, Y: Integer);
begin
  if Y > 300 then
    Memo1.Color := clBlue
  else
    Memo1.Color := clWhite;
end;

procedure TForm1.NotifyEventChange(Sender: TObject);
begin
  ShowMessage('Alterado');
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  Subscriber: TEventSubscriber;
begin
  Subscriber := TEventSubscriber.Create(Self);
  FOnEventMouseMove.Add(Subscriber.HandleMouseMove);
  Subscriber.OnUpdate.Add(ChangeCaption);
  Subscriber.OnUpdate.Add(ChangeColor);

  Memo1.OnMouseMove := FOnEventMouseMove;
  FOnEventMouseMove.OnChanged := NotifyEventChange;
end;

{$endregion}

{$region 'Shared'}

procedure TForm1.Button3Click(Sender: TObject);
var
  sl: Shared<TStringList>;          // record
begin
  sl := TStringList.Create;         // criação normal
  sl.Value.Add('texto qualquer');   // não se acessa diretamente, mas utilizando o value

  Memo1.Lines.AddStrings(sl);
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  sl: IShared<TStringList>;               // interface
begin
  sl := Shared.Make(TStringList.Create);  // criação via metodo
  sl.Add('texto qualquer 2');             // acesso normal ao objeto

  Memo1.Lines.AddStrings(sl);
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  sl: IShared<TStrings>;
begin
  sl := Shared.Make<TStrings>(TStringList.Create,
    procedure(const s: TStrings)  // finalizer - executado ao finalizar
    begin
      if not(Memo1.Lines[Memo1.Lines.Count - 1].Trim.IsEmpty) then
        Memo1.Lines.AddBlankLine;

      Memo1.Lines.AddStrings(s);
      Memo1.Lines.AddBlankLine;

      ShowMessage(Format('adicionado %d linha(s)', [s.Count]));
      s.Free;
    end
  );

  sl.Add('texto qualquer 3 #1');
  sl.Add('texto qualquer 3 #2');
  sl.Add('texto qualquer 3 #3');
  sl.Add('texto qualquer 3 #4');
  sl.Add('texto qualquer 3 #5');
  sl.Add('texto qualquer 3 #6');

  // ao terminar o metodo, o objeto sl será limpo da memoria,
  // então o finalizer será chamado, como a adição das strings ao memo está
  // dentro do finalizer, somente nesse momento veremos as strings adicionadas
end;

procedure TForm1.Button6Click(Sender: TObject);
var
  sl: TStringList;
  WeakRef: Weak<TStrings>;
begin
  Memo1.Lines.AddBlankLine;

  sl := TStringList.Create;
  try
    WeakRef := sl;
    sl.Add('Texto qualquer 4');

    Memo1.Lines.Add('IsAlive: ' + WeakRef.IsAlive.ToString(TUseBoolStrs.True));
    Memo1.Lines.AddStrings(WeakRef);
    Memo1.Lines.AddBlankLine;
  finally
    sl.Free;
  end;

  Memo1.Lines.Add('IsAlive: ' + WeakRef.IsAlive.ToString(TUseBoolStrs.True));
  Memo1.Lines.Add('Assigned: ' + Assigned(WeakRef.Target).ToString(TUseBoolStrs.True));
  Memo1.Lines.Add('dif. nil: ' + (WeakRef <> nil).ToString(TUseBoolStrs.True));
end;

{$endregion}

{$region 'enumerados'}

procedure TForm1.Button7Click(Sender: TObject);
var
  Numbers: IEnumerable<Integer>;
  OddNumbers: IEnumerable<Integer>;
  I: Integer;
begin
  Numbers := TEnumerable.Range(1, 10);
  for i in Numbers do
    Memo1.Lines.Add(i.ToString);
  Memo1.Lines.AddBlankLine;

  OddNumbers := Numbers.Where(
    function (const n: Integer): Boolean
    begin
      Result := Odd(n);
    end
  );

  for i in OddNumbers do
    Memo1.Lines.Add(i.ToString);
  Memo1.Lines.AddBlankLine;

  Memo1.Lines.Add('Primeiro: ' + OddNumbers.First.ToString);
  Memo1.Lines.Add('Ultimo: ' + OddNumbers.Last.ToString);

end;

procedure TForm1.Button8Click(Sender: TObject);
var
  List: IList<Integer>;
  OddNumbers: IEnumerable<Integer>;
  I: Integer;
begin
  List := TCollections.CreateList<Integer>([4,5,6]);
  List.AddRange([1,2,3]);
  List.InsertRange(0, [10,11,12]);

  Memo1.Lines.Add('Lista');
  for i in List do
    Memo1.Lines.Add(i.ToString);
  Memo1.Lines.AddBlankLine;

  OddNumbers := List.Where(
    function (const n: Integer): Boolean
    begin
      Result := Odd(n);
    end
  );

  for i in OddNumbers do
    Memo1.Lines.Add(i.ToString);
  Memo1.Lines.AddBlankLine;

  Memo1.Lines.Add('Primeiro: ' + OddNumbers.First.ToString);
  Memo1.Lines.Add('Ultimo: ' + OddNumbers.Last.ToString);
end;

{$endregion}

end.
