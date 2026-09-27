{ config, pkgs, ... }:

{
  users.users.username = {
    isNormalUser = true;
    description = "my user";
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keys = [
#      "ssh-ed25519 AAA........"
    ];
    packages = with pkgs; [
      git
    ];
  };
}
