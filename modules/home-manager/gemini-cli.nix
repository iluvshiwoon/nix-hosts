# gemini-module.nix
# This module declaratively manages gemini-cli and its extensions
# using sources provided as flake inputs.

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.gemini;

  # This function prepares a unified source derivation for an extension.
  # It combines the original source with any declarative overrides
  # (like custom JSON/Markdown files or custom commands) into a single, new derivation.
  prepareExtension = ext:
    let
      needsOverride = (ext.geminiExtensionJson != null)
                   ||
                   (ext.geminiMd != null)
                   ||
                   (ext.customCommands != {});

      installSrc = if !needsOverride then ext.src else
        pkgs.runCommand "gemini-ext-${ext.name}-with-overrides" {} ''
          # 1. Copy the original source content into our new derivation.
          cp -r ${ext.src}/. $out
          chmod -R u+w $out # Make it writable to add/overwrite files.

          # 2. Conditionally write the gemini-extension.json file.
          ${optionalString (ext.geminiExtensionJson != null) ''
            cat ${builtins.toFile "gemini-extension.json" ext.geminiExtensionJson} > $out/gemini-extension.json
          ''}

          # 3. Conditionally write the GEMINI.md file.
          ${optionalString (ext.geminiMd != null) ''
            cat ${builtins.toFile "GEMINI.md" ext.geminiMd} > $out/GEMINI.md
          ''}

          # 4. Create all custom command TOML files from the `customCommands` attrset.
          ${lib.concatStringsSep "\n" (
            lib.mapAttrsToList (path: content: ''
              mkdir -p $out/commands/$(dirname "${path}")
              cat ${builtins.toFile path content} > "$out/commands/${path}"
            '') ext.customCommands
          )}
        '';
    in
    # Return the extension's attribute set with `installSrc` pointing to the final derivation.
    ext // { inherit installSrc; };

  # Prepare all extensions defined in the user's configuration.
  preparedExtensions = map prepareExtension cfg.extensions;

in
{
  options.programs.gemini = {
    enable = mkEnableOption "the Gemini CLI program and extensions";

    extensions = mkOption {
      type = types.listOf (types.submodule ({ ... }: {
        options = {
          name = mkOption {
            type = types.str;
            description = "The name of the extension (the directory name it creates in ~/.gemini/extensions).";
            example = "code-assistant";
          };

          src = mkOption {
            type = types.package; # Expects a derivation/path from flake inputs
            description = "The source derivation for the extension (passed via specialArgs).";
            example = literalExpression "config.specialArgs.gemini-code-assistant";
          };

          # New option for gemini-extension.json
          geminiExtensionJson = mkOption {
            type = with types; nullOr str;
            default = null;
            description = "Content for a gemini-extension.json file to be placed in the extension's root, overriding any existing one.";
            example = ''
              {
                "name": "My Custom Tool",
                "description": "Does custom things."
              }
            '';
          };

          # New option for GEMINI.md
          geminiMd = mkOption {
            type = with types; nullOr str;
            default = null;
            description = "Content for a GEMINI.md file to be placed in the extension's root, overriding any existing one.";
            example = "# My Custom Tool\n\nThis is how you use it.";
          };

          # New, more specific option for managing custom command TOML files.
          customCommands = mkOption {
            type = with types; attrsOf str;
            default = {};
            description = "Declaratively manage custom command TOML files for this extension.";
            example = 
              {
                "deploy.toml" = ''
                  prompt = "Deploy the application to GCP"
                  model = "gemini-pro"
                '';
                "gcs/sync.toml" = ''
                  prompt = "Sync files to the GCS bucket specified in the first argument"
                  model = "gemini-pro"
                '';
              };
          };
        };
      }));
      default = [];
      description = "A list of Gemini CLI extensions to install.";
    };

    # New option for settings.json
    settingsJson = mkOption {
      type = with types; nullOr str;
      default = null;
      description = "Content for a settings.json file to be placed in ~/.gemini/settings.json.";
      example = ''
        {
          "defaultModel": "gemini-pro"
        }
      '';
    };

    # New option for global custom commands
    globalCustomCommands = mkOption {
      type = with types; attrsOf str;
      default = {};
      description = "Declaratively manage global custom command TOML files for Gemini CLI.";
      example = 
        {
          "deploy.toml" = ''
            prompt = "Deploy the application to GCP"
            model = "gemini-pro"
          '';
          "gcs/sync.toml" = ''
            prompt = "Sync files to the GCS bucket specified in the first argument"
            model = "gemini-pro"
          '';
        };
    };
  };

  config = mkIf cfg.enable {
    # 1. Ensure the necessary base packages are installed.
    home.packages = [ pkgs.gemini-cli pkgs.git ];

    # Manage Gemini extensions and settings.json using home.file
    home.file = lib.mkMerge [
      (lib.mkIf (cfg.settingsJson != null) {
        ".gemini/settings.json" = {
          text = cfg.settingsJson;
          force = true;
        };
      })
      (lib.mkMerge (
        lib.map (ext: {
          ".gemini/extensions/${ext.name}" = {
            source = ext.installSrc;
            recursive = true;
          };
        }) preparedExtensions
      ))
      (lib.mkMerge (
        lib.mapAttrsToList (path: content: {
          ".gemini/commands/${path}" = {
            text = content;
            # Ensure parent directories exist for namespaced commands
            onChange = "mkdir -p $(dirname ${config.home.homeDirectory}/.gemini/commands/${path})";
          };
        }) cfg.globalCustomCommands
      ))
    ];
  };
}
