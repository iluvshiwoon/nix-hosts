{
	...
}: {
	programs.git = {
		enable = true;
		userName = "iluvshiwoon";
		userEmail = "sntcillian@gmail.com";
		extraConfig = {
			core.editor = "nvim";
			init.defaultBranch = "main";
			pull.rebase = true;
			core.excludesFile = "~/.gitignore_global";
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
