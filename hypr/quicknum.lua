-- Omarchy QuickNum keybinding integration for Hyprland
--
-- QuickNum automatically replaces the default menu when enabled because
-- it declares "clonedFrom": "omarchy.menu" in its manifest.
--
-- If you want an explicit keybinding override instead, add the following
-- to ~/.config/hypr/bindings.lua:
--
--   hl.unbind("SUPER + SPACE")
--   o.bind("SUPER + SPACE", "QuickNum menu", "omarchy-shell shell toggle quicknum '{\"menu\":\"root\"}'")
--
-- Or using the CLI helper:
--   o.bind("SUPER + SPACE", "QuickNum menu", "omarchy-quicknum toggle")

return {
  bind = function()
    -- Optional programmatic binding helper if imported in Lua config
  end
}

