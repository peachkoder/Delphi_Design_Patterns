{*******************************************************}
{                                                       }
{              DESIGN PATTERNS IN DELPHI                }
{                                                       }
{                CATEGORY : CREATIONAL                  }
{                                                       }
{                   TYPE  : FACTORY                     }
{                                                       }
{                                                       }
{*******************************************************}


unit factory2;

interface

uses SysUtils;

type

IBrand = interface
  function Price: Currency;
  function Engine: String;
end;

TBmw = class(TInterfacedObject,IBrand)
  function Price: Currency;
  function Engine: String;
end;

TAudi = class(TInterfacedObject,IBrand)
  function Price: Currency;
  function Engine: String;
end;

//Cars defs
ICar = interface
  function Color: String;
  function Price: Currency;
  function ToString: String;
end;

IBoat = interface
  function Color: String;
  function Price: Currency;
  function ToString: String;
end;

TCar = class(TInterfacedObject, ICar)
private
  FBrand: IBrand;
public
  constructor Create(Brand: IBrand);
  function Color: String;
  function Price: Currency;
  function ToString: String;
end;

TBoat = class(TInterfacedObject, IBoat)
private
  FBrand: IBrand;
public
  constructor Create(Brand: IBrand);
  function Color: String;
  function Price: Currency;
  function ToString: String;
end;

// Factory
IFactory = interface
  function CreateCar: ICar;
  function CreateBoat: IBoat;
end;

TBmwFactory = class(TInterfacedObject, IFactory)
public
  function CreateCar: ICar;
  function CreateBoat: IBoat;
end;

TAudiFactory = class(TInterfacedObject, IFactory)
public
  function CreateCar: ICar;
  function CreateBoat: IBoat;
end;

implementation

{ TBmw }

function TBmw.Engine: String;
begin
  result := 'W6 DOHC 540HP Gasoline';

end;

function TBmw.Price: Currency;
begin
  result := 55000.00;
end;

{ TAudi }

function TAudi.Engine: String;
begin
  result := '6Line DOHC Bi-Turbo 580HP Diesel';
end;

function TAudi.Price: Currency;
begin
  result := 84600.00;
end;

{ TCar }

function TCar.Color: String;
begin
  result:= 'Any color black you want';
end;

constructor TCar.Create(Brand: IBrand);
begin
  FBrand := Brand;
end;

function TCar.Price: Currency;
begin
  result := FBrand.Price;
end;

function TCar.ToString: String;
begin
  result := Format('Car Brand: Color: %S, Engine: %S, Price: %f', [Color, FBrand.Engine, FBrand.Price]);
end;

{ TBoat }

function TBoat.Color: String;
begin
  result := 'white';
end;

constructor TBoat.Create(Brand: IBrand);
begin
  FBrand := Brand;
end;

function TBoat.Price: Currency;
begin
  result := FBrand.Price;
end;

function TBoat.ToString: String;
begin
  result := Format('Car Brand: Color: %S, Engine: %S, Price: %f', [Color, FBrand.Engine, FBrand.Price]);
end;

{ TBmwFactory }

function TBmwFactory.CreateBoat: IBoat;
begin
  Result := IBoat(TBoat.Create(TBmw.Create));
end;

function TBmwFactory.CreateCar: ICar;
begin
  Result := ICar(TCar.Create(TBmw.Create));
end;

{ TAudiFactory }

function TAudiFactory.CreateBoat: IBoat;
begin
  Result := IBoat(TBoat.Create(TAudi.Create));
end;

function TAudiFactory.CreateCar: ICar;
begin
  Result := ICar(TCar.Create(TAudi.Create));
end;

end.
