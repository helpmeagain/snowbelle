# Máquina que não roda NixOS: só a configuração de usuário.
{
  hosts.desktop = {
    desktop = "plasma";
    nixos = false;
  };
}
