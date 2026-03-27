{
  config,
  lib,
  ...
}: let
  cfg = config.server.zigbee;
in {
  options.server.zigbee.enable = lib.mkEnableOption "Zigbee2MQTT & Mosquitto";

  config = lib.mkIf cfg.enable {
    networking.modemmanager.enable = lib.mkForce false;
    networking.firewall.allowedTCPPorts = [8080];
    services.zigbee2mqtt = {
      enable = true;
      settings = {
        homeassistant.enabled = config.server.homeassistant.enable;
        frontend.enabled = true;
        permit_join = true;
        serial = {
          port = "/dev/serial/by-id/usb-Itead_Sonoff_Zigbee_3.0_USB_Dongle_Plus_V2_3677108e690eef11b98ebe2a433abf1e-if00-port0";
          adapter = "ezsp";
        };
        mqtt = {
          base_topic = "zigbee2mqtt";
          server = "mqtt://ganymede:1883";
        };
        advanced = {
          channel = 11;
          network_key = "GENERATE";
          pan_id = "GENERATE";
          ext_pan_id = "GENERATE";
        };
      };
    };
    virtualisation.oci-containers.containers.mosquitto = {
      image = "docker.io/eclipse-mosquitto:latest";
      autoStart = true;
      user = "1000:100";
      labels = {"io.containers.autoupdate" = "registry";};
      environment.TZ = "Europe/Berlin";
      volumes = [
        "/home/lua/podman/mosquitto/config:/mosquitto/config:Z"
        "/home/lua/podman/mosquitto/data:/mosquitto/data:Z"
        "/home/lua/podman/mosquitto/log:/mosquitto/log:Z"
      ];
      ports = ["1883:1883" "9883:9883"];
    };
  };
}
