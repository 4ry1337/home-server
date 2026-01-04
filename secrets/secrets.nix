let
  blind-warrior =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOn7sv142ULZQ8ftbPUY2VmopVBAtcBBTKDkSnghpUyO";
  rakhat = ''
    ssh-ed25519
        AAAAC3NzaC1lZDI1NTE5AAAAIBIiVz6ybe4Cdu9cMXcPpKtQ9A8p2EQnwWq8Swne44qF
        yskak.rakhat@gmail.com'';
in {
  "secret1.age".publicKeys = [ blind-warrior ];
  "rakhat-secret.age".publicKeys = [ blind-warrior rakhat ];
}
