unit singleton;

interface

type

TSingleton = class
strict private
  class var FInstance:  TSingleton;
  constructor Create;
public
  class function CreateInstance: TSingleton;
  procedure FreeInstance; override;
  function ToString: String;
end;

// Thread Safe singleton. SLOWER but Safer
TSingletonSafe = class
strict private
  class var FInstance:  TSingleton;
  constructor Create;
public
  class function CreateInstance: TSingleton;
  procedure FreeInstance; override;
  function ToString: String;
  
end;

implementation

uses System.Classes, System.SysUtils, SyncObjs;

{ TSingleton }

constructor TSingleton.Create;
begin

end;

class function TSingleton.CreateInstance: TSingleton;
begin
   if FInstance = nil then
    FInstance := TSingleton.Create;

   result := FInstance;
end;

procedure TSingleton.FreeInstance;
begin
  if FInstance <> nil then FInstance.Free;
end;

function TSingleton.ToString: String;
begin
  result := String.Parse(integer(@FInstance));
end;

{ TSingletonSafe }

constructor TSingletonSafe.Create;
begin

end;

class function TSingletonSafe.CreateInstance: TSingleton;
var cs: TCriticalSection;
begin
  if FInstance = nil then
  begin
    cs := TCriticalSection.Create; 
    try
      //TThread.CreateAnonymousThread(
      //  procedure ()
        begin
          cs.Acquire;
          if FInstance = nil then
            FInstance := TSingleton.Create; 
          cs.Release;
        end    ;
     // );
    finally
      cs.Free;
      result := FInstance;
    end;
  end;

end;

procedure TSingletonSafe.FreeInstance;
begin
  inherited;

end;

function TSingletonSafe.ToString: String;
begin
  result := String.Parse(integer(@FInstance));
end;

end.
