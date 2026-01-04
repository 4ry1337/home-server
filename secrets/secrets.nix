let
  blind-warrior =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOn7sv142ULZQ8ftbPUY2VmopVBAtcBBTKDkSnghpUyO";
in { "secret1.age".publicKeys = [ blind-warrior ]; }
