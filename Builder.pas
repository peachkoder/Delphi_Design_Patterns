{*******************************************************}
{                                                       }
{              DESIGN PATTERNS IN DELPHI                }
{                                                       }
{                CATEGORY : CREATIONAL                  }
{                                                       }
{                   TYPE  : BUILDER                     }
{                                                       }
{                                                       }
{*******************************************************}

unit Builder;

interface

type

  TUser = class
  private
    FName     :  String;
    FEmail    :  String;
    FPhone    :  String;
  public
    property Name:  String read FName write FName;
    property Email: String read FEmail write FEmail;
    property Phone: String read FPhone write FPhone;

    function ToString: String;
  end;

  // Interface required in order to use counting reference
  IUserBuilder = interface
    procedure BuildName(Name: String);
    procedure BuildEmail(Email: String);
    procedure BuildPhone(Phone: String);
    function Build: TUser;
  end;

  // Concrete Builder
  TUserBuilder = class(TInterfacedObject, IUserBuilder)
  strict private
    FUser: TUser;
  public
    constructor Create;
    procedure BuildName(Name: String);
    procedure BuildEmail(Email: String);
    procedure BuildPhone(Phone: String);
    function Build: TUser;
  end;

  // Director hides the creation conundruns
  TUserDirector = class
  public
    class function Construct(Builder: IUserBuilder): TUser;
  end;

implementation

uses SysUtils;



{ TUserBuilder }

function TUserBuilder.Build: TUser;
begin
  Result := FUser;
end;

procedure TUserBuilder.BuildEmail(Email: String);
begin
  FUser.FEmail := Email;
end;

procedure TUserBuilder.BuildName(Name: String);
begin
  FUser.FName := Name;
end;

procedure TUserBuilder.BuildPhone(Phone: String);
begin
  FUser.FPhone := Phone;
end;

constructor TUserBuilder.Create;
begin
  FUser := TUser.Create;
end;

{ TUserDirector }

class function TUserDirector.Construct(Builder: IUserBuilder): TUser;
begin
  // A pre-settled user is created
  Builder.BuildName('John Doe');
  Builder.BuildEmail('johndoe@email.com');
  Builder.BuildPhone('555-5555');
  Result := Builder.Build;
end;

{ TUser }

function TUser.ToString: String;
begin
  Result := Format('Name: %s, Email: %s, Phone: %s', [FName, FEmail, FPhone]);
end;

end.
