using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }

# Surely there is a better way to do this, but for now:
# https://forums.unrealengine.com/t/guide-to-event-subscribing-with-additional-parameters-handler-functions/793925
GrantItemsHandler := class() {
  Device: weapon_manager_device
  LoadoutNumber: int

  HandlerFunction(Agent: agent): void = {
    Device.GrantItems(Agent, LoadoutNumber)
  }
}

weapon_manager_device := class(creative_device):
  @editable
  WeaponGranters: []item_granter_device = array{}
  @editable
  LoadoutButtons: []button_device = array{}

  OnBegin<override>(): void =
    for (I := 0..LoadoutButtons.Length; Button := LoadoutButtons[I]):
      Button.InteractedWithEvent.Subscribe(GrantItemsHandler{Device:=Self, LoadoutNumber:=I}.HandlerFunction)
  
  GrantItems(Agent: agent, WeaponIndex: int): void =
    if (ItemGranter := WeaponGranters[WeaponIndex]):
      ItemGranter.GrantItem(Agent)
