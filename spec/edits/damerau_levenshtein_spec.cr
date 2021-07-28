require "../spec_helper"
require "./levenshtein_shared"

describe Edits::DamerauLevenshtein do
  cases = SHARED_CASES + [
    # simple transpositions
    {"abc", "acb", 1},
    {"abc", "bac", 1},
    {"abcdef", "abcdfe", 1},
    {"abcdefghij", "acbdegfhji", 3},
    {"a cat", "an act", 2},
    {"caned", "acned", 1},
    {"acre", "acer", 1},
    {"iota", "atom", 3},
    {"minion", "noir", 4},
    {"art", "ran", 2},
    {"🍎🍏🍋🍊", "🍎🍏🍊🍋", 1},

    # complex transpositions
    {"a cat", "an abct", 3},
    {"a cat", "a tc", 2},
    {"raced", "dear", 4},
    {"craned", "read", 3},
    {"acer", "earn", 3},
    {"tram", "rota", 3},
    {"information", "informant", 3},
    {"roam", "art", 3},
    {"🍎🍐🍏🍊", "🍏🍎🍊🍋", 3},
  ]

  describe ".distance" do
    cases.each do |(a, b, distance)|
      it "returns #{distance} for #{a}, #{b}" do
        result = Edits::DamerauLevenshtein.distance a, b
        result.should eq distance
      end
    end
  end
end
