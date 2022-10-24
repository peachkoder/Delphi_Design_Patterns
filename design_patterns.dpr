program design_patterns;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Builder in 'Builder.pas',
  factory in 'factory.pas';

begin

  // Creational: Builder
  var User := TUserDirector.Construct(TUserBuilder.Create());
  writeln(User.ToString);

  // Creational: Factory
  var factory := TFactory.Create;
  writeln(factory.CreateProduct('tablet').GetPrice);




  try
    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
