{*******************************************************}
{                                                       }
{              DESIGN PATTERNS IN DELPHI                }
{                                                       }
{                CATEGORY : STRUCTURAL                  }
{                                                       }
{                   TYPE  : BRIDGE                      }
{                                                       }
{                                                       }
{*******************************************************}
{                                                       }
{    For the Bridge pattern, an element is defined      }
{  in two parts: an abstraction and an implementation.  }
{  The implementation is the class that does all the    }
{  real work.                                           }
{                                                       }
{    EXAMPLE:                                           }
{                                                       }
{    The OrderedListImpl class implements ListImpl, and }
{  stores list entries in an internal TList object.     }
{                                                       }
{    The abstraction represents the operations on the   }
{  list that are available to the outside world.        }
{  The BaseList class provides general list             }
{  capabilities.                                        }
{                                                       }
{    Note that all the operations are delegated to the  }
{  FImplementor field, which represents the list        }
{  implementation. Whenever operations are requested    }
{  of the List, they are actually delegated             }
{  “across the bridge” to the associated ListImpl       }
{  object.                                              }
{                                                       }
{    BaseList — you subclass the BaseList and add       }
{  additional functionality. The NumberedList class     }
{  demonstrates the power of the Bridge; by overriding  }
{  the get method, the class is able to provide         }
{  numbering of the items on the list.                  }
{                                                       }
{    The OrnamentedList class shows another             }
{  abstraction. In this case, the extension allows      }
{  each list item to be prepended with a designated     }
{  symbol, such as an asterisk or other character.      }
{                                                       }
{*******************************************************}

unit PeachKoder.Pattern.Bridge;

interface

uses
  Generics.Collections
  , System.SysUtils
  ;

type

  IListImpl =  interface
    procedure AddItem(Item: String); overload;
    procedure AddItem(Item: String; Position: UInt32); overload;
    procedure RemoveItem(Item: String);
    function GetNumberOfItems(): UInt32;
    function GetItem(Index: Integer): String;
    function SupportsOrdering(): Boolean;
  end;

  TOrderedListImpl = class(TInterfacedObject, IListImpl)
  strict private
    FList: TList<String>;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddItem(Item: String); overload;
    procedure AddItem(Item: String; Position: UInt32); overload;
    procedure RemoveItem(Item: String);
    function GetNumberOfItems(): UInt32;
    function GetItem(Index: Integer): String;
    function SupportsOrdering(): Boolean;
  end;

  TBaseList = class(TInterfacedObject, IInterface)
  protected
    FImplementor: IListImpl;
  public
    constructor Create(Implementor: IListImpl);
    procedure Add(Item: String); overload;
    procedure Add(Item: String; Position: UInt32); overload;
    procedure Remove(Item: String);
    function  Get(Index: Integer): String; virtual;
    function Count(): Integer;
  end;

  TNumberList = class(TBaseList)
  public
    function  Get(Index: Integer): String; override;
  end;

  TOrnamentedList = class(TBaseList)
  strict private
    FItemType: Char;
  private
    procedure SetItemType(const Value: Char);
  public
    function  Get(Index: Integer): String; override;
    property ItemType: Char read FItemType write SetItemType;
  end;

implementation

{ TListImpl }

{$REGION 'TListImpl'}
  procedure TOrderedListImpl.AddItem(Item: String; Position: UInt32);
  begin
    if FList.Contains(Item) then exit;
    FList.Insert(Position, Item);
  end;

  constructor TOrderedListImpl.Create;
  begin
    FList := TList<String>.Create;
  end;

  destructor TOrderedListImpl.Destroy;
  begin
    FreeAndNil(FList);
    inherited;
  end;

  procedure TOrderedListImpl.AddItem(Item: String);
  begin
    if FList.Contains(Item) then exit;
    FList.Add(Item);
  end;

  function TOrderedListImpl.GetItem(Index: Integer): String;
  begin
    Result := '';
    if (Index <= FList.Count - 1) then
      Result := FList.Items[Index ];
  end;

  function TOrderedListImpl.GetNumberOfItems: UInt32;
  begin
    Result := FList.Count;
  end;

  procedure TOrderedListImpl.RemoveItem(Item: String);
  begin
      FList.Remove(Item);
  end;

  function TOrderedListImpl.SupportsOrdering: Boolean;
  begin
    Result := True;
  end;
{$ENDREGION}

{ TBaseList }

{$REGION 'TBaseList'}
  procedure TBaseList.Add(Item: String);
  begin
    FImplementor.AddItem(Item)
  end;

  procedure TBaseList.Add(Item: String; Position: UInt32);
  begin
    FImplementor.AddItem(Item, Position)
  end;

  function TBaseList.Count: Integer;
  begin
    Result := FImplementor.GetNumberOfItems
  end;

  constructor TBaseList.Create(Implementor: IListImpl);
  begin
    FImplementor := Implementor;
  end;

function TBaseList.Get(Index: Integer): String;
  begin
    Result := FImplementor.GetItem(Index)
  end;

  procedure TBaseList.Remove(Item: String);
  begin
    FImplementor.RemoveItem(Item)
  end;
{$ENDREGION}

{ TNumberList }

function TNumberList.Get(Index: Integer): String;
var item: String;
begin
  item := inherited Get(Index);
  Result := Format('%d.%s', [Index + 1, item]);
end;

{ TOrnamentedList }

function TOrnamentedList.Get(Index: Integer): String;
var item: String;
begin
  item := inherited Get(Index);
  Result := Format('%s%s', [FItemType, item]);
end;

procedure TOrnamentedList.SetItemType(const Value: Char);
begin
  if Value > Char(' ') then
    FItemType := Value;
end;

end.



