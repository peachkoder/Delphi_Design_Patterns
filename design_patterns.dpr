program design_patterns;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Builder in 'Builder.pas',
  factory in 'factory.pas',
  singleton in 'singleton.pas';

begin

  IsConsole := false;
  ReportMemoryLeaksOnShutdown := true;


  // Creational: Builder
  var User := TUserDirector.Construct(TUserBuilder.Create());
  writeln(User.ToString);
   Writeln('--------------------------------------------------');

  // Creational: Factory
  var factory   := TFactory.Create;
  var tablet    := factory.CreateProduct('tablet');
  var cellular  := factory.CreateProduct('cellular');
  var camera    := factory.CreateProduct('camera');
  writeln(Format('Gadget: Tablet | Price: %s', [CurrToStr(tablet.GetPrice)] ));
  writeln(Format('Gadget: cellular | Price: %s', [CurrToStr(cellular.GetPrice)] ));
  writeln(Format('Gadget: camera | Price: %s', [CurrToStr(camera.GetPrice)] ));
  factory.free;
  Writeln('--------------------------------------------------');

  // Creational: Singleton
  var singleton := TSingleton.CreateInstance;
  var singleton1 := TSingleton.CreateInstance;
  writeln('Singleton address: ' + singleton.ToString);
  writeln('Singleton1 address: ' + singleton1.ToString);
  singleton.FreeInstance;
  singleton1.FreeInstance;
  Writeln('--------------------------------------------------');

  var singSafe := TSingletonSafe.CreateInstance;
  var singSafe1 := TSingletonSafe.CreateInstance;
  writeln('SingletonSafe address: ' + singSafe.ToString);
  writeln('SingletonSafe1 address: ' + singSafe1.ToString);
  singSafe.FreeInstance;
  singSafe1.FreeInstance;
  Writeln('--------------------------------------------------');

  TSingleFactory.TestConcurrency;
   Writeln('--------------------------------------------------');

  var str: String;
  Readln(str);


  try
    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
