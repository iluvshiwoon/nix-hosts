local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

return {
	s({
		trig = "cl",
		wordTrig = true,
		snippetType = "autosnippet"
	}, 
	fmt([[
	class {} {{
		private:
			{}

		public:
			{}();
			{}(const {}& other);
			{}& operator=(const {}& other);
			~{}();

		{}
	}};
	]], {
		i(1, "ClassName"),
		i(2),
		f(function(args) return args[1][1] end, {1}),
		f(function(args) return args[1][1] end, {1}),
		f(function(args) return args[1][1] end, {1}),
		f(function(args) return args[1][1] end, {1}),
		f(function(args) return args[1][1] end, {1}),
		f(function(args) return args[1][1] end, {1}),
		i(0)
	}
))
}
