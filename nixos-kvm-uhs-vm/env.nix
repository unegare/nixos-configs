{ config, pkgs, ... }:

{
  programs.bash.interactiveShellInit = ''
    if [ "$(tty)" = "/dev/ttyS0" ]; then
      if command -v resize >/dev/null 2>&1; then
        eval $(resize)
      fi
    fi
  '';

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    generateHostKeys = true;
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];

    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitEmptyPasswords = "no";
      X11Forwarding = false;

      Ciphers = [
        "chacha20-poly1305@openssh.com"
        "aes256-gcm@openssh.com"
        "aes128-gcm@openssh.com"
      ];
      KexAlgorithms = [
        "curve25519-sha256"
        "curve25519-sha256@libssh.org"
        "diffie-hellman-group16-sha512"
        "diffie-hellman-group18-sha512"
        "diffie-hellman-group-exchange-sha256"
      ];
      Macs = [
        "hmac-sha2-512-etm@openssh.com"
        "hmac-sha2-256-etm@openssh.com"
        "umac-128-etm@openssh.com"
      ];
    };
  };

  programs.vim.enable = false;
  environment.variables.EDITOR = "vim";

  environment.systemPackages = with pkgs; [
    (pkgs.vim-full.customize {
      name = "vim";
      vimrcConfig.customRC = ''
        set ignorecase
        set smartcase
        set number
        set relativenumber
        set shiftwidth=2
        set tabstop=2
        set expandtab
      '';
    })
    wget
    git
    xterm
  ];
}
