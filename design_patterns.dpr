program design_patterns;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Builder in 'Builder.pas',
  factory in 'factory.pas',
  singleton in 'singleton.pas';

begin

  // Creational: Builder
  var User := TUserDirector.Construct(TUserBuilder.Create());
  writeln(User.ToString);

  // Creational: Factory
  var factory   := TFactory.Create;
  var tablet    := factory.CreateProduct('tablet');
  var cellular  := factory.CreateProduct('cellular');
  var camera    := factory.CreateProduct('camera');
  writeln(CurrToStr(tablet.GetPrice));
  writeln(CurrToStr(cellular.GetPrice));
  writeln(CurrToStr(camera.GetPrice));

  // Creational: Singleton
  var singleton := TSingleton.CreateInstance;
  var singleton1 := TSingleton.CreateInstance;
  writeln('Singleton address: ' + singleton.ToString);
  writeln('Singleton1 address: ' + singleton1.ToString);
  singleton.FreeInstance;
  singleton1.FreeInstance;

  var singSafe := TSingletonSafe.CreateInstance;
  var singSafe1 := TSingletonSafe.CreateInstance;
  writeln('SingletonSafe address: ' + singSafe.ToString);
  writeln('SingletonSafe1 address: ' + singSafe1.ToString);
  singSafe.FreeInstance;
  singSafe1.FreeInstance;


  try
    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
