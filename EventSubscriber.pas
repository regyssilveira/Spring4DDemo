unit EventSubscriber;

interface

uses
  Spring,
  System.Classes;


type
  TPositionEvent = procedure(x, y: Integer) of object;

  TEventSubscriber = class(TComponent)
  private
    FOnUpdate: Event<TPositionEvent>;
    function GetOnUpdate: IEvent<TPositionEvent>;
  public
    procedure HandleMouseMove(Sender: TObject; ShiftState: TShiftState; X, Y: Integer);

    property OnUpdate: IEvent<TPositionEvent> read GetOnUpdate;
  end;

implementation

{ TEventSubscriber }

function TEventSubscriber.GetOnUpdate: IEvent<TPositionEvent>;
begin
  Result := FOnUpdate;
end;

procedure TEventSubscriber.HandleMouseMove(Sender: TObject;
  ShiftState: TShiftState; X, Y: Integer);
begin
  FOnUpdate.Invoke(X, Y);
end;

end.
