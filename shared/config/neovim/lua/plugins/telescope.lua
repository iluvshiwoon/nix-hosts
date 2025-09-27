return {
  'nvim-telescope/telescope.nvim', tag = '0.1.8',
  -- or                              , branch = '0.1.x',
  dependencies = { 'nvim-lua/plenary.nvim',{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' } },
  config = function()
    require('telescope').setup{
      pickers = {
	find_files = {
	  theme = "ivy"
	}
      },
      extensions = {
	fzf = {}
      }
    }
    require('telescope').load_extension('fzf')
    require"config.telescope.multigrep".setup()
  end
}
