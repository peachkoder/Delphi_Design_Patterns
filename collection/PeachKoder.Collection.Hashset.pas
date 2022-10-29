{*******************************************************}
{                                                       }
{                  DELPHI STRUCTURES                    }
{                                                       }
{                 CATEGORY : GENERICS                   }
{                                                       }
{                   TYPE  : HASHSET                     }
{                                                       }
{                                                       }
{*******************************************************}
{                                                       }
{    HASHSET is a structure present in many other       }
{  languages like Java. It's a kind of list that don't  }
{  permit duplicate values of any kind.                 }
{                                                       }
{    Under the hood Hashset uses hashcode to order      }
{  its items, so the order is not garanted. You cannot  }
{  navigate thougout items using an index like TList.   }
{                                                       }
{    The major use of this struct is when we need a     }
{  list of unique items. It's faster than TList.        }
{                                                       }
{    USE:                                               }
{                                                       }
{    var list: ISet<String> := THashSet<String>.Create  }
{    list.Include('Some String');                       }
{    list.Include('Some New String');                   }
{    list.Include('Some String');                       }
{                                                       }
{    WriteLn(list.ToString());                          }
{                                                       }
{    // Writeln prints                                  }
{    'Some String', 'Some New String'                   }
{                                                       }
{    ----------------------------------------------     }
{    NOTE:                                              }
{                                                       }
{    ToString Function is Abstract so must be           }
{  implemented in subclasses of THashSet to provide     }
{  this functionality.                                  }
{                                                       }
{    If you use this structure like following example   }
{  you must call Free or FreeAndNil method in order     }
{  to unload the object from memory avoiding memory     }
{  leak.                                                }
{                                                       }
{    var list := THashSet<String>.Create;               }
{    (...)                                              }
{    FreeAndNil(list);                                  }
{                                                       }
{                                                       }
{*******************************************************}


unit PeachKoder.Collection.Hashset;

interface

uses
  System.Generics.Collections
  ,System.SysUtils
  ,System.TypInfo
  ;

type

  ISet<T> = interface
  ['{9B48692F-EC77-4D95-BC3B-801BDE9AA9F8}']
    procedure Include(const Item: T);
    procedure Exclude(const Item: T);
    function Contains(const Item: T): Boolean;
    function ToString(): String;
  end;

  THashSet<T> = class(TInterfacedObject, ISet<T>)
  strict private
    FMap: TDictionary<T, Boolean>;
    function GetKeys: TArray<T>;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Include(const Item: T);
    procedure Exclude(const Item: T);
    function Contains(const Item: T): Boolean;
    property Items: TArray<T> read GetKeys;

  end;

implementation

{ THashSet<T> }

function THashSet<T>.Contains(const Item: T): Boolean;
begin
  Result := FMap.ContainsKey(Item);
end;

constructor THashSet<T>.Create;
begin
  FMap:= TDictionary<T, boolean>.Create;
end;

destructor THashSet<T>.Destroy;
begin
  FreeAndNil(FMap);
  inherited;
end;

procedure THashSet<T>.Exclude(const Item: T);
begin
  FMap.Remove(Item);
end;

function THashSet<T>.GetKeys: TArray<T>;
var arrT: TArray<T>;
    i: integer;
begin
  i := 0;
  SetLength(arrT, FMap.Count);
  var enumerator := FMap.Keys.GetEnumerator();
  while (enumerator.MoveNext) do
  begin
     arrT[i] := enumerator.Current;
     inc(i);
  end;
  FreeAndNil(enumerator);
  Exit(arrT);
end;

procedure THashSet<T>.Include(const Item: T);
begin
  FMap.AddOrSetValue(Item, false);
end;

end.
