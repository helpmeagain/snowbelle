# Máquina que não roda NixOS: só a configuração de usuário.
{
  hosts.debian = {
    desktop = "gnome";
    nixos = false;
  };
}
