program design_patterns;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Builder in 'Builder.pas',
  factory in 'factory.pas',
  singleton in 'singleton.pas',
  factory2 in 'factory2.pas',
  adpter in 'adpter.pas',
  PeachKoder.Structs.Observer in 'responsability\PeachKoder.Structs.Observer.pas',
  PeachKoder.Collection.Hashset in 'collection\PeachKoder.Collection.Hashset.pas',
  PeachKoder.Monitor in 'responsability\PeachKoder.Monitor.pas';

begin

  IsConsole := false;
  ReportMemoryLeaksOnShutdown := true;


  // Creational: Builder
  var userBuilder: IUserBuilder := TUserBuilder.Create();
  var User := TUserDirector.Construct(userBuilder);
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

  var factBMW: IFactory  := TBmwFactory.Create;
  var boatBmw: IBoat     := factBMW.CreateBoat;
  var carBmw:  ICar      := factBMW.CreateCar;
  Writeln(boatBmw.ToString)  ;
  Writeln(carBmw.ToString)  ;
 // factBMW.free;

  var factAudi: IFactory := TAudiFactory.Create;
  var boatAudi: IBoat    := factAudi.CreateBoat;
  var carAudi:  Icar     := factAudi.CreateCar;
  Writeln(boatAudi.ToString)  ;
  Writeln(carAudi.ToString)  ;


  Writeln('--------------------------------------------------');

  // Creational: Singleton
  var singleton := TSingleton.CreateInstance;
  var singleton1 := TSingleton.CreateInstance;
  writeln('Singleton address: ' + singleton.ToString);
  writeln('Singleton1 address: ' + singleton1.ToString);
  singleton.FreeInstance;
  singleton1.FreeInstance;
  Writeln('--------------------------------------------------');

  var singSafe := TSingletonDCL.CreateInstance;
  var singSafe1 := TSingletonDCL.CreateInstance;
  writeln('SingletonSafe address: ' + singSafe.ToString);
  writeln('SingletonSafe1 address: ' + singSafe1.ToString);
  singSafe.FreeInstance;
  singSafe1.FreeInstance;
  Writeln('--------------------------------------------------');

//  TSingleFactory.TestConcurrency;
   Writeln('--------------------------------------------------');

  var oldUser: IUser := TOldUser.Create('Old Guy', 'oldguy@email.com');
  var adaptedUser: IUser := TAdapterUser.Create(oldUser, 'ABCD35H7D2S', '555-5555');
  WriteLn(adaptedUser.ToString);

  Writeln('**********Observer Pattern************');
//  var manager := TEquipamentManager.Create;
//  manager.AddObserver(TLight.Create);
//  manager.AddObserver(TGate.Create);
//  Writeln('Sunrise time...');
//  manager.ChangeLuminosity(DAY);
//  Writeln('Sunset time...');
//  manager.ChangeLuminosity(NIGHT);
//  manager.Free;

  Writeln('**********Structure hashset **********');

  var setString: ISet<String> := THashSet<String>.Create;
  setString.Include('First String');
  setString.Include('Second String');
  setString.Include('Third String');
  setString.Include('First String');

  Writeln('**********MONITOR ********************');

  var monitor := PeachKoder.Monitor.TMonitor.Create;
  var fireSensor: ISensor<TFireSignal>  := TFireSensor.Create;
  var weatherSensor: ISensor<TWeatherSignal> := TWeatherSensor.Create;
  var door: IGear<TMechanicalGearAction> := TDoor.Create('Back Door');
  var gate: IGear<TMechanicalGearAction> := TDoor.Create('Gate');
  var backWindow: IGear<TMechanicalGearAction> := TWindow.Create('Back Window');
  var frontWindow: IGear<TMechanicalGearAction> := TWindow.Create('Front Window');
  var porcheLight: IGear<TEletricalGearAction> := TLight.Create('Porche Light');
  var gateLight: IGear<TEletricalGearAction> := TLight.Create('Gate Light');


  monitor.AddSensor(fireSensor);
  monitor.AddSensor(weatherSensor);
  monitor.AddMechanical(door);
  monitor.AddMechanical(gate);
  monitor.AddMechanical(backWindow);
  monitor.AddMechanical(frontWindow);
  monitor.AddEletrical(porcheLight);
  monitor.AddEletrical(gateLight);

  Writeln('***FIRE SENSOR OFF / WEATHER SENSOR DRY***');
  fireSensor.SendData(FS_OFF);
  weatherSensor.SendData(WS_DRY);

  Writeln('***FIRE SENSOR ON / WEATHER SENSOR WET***');
  fireSensor.SendData(FS_ON);
  weatherSensor.SendData(WS_WET);

  Writeln('***FIRE SENSOR UNKNOWN / WEATHER SENSOR UNKNOWN***');
  fireSensor.SendData(FS_UNKNOWN);
  weatherSensor.SendData(WS_UNKNOWN);

  monitor.Free;



  var str: String;
  Readln(str);

end.
