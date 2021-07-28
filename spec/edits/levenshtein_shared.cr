SHARED_CASES = [
  # equal
  {"a", "a", 0},
  {"one", "one", 0},

  # empty
  {"", "", 0},
  {"abc", "", 3},
  {"", "abc", 3},

  # no common
  {"abc", "d", 3},
  {"d", "abc", 3},
  {"foo", "bar", 3},
  {"bar", "foo", 3},

  # multi byte characters
  {"", "🍋", 1},
  {"🍊", "", 1},
  {"🍏", "🍏", 0},
  {"🔭☄️🌌🌔", "space", 5},
  {"space", "🔭☄️🌌🌔", 5},
  {"😀😆🙃😵‍💫😇", "😶😆🙃😵‍💫😀😂", 3},
  {"😶😆🙃😵‍💫😀😂", "😀😆🙃😵‍💫😇", 3},

  # insertion
  {"mitten", "mittens", 1},
  {"mitten", "smitten", 1},
  {"fog", "frog", 1},
  {"pit", "pint", 1},
  {"tom", "thom", 1},
  {"tom", "thomas", 3},

  # deletion
  {"mittens", "mitten", 1},
  {"smitten", "mitten", 1},
  {"frog", "fog", 1},
  {"pint", "pit", 1},
  {"thom", "tom", 1},
  {"thomas", "tom", 3},

  # substitution
  {"rat", "ran", 1},
  {"ran", "fan", 1},
  {"saturday", "caturday", 1},
  {"book", "back", 2},
  {"raked", "baker", 2},

  # multiple edits
  {"sittings", "kitting", 2},
  {"sunday", "saturday", 3},
  {"kitten", "sitting", 3},
  {"raked", "bakers", 3},
  {"phish", "fish", 2},
]
