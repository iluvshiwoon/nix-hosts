{username, ...}: {
  security.pam.enableSudoTouchIdAuth = true;

  myModules.screenshots = {
    enable = true;
    path = "/Users/kershuenlee/Pictures/Screenshots";
    usernameForPath = "kershuenlee";
  };

  system = {
    defaults = {
      dock = {
        autohide = true;
        autohide-delay = 0.4;
        static-only = true;
        tilesize = 50;
        show-recents = true;
        scroll-to-open = true;
        minimize-to-application = true;
        mineffect = "scale";
        launchanim = false;

        # corner actions
        wvous-bl-corner = 1; #disabled
        wvous-br-corner = 1; #disabled
        wvous-tl-corner = 1; #disabled
        wvous-tr-corner = 1; #disabled
      };

      screencapture = {
        disable-shadow = true;
	location = "/Users/${username}/Pictures/Screenshots";
      };

      finder = {
        AppleShowAllExtensions = true;
        CreateDesktop = false;
        FXDefaultSearchScope = "SCcf";
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "Nlsv";
        FXRemoveOldTrashItems = true;
        _FXShowPosixPathInTitle = true;
        _FXSortFoldersFirst = true;
        NewWindowTarget = "Home";
        QuitMenuItem = false; # finder is responsible for a lot of things on macOS desktop
        ShowPathbar = true;
        ShowStatusBar = true;
      };
      CustomUserPreferences = { # question about user / system wide for everythin darwin does as it's seems to be changing rn on github
        "com.apple.finder" = {
          "FinderSpawnTab" = true; # cmd + click open tab (default)
        };
      };
      NSGlobalDomain = {
        _HIHideMenuBar = true;
      };
    };
  };
}
