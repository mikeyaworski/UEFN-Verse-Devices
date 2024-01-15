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
  @editable
  Set150HpButton: button_device = button_device{}
  @editable
  Set175HpButton: button_device = button_device{}
  @editable
  Set185HpButton: button_device = button_device{}
  @editable
  Set200HpButton: button_device = button_device{}
  
  SetHpForAllPlayers(TotalAmount: float): void =
    ShieldAmount: float = TotalAmount - 100.0
    AllPlayers := GetPlayspace().GetPlayers()
    for (Player : AllPlayers, Character := Player.GetFortCharacter[]):
      # Max Shield needs to be set first since it also adjusts the value of the shield base on difference between old and new amount
      Character.SetMaxShield(ShieldAmount)
      Character.SetShield(ShieldAmount)
      Character.SetHealth(100.0)

  OnBegin<override>(): void =
    Set150HpButton.InteractedWithEvent.Subscribe(SetHpHandler{Device:=Self, TotalHpAmount:=150.0}.HandlerFunction)
    Set175HpButton.InteractedWithEvent.Subscribe(SetHpHandler{Device:=Self, TotalHpAmount:=175.0}.HandlerFunction)
    Set185HpButton.InteractedWithEvent.Subscribe(SetHpHandler{Device:=Self, TotalHpAmount:=185.0}.HandlerFunction)
    Set200HpButton.InteractedWithEvent.Subscribe(SetHpHandler{Device:=Self, TotalHpAmount:=200.0}.HandlerFunction)
