unit singleton;

interface

uses SyncObjs;

type

TSingleton = class
strict private
  class var FCounter: Integer;
  class var FInstance:  TSingleton;
  constructor Create;
public
  class function CreateInstance: TSingleton;
  class procedure FreeInstance; //override;
   function ToString: String;
end;

// Thread Safe singleton. SLOWER but Safer
TSingletonSafe = class
strict private
  class var FCounter: Integer;
  class var FCriticalSection: TCriticalSection;
  class var FInstance:  TSingleton;
  constructor Create;
public
  class function CreateInstance: TSingleton;
  class procedure FreeInstance;
  class function ToString: String;

end;

// The main goal of this class is test the TSingletonSafe concurrency
TSingleFactory = class
public
 class procedure TestConcurrency;
end;

implementation

uses System.Classes, System.SysUtils;

{ TSingleton }

constructor TSingleton.Create;
begin
   //strict protected don't use
   //method was hiden from user
end;

class function TSingleton.CreateInstance: TSingleton;
begin
   if FInstance = nil then
   begin
    FInstance := TSingleton.Create;
   end;
   Inc(FCounter);
   result := FInstance;
end;

class procedure TSingleton.FreeInstance;
begin
  Dec(FCounter) ;
  if (FCounter <= 0) then
    FreeAndNil(FInstance)       ;
end;

function TSingleton.ToString: String;
begin
  result := String.Parse(integer(@FInstance));
end;

{ TSingletonSafe }

constructor TSingletonSafe.Create;
begin
  //strict protected don't use
  //method was hiden from user
end;

class function TSingletonSafe.CreateInstance: TSingleton;
begin
  // checks if the instance is null
  if FInstance = nil then
  begin
    // creates critical section, it'll lock the following code
    FCriticalSection := TCriticalSection.Create;
    try
      // locks the resource
      FCriticalSection.Acquire;
      // checks again if instance remains null
      // this is important because another thread could change
      // instance state before this call.
      if FInstance = nil then
          FInstance := TSingleton.Create;
    finally
      // release and clean up de code
      FCriticalSection.Release;
      FreeAndNil(FCriticalSection);
      Inc(FCounter);
      result := FInstance;
    end;
  end;
end;

class procedure TSingletonSafe.FreeInstance;
begin
  Dec(FCounter);
  if(FCounter <= 0) then
  begin
    FreeAndNil(FInstance);
    FreeAndNil(FCriticalSection);
  end;
end;

class function TSingletonSafe.ToString: String;
begin
  result := String.Parse(integer(@FInstance));
end;

{ TSingleFactory }

class procedure TSingleFactory.TestConcurrency;
begin
  for var i := 1 to 20 do
  begin
    TThread.CreateAnonymousThread(
    procedure ()
    begin
      var instance := TSingletonSafe.CreateInstance;
      var cs := TCriticalSection.Create;
      try
        cs.Acquire;

        Writeln(Format('Thread n.º= %d. Instace Address: %s' ,
               [TThread.CurrentThread.ThreadID, instance.ToString]));
      finally
        cs.Release;
        FreeAndNil(cs);
        instance.FreeInstance;
      end;
    end
    ).Start;
  end;
end;

end.
