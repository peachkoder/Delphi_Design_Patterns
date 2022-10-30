{*******************************************************}
{                                                       }
{              DESIGN PATTERNS IN DELPHI                }
{                                                       }
{                CATEGORY : STRUCTURAL                  }
{                                                       }
{                  TYPE  : DECORATOR                    }
{                                                       }
{                                                       }
{*******************************************************}
{                                                       }
{    The struct of decorator pattern has 4 components:  }
{                                                       }
{    Component: Represents the component containing     }
{               generic behavior. It can be a abstract  }
{               class or an interface.                  }
{                                                       }
{    Decorator: Defines the standart behavior of all    }
{               decorators. It can be an abstract class }
{               or an interface. It holds a reference   }
{               to a Component, which can be a          }
{               ConcreteComponent or another Decorator. }
{                                                       }
{    ConcreteDecorator: Subclass of Deccorator. Each    }
{               needs to support chaining (reference    }
{               to a component, plus the ability to add }
{               and remove that reference)              }
{                                                       }
{    EXAMPLE:                                           }
{                                                       }
{    In this example we want to create a weapon for a   }
{  game. The weapon can be upgraded using decorators.   }
{                                                       }
{    IWeapon is the Component.                          }
{                                                       }
{    TWeapon is the ConcretComponent                    }
{                                                       }
{    TWeaponDecorator is the Decorator.                 }
{                                                       }
{    TBazzoka and THairliner are the ConcreteDecorators }
{                                                       }
{                                                       }
{*******************************************************}

unit PeachKoder.Pattern.Decorator;

interface

type

  IWeapon = interface
     procedure Shoot;
     function Power: Integer;
     function Ammunition: Integer;
     function ReloadTime: UInt16;
  end;

  TWeapon = class(TInterfacedObject, IWeapon)
  strict private
    FPower      : Integer;
    FAmmunition : Integer;
    FReloadTime : UInt16;
    procedure Shoot;
  protected
    function Power: Integer;
    function Ammunition: Integer;
    function ReloadTime: UInt16;
  public
    constructor Create;
  end;

  TWeaponDecorator = class(TInterfacedObject, IWeapon)
  strict private
    FWeapon: IWeapon;
  protected
    procedure Shoot;virtual;abstract;
    function Power: Integer;virtual;abstract;
    function Ammunition: Integer;virtual;abstract;
    function ReloadTime: UInt16;virtual;abstract;
  public
    constructor Create(Weapon: IWeapon);
    property Weapon: IWeapon read FWeapon write FWeapon;
  end;

  TBazooka = class(TWeaponDecorator)
  protected
    procedure Shoot;override;
  public
    function Power: Integer; override;
    function Ammunition: Integer; override;
    function ReloadTime: UInt16; override;
  end;

  THairLine = class(TWeaponDecorator)
  protected
    procedure Shoot;override;
  public
    function Power: Integer;override;
    function Ammunition: Integer; override;
    function ReloadTime: UInt16; override;
  end;

  TLaser = class(TWeaponDecorator)
  protected
    procedure Shoot;override;
  public
    function Power: Integer; override;
    function Ammunition: Integer; override;
    function ReloadTime: UInt16; override;
  end;


implementation

uses System.SysUtils;

{ TWeapon }

{$REGION 'TWeapon'}
  function TWeapon.Ammunition: Integer;
  begin
    result := FAmmunition;
  end;

  constructor TWeapon.Create;
  begin
    FPower := 1;
    FAmmunition := 100;
    FReloadTime := 10; //seconds
  end;

  function TWeapon.Power: Integer;
  begin
    result := FPower;
  end;

  function TWeapon.ReloadTime: UInt16;
  begin
    result := FReloadTime;
  end;


procedure TWeapon.Shoot;
begin
  WriteLn('Weapon Shoot!');
end;

{$ENDREGION}

{ TWeaponDecorator }

constructor TWeaponDecorator.Create(Weapon: IWeapon);
begin
  FWeapon  := Weapon;
end;

{ TBazooka }

{$REGION 'TBazooka'}
  function TBazooka.Ammunition: Integer;
  var ammu: Integer;
  begin
    ammu := Weapon.Ammunition;
    if ammu > 10 then
      ammu := 10;

    Result := ammu;
  end;

  function TBazooka.Power: Integer;
  begin
    Result := Weapon.Power * 3;
  end;

  function TBazooka.ReloadTime: UInt16;
  begin
    Result := 30;
  end;

  procedure TBazooka.Shoot;
  begin
    Writeln('Bazooka is ready...');
    Self.Weapon.Shoot;
  end;
{$ENDREGION}

{ THairLiner }

{$REGION 'THairLiner'}
  function THairLine.Ammunition: Integer;
  begin
     Result := Weapon.Ammunition;
  end;

  function THairLine.Power: Integer;
  begin
     Result := Weapon.Power;
  end;

  function THairLine.ReloadTime: UInt16;
  begin
     Result := Weapon.ReloadTime div 2;
  end;

  procedure THairLine.Shoot;
  begin
    Writeln('With Hairline is 2x more precise...');
    Self.Weapon.Shoot;
  end;
{$ENDREGION}

{ TLaser }

{$REGION 'TLaser'}
  function TLaser.Ammunition: Integer;
  begin
    Result := Weapon.Ammunition * 5;
  end;

  function TLaser.Power: Integer;
  begin
    Result := Weapon.Power * 10;
  end;

  function TLaser.ReloadTime: UInt16;
  begin
    Result := 20;
  end;

  procedure TLaser.Shoot;
  begin
    Writeln('Laser reloading...');
    Weapon.Shoot;
  end;
{$ENDREGION}

end.
