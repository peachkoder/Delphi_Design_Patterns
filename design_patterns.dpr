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

const
  TAB = Char(9);

  procedure PrintSeparator(Text: String);
  begin
     Writeln('--------------------------------------------------');
     Writeln(Format('%s[%s]', [TAB, Text]));
     Writeln('--------------------------------------------------');
     Writeln('');
  end;

  procedure PrintText(Header, Text, Sequence: String);
  begin
     Writeln(Format('[%s] %s %s %s' , [Header, TAB, Text, Sequence]));
  end;

  procedure PrintEnd();
  begin
    Writeln('');
  end;

begin

  IsConsole := false;
  ReportMemoryLeaksOnShutdown := true;


  // Creational: Builder

  PrintSeparator('Creational: Builder');
  var userBuilder: IUserBuilder := TUserBuilder.Create();
  var User := TUserDirector.Construct(userBuilder);
  PrintText('User Data', User.ToString, '');
  PrintEnd;

  // Creational: Factory
  PrintSeparator('Creational: Factory');

  var factory   := TFactory.Create;
  var tablet    := factory.CreateProduct('tablet');
  var cellular  := factory.CreateProduct('cellular');
  var camera    := factory.CreateProduct('camera');

  PrintText('Gadget: Tablet','Price= ' +  CurrToStr(tablet.GetPrice), '');
  PrintText('Gadget: Cellular','Price= ' + CurrToStr(cellular.GetPrice), '');
  PrintText('Gadget: Camera','Price= ' + CurrToStr(camera.GetPrice), '');

  factory.free;
  PrintEnd;

  var factBMW: IFactory  := TBmwFactory.Create;
  var boatBmw: IBoat     := factBMW.CreateBoat;
  var carBmw:  ICar      := factBMW.CreateCar;

  PrintText('BMW Boat',  boatBmw.ToString , '');
  PrintText('BMW Car',  carBmw.ToString , '');

  var factAudi: IFactory := TAudiFactory.Create;
  var boatAudi: IBoat    := factAudi.CreateBoat;
  var carAudi:  Icar     := factAudi.CreateCar;

  PrintText('Audi Boat',  boatAudi.ToString , '');
  PrintText('Audi Car',  carAudi.ToString , '');
  PrintEnd;

  // Creational: Singleton
  PrintSeparator('Creational: Singleton');

  var singleton := TSingleton.CreateInstance;
  var singleton1 := TSingleton.CreateInstance;

  PrintText('Singleton address', singleton.ToString , '');
  PrintText('Singleton1 address', singleton1.ToString , '');
  singleton.FreeInstance;
  singleton1.FreeInstance;
  PrintEnd;

  var singSafe := TSingletonDCL.CreateInstance;
  var singSafe1 := TSingletonDCL.CreateInstance;
  PrintText('SingletonSafe address', singSafe.ToString , '');
  PrintText('SingletonSafe1 address', singSafe1.ToString , '');
  singSafe.FreeInstance;
  singSafe1.FreeInstance;
  PrintEnd;

//  TSingleFactory.TestConcurrency;
//  PrintSeparator('Creational: Singleton');

  //Adapter
  PrintSeparator('Creational: Adapter');
  var oldUser: IUser := TOldUser.Create('Old Guy', 'oldguy@email.com');
  var adaptedUser: IUser := TAdapterUser.Create(oldUser, 'ABCD35H7D2S', '555-5555');

  PrintText('Old User Type:', oldUser.ToString , '');
  PrintText('Adapter User Type:', adaptedUser.ToString , '');
  PrintEnd;

//  Writeln('**********Observer Pattern************');
//  var manager := TEquipamentManager.Create;
//  manager.AddObserver(TLight.Create);
//  manager.AddObserver(TGate.Create);
//  Writeln('Sunrise time...');
//  manager.ChangeLuminosity(DAY);
//  Writeln('Sunset time...');
//  manager.ChangeLuminosity(NIGHT);
//  manager.Free;

  PrintSeparator('Responsability: MONITOR');

  PrintText('Debug', 'Creating Monitor...' , '');
  var monitor: IMonitor := TMonitor.Create;

  //create sensors
  PrintText('Debug', 'Creating Sensors...' , '');
  var fireSensor: ISensor<TFireSignal>          := TFireSensor.Create;
  var weatherSensor: ISensor<TWeatherSignal>    := TWeatherSensor.Create;

  //create gears
  PrintText('Debug', 'Creating Gears...' , '');
  var door: IGear<TMechanicalGearAction>        := TDoor.Create('Back Door');
  var gate: IGear<TMechanicalGearAction>        := TDoor.Create('Gate');
  var backWindow: IGear<TMechanicalGearAction>  := TWindow.Create('Back Window');
  var frontWindow: IGear<TMechanicalGearAction> := TWindow.Create('Front Window');
  var porcheLight: IGear<TEletricalGearAction>  := TLight.Create('Porche Light');
  var gateLight: IGear<TEletricalGearAction>    := TLight.Create('Gate Light');

  //add sensors & gears to the monitor
  PrintText('Debug', 'Add Sensors And Gears to the Monitor...' , '');
  monitor.AddSensor(fireSensor);
  monitor.AddSensor(weatherSensor);

  monitor.AddMechanical([door, gate, backWindow, frontWindow]);
  monitor.AddEletrical([porcheLight, gateLight]);
  PrintEnd;

  //testing scenarios
  PrintText('Testing scenario', '**FIRE SENSOR OFF / WEATHER SENSOR DRY**' , '');
  fireSensor.SendData(FS_OFF);
  weatherSensor.SendData(WS_DRY);
  PrintEnd;

  PrintText('Testing scenario', '**FIRE SENSOR ON / WEATHER SENSOR WET**' , '');
  fireSensor.SendData(FS_ON);
  weatherSensor.SendData(WS_WET);
  PrintEnd;

  PrintText('Testing scenario', '**FIRE SENSOR UNKNOWN / WEATHER SENSOR UNKNOWN**' , '');
  fireSensor.SendData(FS_UNKNOWN);
  weatherSensor.SendData(WS_UNKNOWN);
  PrintEnd;

  // HashSet Structure
  PrintSeparator('HashSet Structure');
  PrintText('String HashSet', 'HashSet order is not granted', '');
  var setString: ISet<String> := THashSet<String>.Create;
  setString.Include('First String');
  setString.Include('Second String');
  setString.Include('Third String');
  setString.Include('First String'); //<- won't be included

  for var item in THashSet<String>(setString).Items do
    WriteLn(item);
  PrintEnd;

  PrintText('Integer HashSet', 'HashSet order is not granted', '');
  var setInt: ISet<Integer> := THashSet<Integer>.Create;
  setInt.Include(1);
  setInt.Include(2);
  setInt.Include(3);
  setInt.Include(1); //<- won't be included

  for var item in THashSet<Integer>(setInt).Items do
    WriteLn(item);
  PrintEnd;


  var str: String;
  Readln(str);

end.


---------------------------
Unexpected Memory Leak
---------------------------
An unexpected memory leak has occurred. The unexpected small block leaks are:

1 - 12 bytes: TSingleton x 1
29 - 36 bytes: TAdapterUser x 1, TUser x 1, UnicodeString x 4
45 - 52 bytes: UnicodeString x 1

---------------------------
OK
---------------------------

