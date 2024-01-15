using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Verse.org/Simulation }

# Surely there is a better way to do this, but for now:
# https://forums.unrealengine.com/t/guide-to-event-subscribing-with-additional-parameters-handler-functions/793925
SetHpHandler := class():
  Device: hp_manager_device
  TotalHpAmount: float

  HandlerFunction(Agent: agent): void =
    Device.SetHpForAllPlayers(TotalHpAmount)

hp_manager_device := class(creative_device):
  var TotalHp: float = 200.0

  @editable
  PlayerSpawners: []player_spawner_device = array{}
  
  @editable
  Set150HpButton: button_device = button_device{}
  @editable
  Set175HpButton: button_device = button_device{}
  @editable
  Set185HpButton: button_device = button_device{}
  @editable
  Set200HpButton: button_device = button_device{}

  @editable
  DamageButton: button_device = button_device{}

  SetHpForPlayer(Agent: agent, TotalAmount: float): void =
    if (Character := Agent.GetFortCharacter[]):
      # Max Shield needs to be set first since it also adjusts the value of the shield base on difference between old and new amount
      ShieldAmount: float = TotalAmount - 100.0
      Character.SetMaxShield(ShieldAmount)
      Character.SetShield(ShieldAmount)
      Character.SetHealth(100.0)
  
  SetHpForAllPlayers(TotalAmount: float): void =
    set TotalHp = TotalAmount
    AllPlayers := GetPlayspace().GetPlayers()
    for (Player : AllPlayers):
      SetHpForPlayer(Player, TotalAmount)
  
  DamagePlayer(Agent: agent): void =
    if (Character := Agent.GetFortCharacter[]):
      Character.Damage(50.0)

  OnPlayerSpawn(Agent : agent) : void =
    SetHpForPlayer(Agent, Self.TotalHp)

  OnBegin<override>(): void =
    for (Spawner : PlayerSpawners):
      Spawner.SpawnedEvent.Subscribe(OnPlayerSpawn)
    Set150HpButton.InteractedWithEvent.Subscribe(SetHpHandler{Device:=Self, TotalHpAmount:=150.0}.HandlerFunction)
    Set175HpButton.InteractedWithEvent.Subscribe(SetHpHandler{Device:=Self, TotalHpAmount:=175.0}.HandlerFunction)
    Set185HpButton.InteractedWithEvent.Subscribe(SetHpHandler{Device:=Self, TotalHpAmount:=185.0}.HandlerFunction)
    Set200HpButton.InteractedWithEvent.Subscribe(SetHpHandler{Device:=Self, TotalHpAmount:=200.0}.HandlerFunction)
    DamageButton.InteractedWithEvent.Subscribe(DamagePlayer)
