let
    sakanai = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAdlcjFtISF+IZ8I6+G48VcpsaCbTNpdzX7TfX+MIrPe";

    freya = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICeNNqEeDOobHzahYP64AGf6+QtV7W4ZibSOTpfcp6jZ root@nixos";
in
{
    "notifybot.age".publicKeys = [ sakanai freya ];
}
