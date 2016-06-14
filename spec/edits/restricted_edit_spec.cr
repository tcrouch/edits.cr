require "../spec_helper"
require "./levenshtein_shared"

describe Edits::RestrictedEdit do
  describe ".distance" do
    cases = SHARED_CASES + [
      # swaps
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

      # complex transpositions
      {"a cat", "an abct", 4},
      {"a cat", "a tc", 3},
      {"raced", "dear", 5},
      {"craned", "read", 4},
      {"acer", "earn", 4},
      {"tram", "rota", 4},
      {"information", "informant", 4},
      {"roam", "art", 4}
    ]

    cases.each do |(a, b, distance)|
      it "returns #{distance} for #{a}, #{b}" do
        result = Edits::RestrictedEdit.distance a, b
        result.should eq distance
      end
    end
  end
end
