let
  rakhat = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAw073fJwGbhBTWk6Yy2h/MTGnUJrbjnMQ8hJ0PLZGJr rakhat";
  ary = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBP/gBUdlpniVJ8JJ1WTFDHDkjvFYBNm0jD4jk2sIZYx root@ary";
  blind-warrior = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOn7sv142ULZQ8ftbPUY2VmopVBAtcBBTKDkSnghpUyO root@rakhat-server";
  hosts = [
    ary
    blind-warrior
  ];
in
{
  "tailscale-authkey.age".publicKeys = [ rakhat ] ++ hosts;
}
