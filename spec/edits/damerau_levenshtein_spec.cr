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
    {"🍏🍎🍐🍊🍇", "🍎🍏🍐🍊🍇", 1},
    {"🍎🍏🍋🍊", "🍎🍏🍊🍋", 1},
    {"🥭🍉🌽🍎", "🍎🌽🍉🍈", 3},
    {"🍈🥭🍐🥭🍉🍐", "🍐🍉🥭🍋", 4},
    {"🍎🍋🌽", "🍋🍎🍐", 2},

    # complex transpositions
    {"a cat", "an abct", 3},
    {"a cat", "a tc", 2},
    {"raced", "dear", 4},
    {"craned", "read", 3},
    {"acer", "earn", 3},
    {"tram", "rota", 3},
    {"information", "informant", 3},
    {"roam", "art", 3},
    {"🍋🍎🍏🍊🍇", "🍇🍊🍎🍋", 4},
    {"🍏🍋🍎🍐🍊🍇", "🍋🍊🍎🍇", 3},
    {"🍎🍏🍊🍋", "🍊🍎🍋🍐", 3},
    {"🌽🍋🍎🍈", "🍋🍉🌽🍎", 3},
    {"🥭🍐🍓🍉🍋🍈🍎🌽🥭🍉🍐", "🥭🍐🍓🍉🍋🍈🍎🍐🌽", 3},
    {"🍋🍉🍎🍈", "🍎🍋🌽", 3},
  ]

  describe ".distance" do
    context "with no max distance" do
      cases.each do |(a, b, distance)|
        it "returns #{distance} for #{a}, #{b}" do
          result = Edits::DamerauLevenshtein.distance a, b
          result.should eq distance
        end
      end
    end

    context "when max is 100" do
      cases.each do |(a, b, distance)|
        it "returns #{distance} for #{a}, #{b}" do
          Edits::DamerauLevenshtein.distance(a, b, 100).should eq distance
        end
      end
    end

    context "when max is 4" do
      cases.each do |(a, b, distance)|
        it "returns lte 4 for #{a}, #{b}" do
          Edits::DamerauLevenshtein.distance(a, b, 4).should be <= 4
        end
      end

      it "returns 4 for \"\", abcdfe" do
        Edits::DamerauLevenshtein.distance("", "abcdfe", 4).should eq 4
      end

      it "returns 4 for abcdfe, \"\"" do
        Edits::DamerauLevenshtein.distance("abcdfe", "", 4).should eq 4
      end
    end

    context "when max is 0" do
      it "returns 0 for identical strings" do
        Edits::DamerauLevenshtein.distance("abc", "abc", 0).should eq 0
      end

      it "returns 0 for different strings" do
        Edits::DamerauLevenshtein.distance("abc", "abd", 0).should eq 0
      end
    end

    context "when max is less than actual distance" do
      it "returns 2 for cloud, crayon" do
        Edits::DamerauLevenshtein.distance("cloud", "crayon", 2).should eq 2
      end

      it "returns 4 for cloud, crayon" do
        Edits::DamerauLevenshtein.distance("cloud", "crayon", 4).should eq 4
      end
    end
  end
end
