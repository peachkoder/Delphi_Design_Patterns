{*******************************************************}
{                                                       }
{              DESIGN PATTERNS IN DELPHI                }
{                                                       }
{              CATEGORY : RESPONSABILITY                }
{                                                       }
{                   TYPE  : MONITOR                     }
{                                                       }
{                                                       }
{*******************************************************}
{                                                       }
{     THIS UNIT EXAMPLIFIES THE MONITOR PATTERN.        }
{                                                       }
{     IT WAS INCLUDED SOME ADVANCED CONCEPTS IN THIS    }
{  EXAMPLE LIKE GENERICS, GENERICS EVENTS AND GENERIC   }
{  INTERFACES.                                          }
{                                                       }
{     THIS EXAMPLE COULD BE EVEN BETTER IF WE'VE        }
{  INCLUDED DEPENDECY INJECTION, INVERSION OF CONTROL,  }
{  BUT FOR SAKE OF SIMPLICITY THESE CONCEPTS WERE       }
{  LEFT OUT.                                            }
{                                                       }
{                                                       }
{    EXAMPLE:                                           }
{                                                       }
{    In this example we try to match a real world       }
{  situation. There are Sensors, Gears and the Monitor  }
{                                                       }
{  Sensors: Fire sensor, if it detects high temperature }
{           or smoke an event is triggered.             }
{           Weather sensor. Detects if is raining or    }
{           not.                                        }
{                                                       }
{  Gears  : Windows, Doors and Lights act after the     }
{           Monitor have sent data that came from the   }
{           sensors.                                    }
{                                                       }
{  Monitor: Centralize and distribute data across the   }
{           system. It's notified by sensors events     }
{           after that It broadcasts data to the        }
{           gears registered.                           }
{                                                       }
{*******************************************************}

unit PeachKoder.Monitor;

interface

uses System.SysUtils
     , Generics.Collections;

type
   
  // SENSORS -----------------------------------------------------------

  TFireSignal     = (FS_OFF, FS_ON, FS_UNKNOWN);
  TWeatherSignal  = (WS_DRY, WS_WET, WS_UNKNOWN);
  TSensorEvent<T> = procedure (Sender: TObject; Data: T) of object;

  ISensor<T> = interface
  ['{C4662580-41A8-47D3-82D9-E93DEBED59CC}']
    procedure SendData(Data: T);
  end;

  TSensor<T> = class(TInterfacedObject, ISensor<T>)
  strict private
    FEvent: TSensorEvent<T>;
  public
    procedure SendData(Data: T);
    property Event: TSensorEvent<T> read FEvent write FEvent;
  end;

  TFireSensor = class(TSensor<TFireSignal>)
  public
    procedure SendData(Data: TFireSignal);
  end;

  TWeatherSensor = class(TSensor<TWeatherSignal>)
  public
    procedure SendData(Data: TWeatherSignal);
  end;

  // GEARS -------------------------------------------------------------

  TMechanicalGearAction = (MG_OPEN, MG_CLOSED, MG_UNKNOWN);
  TEletricalGearAction  = (EG_ON, EG_OFF, EG_UNKNOWN);

  IGear<T> = interface
  ['{D63EDECB-1810-4E0F-AFF3-D5D15BCB4763}']
    procedure Update(Data: T);
  end;

  TGear<T> = class(TInterfacedObject, IGear<T>)
  private
    FName: String;
  public
    constructor Create(Name: String);
    procedure Update(Data: T);virtual; abstract;
    property Name: String read FName;
  end;

  TDoor = class(TGear<TMechanicalGearAction>)
  public
    procedure Update(Data: TMechanicalGearAction); override;
  end;

  TWindow = class(TGear<TMechanicalGearAction>)
  public
    procedure Update(Data: TMechanicalGearAction); override;
  end;

  TLight = class(TGear<TEletricalGearAction>)
  public
    procedure Update(Data: TEletricalGearAction); override;
  end;

  // MONITOR -----------------------------------------------------------

  IMonitor = interface
    ['{4D85AE4D-B9EF-448A-AB61-3451E10BF581}']
    procedure AddSensor(Sensor: ISensor<TFireSignal> ); overload;
    procedure AddSensor(Sensor: ISensor<TWeatherSignal> ); overload;
    procedure AddMechanical(Mechanical: array of IGear<TMechanicalGearAction> );
    procedure AddEletrical(Eletrical: array of IGear<TEletricalGearAction> );
  end;

  TMonitor = class(TInterfacedObject, IMonitor)
  strict private
    FMechanicalGearList:  TList<IGear<TMechanicalGearAction>>;
    FEletricalGearList:   TList<IGear<TEletricalGearAction>>;

    FWeatherSensor: TWeatherSensor;
    FFireSensor: TFireSensor;

    procedure FireEvent(Sender: TObject; Data: TFireSignal);
    procedure WeatherEvent(Sender: TObject; Data: TWeatherSignal);
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddSensor(Sensor: ISensor<TFireSignal> ); overload;
    procedure AddSensor(Sensor: ISensor<TWeatherSignal> ); overload;
    procedure AddMechanical(Mechanical: array of IGear<TMechanicalGearAction> );
    procedure AddEletrical(Eletrical: array of IGear<TEletricalGearAction> );
  end;

implementation


{ TMonitor }

procedure TMonitor.AddEletrical(
  Eletrical: array of IGear<TEletricalGearAction>);
begin
  for var I := 0 to High(Eletrical) do
  begin
    if (not FEletricalGearList.Contains(Eletrical[i]) ) then
      FEletricalGearList.Add(Eletrical[i]);
  end;
end;

procedure TMonitor.AddMechanical(
  Mechanical: array of IGear<TMechanicalGearAction>);
begin
  for var I := 0 to High(Mechanical) do
  begin
    if (not FMechanicalGearList.Contains(Mechanical[i]) ) then
      FMechanicalGearList.Add(Mechanical[i]);
  end;
end;

procedure TMonitor.AddSensor(Sensor: ISensor<TWeatherSignal>);
begin
  FWeatherSensor := TWeatherSensor(Sensor);
  FWeatherSensor.Event := WeatherEvent;
end;

procedure TMonitor.AddSensor(Sensor: ISensor<TFireSignal>);
begin
  FFireSensor := TFireSensor(Sensor);
  FFireSensor.Event := FireEvent;
end;

constructor TMonitor.Create;
begin
  FMechanicalGearList:=  TList<IGear<TMechanicalGearAction>>.Create;
  FEletricalGearList:=   TList<IGear<TEletricalGearAction>>.Create;
end;

destructor TMonitor.Destroy;
begin
  FreeAndNil(FMechanicalGearList);
  FreeAndNil(FEletricalGearList);
  inherited;
end;

procedure TMonitor.FireEvent(Sender: TObject; Data: TFireSignal);
var Action: TEletricalGearAction;
begin
  case Data of
    FS_OFF: Action := EG_ON ;
    FS_ON: Action := EG_OFF ;
    else Action := EG_UNKNOWN ;
  end;
  for var eletrical in FEletricalGearList do
    eletrical.Update(Action);
end;

procedure TMonitor.WeatherEvent(Sender: TObject; Data: TWeatherSignal);
var Action: TMechanicalGearAction;
begin
  case Data of
    WS_DRY: Action := MG_OPEN ;
    WS_WET: Action := MG_CLOSED ;
    else Action := MG_UNKNOWN ;
  end;
  for var mechanical in FMechanicalGearList do
    mechanical.Update(Action);
end;

{ TGear<T> }

constructor TGear<T>.Create(Name: String);
begin
   FName := Name;
end;

{ TDoor }

procedure TDoor.Update(Data: TMechanicalGearAction);
begin
  case Data of
    MG_OPEN:    WriteLn(Format('Opening the %s', [Name])) ;
    MG_CLOSED:  WriteLn(Format('Closing the %s', [Name])) ;
    MG_UNKNOWN: WriteLn(Format('%s unknown command', [Name])) ;
  end;

end;

{ TWindow }

procedure TWindow.Update(Data: TMechanicalGearAction);
begin
  case Data of
    MG_OPEN:      WriteLn(Format('Opening the %s', [Name])) ;
    MG_CLOSED:    WriteLn(Format('Opening the %s', [Name])) ;
    MG_UNKNOWN:   WriteLn(Format('%s unknown command', [Name])) ;
  end;

end;

{ TLight }

procedure TLight.Update(Data: TEletricalGearAction);
begin
  case Data of
    EG_ON:      WriteLn(Format('Turning the %s ON', [Name])) ;
    EG_OFF:     WriteLn(Format('Turning the %s OFF', [Name])) ;
    EG_UNKNOWN: WriteLn(Format('%s unknown command', [Name])) ;
  end;

end;

{ TSensor<T> }

procedure TSensor<T>.SendData(Data: T);
begin
  if Assigned(FEvent) then
    FEvent(Self, Data);
end;

{ TFireSensor }

procedure TFireSensor.SendData(Data: TFireSignal);
begin
  inherited;
end;

{ TWeatherSensor }

procedure TWeatherSensor.SendData(Data: TWeatherSignal);
begin
  inherited;
end;




end.





