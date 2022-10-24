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

unit factory;

interface

type

IProduct = interface
  function GetPrice: Currency;
end;

TCellular = class(TInterfacedObject, IProduct)
  function GetPrice: Currency;
end;

TTablet = class(TInterfacedObject, IProduct)
  function GetPrice: Currency;
end;

TCamera = class(TInterfacedObject, IProduct)
  function GetPrice: Currency;
end;

IFactory = interface
  function CreateProduct(Name: String): IProduct;
end;

TFactory = class(TInterfacedObject, IFactory)
  function CreateProduct(Name: String): IProduct;
end;


implementation

{ TFactory }

function TFactory.CreateProduct(Name: String): IProduct;
begin
  if Name = 'cellular' then
    Exit(TCellular.Create)
  else if Name = 'tablet' then
    Exit(TTablet.Create)
  else if Name = 'camera' then
    Exit(TCamera.Create)
  else
    Exit(TCellular.Create);
end;

{ TCellular }

function TCellular.GetPrice: Currency;
begin
   result := 1000.00;
end;

{ TTablet }

function TTablet.GetPrice: Currency;
begin
   result := 550.00;
end;

{ TCamera }

function TCamera.GetPrice: Currency;
begin
   result := 800.00;
end;

end.
