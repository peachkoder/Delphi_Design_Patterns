{*******************************************************}
{                                                       }
{              DESIGN PATTERNS IN DELPHI                }
{                                                       }
{                CATEGORY : CREATIONAL                  }
{                                                       }
{                   TYPE  : ADAPTER                     }
{                                                       }
{*******************************************************}

unit PeachKoder.Pattern.Adapter;

interface

type

IUser = interface
  ['{4FF5F2AC-81CF-4993-B7D5-F8E3B0ADABDE}']
  function ToString: String;
end;

TOldUser = class(TInterfacedObject, IUser)
strict private
  FName,
  FEmail: String;
public
  constructor Create(Name, Email: String);
  function ToString: String;
  property Name : String read FName;
  property Email: String read FEmail;
end;

TAdapterUser = class(TInterfacedObject, IUser)
private
  FOldUser: TOldUser;
  FTaxNumber: String;
  FPhone: String;
  function GetEmail: String;
  function GetName: String;
public
  constructor Create(const OldUser: IUser; TaxNumber, Phone: String);
  destructor Destroy; override;
  function ToString: String;
  property TaxNumber: String read FTaxNumber;
  property Phone    : String read FPhone;
  property Name     : String read GetName;
  property Email    : String read GetEmail;
end;



implementation

uses sysutils;

{ TOldUser }

constructor TOldUser.Create(Name, Email: String);
begin
  FName:= Name;
  FEmail := Email;
end;


function TOldUser.ToString: String;
begin
  Result := Format('[%s] Name: %s, Email: %s', [self.ClassName, FName, FEmail]);
end;

{ TAdapterUser }

constructor TAdapterUser.Create(const OldUser: IUser; TaxNumber, Phone: String);
begin
  FOldUser := TOldUser(OldUser);
  FTaxNumber := TaxNumber;
  FPhone := Phone;
end;

destructor TAdapterUser.Destroy;
begin
  FreeAndNil(FOldUser);
  inherited;
end;

function TAdapterUser.GetEmail: String;
begin
  result := FOldUser.Name;
end;

function TAdapterUser.GetName: String;
begin
  result := FOldUser.Email;
end;

function TAdapterUser.ToString: String;
begin
  Result := FOldUser.ToString +
        Format('Phone: %s, TaxNumber: %s', [FPhone, FTaxNumber]);
end;

end.
