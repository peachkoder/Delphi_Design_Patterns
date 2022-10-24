program design_patterns;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Builder in 'Builder.pas';

begin

  var User := TUserDirector.Construct(TUserBuilder.Create());

  writeln(User.ToString);


  try
    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
