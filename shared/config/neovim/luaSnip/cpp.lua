local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

return {
  s({
    trig = "cl",
    wordTrig = true  -- Only trigger when "cl" is a separate word
  }, {
    t("class "), i(1, "ClassName"), t({" {", ""}),
    t("private:"),
    t({"", "    "}), i(2),
    t({"", "", "public:"}),
    t({"", "    "}), f(function(args) return args[1][1] end, {1}), t("();"),
    t({"", "    "}), f(function(args) return args[1][1] end, {1}), t("(const "), 
    f(function(args) return args[1][1] end, {1}), t("& other);"),
    t({"", "    "}), f(function(args) return args[1][1] end, {1}), t("& operator=(const "), 
    f(function(args) return args[1][1] end, {1}), t("& other);"),
    t({"", "    ~"}), f(function(args) return args[1][1] end, {1}), t("();"),
    t({"", "", "    "}), i(0),
    t({"", "};"})
  })
}
