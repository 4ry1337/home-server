{ ... }:
{
  # Static Excalidraw frontend (nginx serving the SPA, listens on :80).
  # Drawings persist in each browser's localStorage — no server-side storage.
  virtualisation.oci-containers.containers."excalidraw" = {
    image = "docker.io/excalidraw/excalidraw:latest";
    ports = [ "3210:80" ];
  };

  networking.firewall.allowedTCPPorts = [ 3210 ];
}
