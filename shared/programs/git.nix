{...}: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "iluvshiwoon";
        email = "sntcillian@gmail.com";
      };
      core = {
        editor = "nvim";
        excludesFile = "~/.gitignore_global";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  home.file.".gitignore_global".text = ''
      # C/C++ compiled objects
    *.o
    *.obj
    *.elf
    *.so
    *.dylib
    *.dll
    *.a
    *.lib

    # Executables
    *.exe
    *.out
    *.app

    # Build directories
    build/
    cmake-build-*/
    .cache/

    # IDE files
    .vscode/
    .idea/
    *.swp
    *.swo
    *~

    # Compilation database
    compile_commands.json

    # Core dumps
    core.*
  '';
}
