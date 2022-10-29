{*******************************************************}
{                                                       }
{              DESIGN PATTERNS IN DELPHI                }
{                                                       }
{              CATEGORY : RESPONSABILITY                }
{                                                       }
{                   TYPE  : OBSERVER                    }
{                                                       }
{                                                       }
{*******************************************************}
{                                                       }
{    EXAMPLE:                                           }
{                                                       }
{    TEquipamentManager gatther data from weather.      }
{    It's a kind of ligth sensor that updates its       }
{  own status based in amount of external light.        }
{                                                       }
{    The Equipament Manager update all the observers    }
{  listed in its FObservers list when the luminosity    }
{  changes then Observers act based on data sent by     }
{  Manager.                                             }
{                                                       }
{*******************************************************}

unit PeachKoder.Structs.Observer;

interface

uses System.SysUtils
     , Generics.Collections;

type

  TLuminosity = (DAY, NIGHT);

  IObserver<T> = interface
    ['{BA511EE2-DAD5-4EFA-A0FB-FBA0CA5C089B}']
    procedure Update(Data : T);
  end;

  // Observer - light equipamment
  TLight = class(TInterfacedObject, IObserver<TLuminosity>)
    procedure Update(Data :TLuminosity) ;
  end;

  // Observer - gate equipamment
  TGate = class(TInterfacedObject, IObserver<TLuminosity>)
    procedure Update(Data :TLuminosity) ;
  end;

  // Manager - broadcaster.
  TEquipamentManager = class(TInterfacedObject, IInterface)
  private
    FObservers: TList<IObserver<TLuminosity>>;
  public
    constructor Create ;
    destructor Destroy; override;
    procedure AddObserver(Observer: IObserver<TLuminosity>);
    procedure ChangeLuminosity(Luminosity: TLuminosity);
  end;

implementation

{ TLight }

procedure TLight.Update;
begin
  if Data = DAY then
   WriteLn('Open the gates')
  else
   WriteLn('Close the gates');
end;

{ TGate }

procedure TGate.Update;
begin
  if Data = DAY then
   WriteLn('Turn the ligths OFF')
  else
   WriteLn('Turn the ligths ON');
end;

{ TEquipamentManager }

procedure TEquipamentManager.AddObserver(Observer:  IObserver<TLuminosity>);
begin
  if not FObservers.Contains(Observer) then
    FObservers.Add(Observer);
end;

procedure TEquipamentManager.ChangeLuminosity(Luminosity: TLuminosity);
begin
   for var observer in FObservers do
   begin
     observer.Update(Luminosity);
   end;
end;

constructor TEquipamentManager.Create;
begin
  FObservers := TList<IObserver<TLuminosity>>.Create;
end;

destructor TEquipamentManager.Destroy;
begin
  FreeAndNil(FObservers);
  inherited;
end;

end.
