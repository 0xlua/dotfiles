{inputs, ...}: {
  imports = [
    inputs.cosmic.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
  ];

  nix.settings = {
    substituters = ["https://cosmic.cachix.org/"];
    trusted-public-keys = ["cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="];
  };

  home-manager.users.lua = {
    programs.obs-studio = {
      enable = true;
    };

    programs.thunderbird = {
      enable = true;
      profiles.lua.isDefault = true;
    };

    xdg.configFile = {
      "cosmic/com.system76.CosmicAppletTime/v1/first_day_of_week".text = "0";
      "cosmic/com.system76.CosmicAppletTime/v1/military_time".text = "true";
      "cosmic/com.system76.CosmicAppletTime/v1/show_date_in_top_panel".text = "false";
      "cosmic/com.system76.CosmicBackground/v1/same-on-all".text = "true";
      "cosmic/com.system76.CosmicComp/v1/active_hint".text = "true";
      "cosmic/com.system76.CosmicComp/v1/autotile".text = "true";
      "cosmic/com.system76.CosmicComp/v1/autotile_behavior".text = "PerWorkspace";
      "cosmic/com.system76.CosmicComp/v1/input".text = "(
        state: Enabled,
        acceleration: Some((
          profile: Some(Flat),
          speed: 0.024394003676990517,
        )),
      )";
      "cosmic/com.system76.CosmicComp/v1/xkb_config".text = "
      (
        rules: \"\",
        model: \"pc104\",
        layout: \"us\",
        variant: \"intl\",
        options: Some(\"terminate:ctrl_alt_bksp,caps:escape\"),
        repeat_delay: 600,
        repeat_rate: 25,
      )
    ";
      # "cosmic/com.system76.CosmicPanel/v1/entries".text = "[\"Panel\"]";
      # "cosmic/com.system76.CosmicPanel.Panel/v1/anchor".text = "Top";
      # "cosmic/com.system76.CosmicPanel.Panel/v1/anchor_gap".text = "true";
      # "cosmic/com.system76.CosmicPanel.Panel/v1/autohide".text = "None";
      # "cosmic/com.system76.CosmicPanel.Panel/v1/border_radius".text = "160";
      # "cosmic/com.system76.CosmicPanel.Panel/v1/exclusive_zone".text = "true";
      # "cosmic/com.system76.CosmicPanel.Panel/v1/expand_to_edges".text = "true";
      # "cosmic/com.system76.CosmicPanel.Panel/v1/keyboard_interactivity".text = "true";
      # "cosmic/com.system76.CosmicPanel.Panel/v1/layer".text = "Top";
      # "cosmic/com.system76.CosmicPanel.Panel/v1/margin".text = "4";
      # "cosmic/com.system76.CosmicPanel.Panel/v1/name".text = "\"Panel\"";
      # "cosmic/com.system76.CosmicPanel.Panel/v1/opacity".text = "1.0";
      # "cosmic/com.system76.CosmicPanel.Panel/v1/output".text = "All";
      # "cosmic/com.system76.CosmicPanel.Panel/v1/padding".text = "0";
      # "cosmic/com.system76.CosmicPanel.Panel/v1/plugins_center".text = "
      #   Some([
      #     \"com.system76.CosmicAppletTime\",
      #   ])
      # ";
      # "cosmic/com.system76.CosmicPanel.Panel/v1/plugins_wings".text = "
      #   Some(([
      #       \"com.system76.CosmicAppletWorkspaces\",
      #   ], [
      #       \"com.system76.CosmicAppletInputSources\",
      #       \"com.system76.CosmicAppletStatusArea\",
      #       \"com.system76.CosmicAppletTiling\",
      #       \"com.system76.CosmicAppletAudio\",
      #       \"com.system76.CosmicAppletNetwork\",
      #       \"com.system76.CosmicAppletNotifications\",
      #       \"com.system76.CosmicAppletPower\",
      #   ]))
      # ";
      # "cosmic/com.system76.CosmicPanel.Panel/v1/size".text = "XS";
      # "cosmic/com.system76.CosmicPanel.Panel/v1/spacing".text = "2";
      "cosmic/com.system76.CosmicSettings.Shortcuts/v1/custom".text = "
      {
          (
              modifiers: [
                  Super,
              ],
              key: \"d\",
          ): System(Launcher),
          (
              modifiers: [
                  Super,
              ],
          ): Disable,
          (
              modifiers: [
                  Super,
              ],
              key: \"t\",
          ): Disable,
          (
              modifiers: [
                  Super,
              ],
              key: \"Return\",
              description: Some(\"Alacritty\"),
          ): Spawn(\"alacritty\"),
          (
              modifiers: [
                  Super,
              ],
              key: \"slash\",
          ): Disable,
      }
    ";
      "cosmic/com.system76.CosmicTk/v1/interface_font".text = "
      (
          family: \"Inter\",
          weight: Normal,
          stretch: Normal,
          style: Normal,
      )
    ";
      "cosmic/com.system76.CosmicTk/v1/monospace_font".text = "
      (
          family: \"Hack Nerd Font Mono\",
          weight: Normal,
          stretch: Normal,
          style: Normal,
      )
    ";
      "cosmic/com.system76.CosmicTk/v1/show_maximize".text = "false";
      "cosmic/com.system76.CosmicTk/v1/show_minimize".text = "false";
    };
  };
  stylix.image = ./wallpaper/cloud_launch.png;

  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;

  programs.dconf.enable = true;
}
