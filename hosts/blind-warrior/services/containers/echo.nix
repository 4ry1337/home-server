{
  virtualisation.oci-containers.containers."echo-http-service" = {
    image = "hashicorp/http-echo:latest";
    extraOptions = [ "-text='Hello, World!'" ];
    ports = [ "5678:5678" ];
  };
}
