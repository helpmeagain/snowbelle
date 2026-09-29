-- Autostart (See https://wiki.hypr.land/Configuring/Basics/Autostart/)
hl.on("hyprland.start", function ()
   hl.exec_cmd("noctalia")
   hl.exec_cmd("hyprctl setcursor Bibata-Modern-Classic 24")
end)

-- Env (https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("KDE_DEBUG", "1")
hl.env("KDE_DISABLE_CRASH_HANDLER", "1")
hl.env("QT_QPA_PLATFORMTHEME", "kde")
