require "../spec_helper"
require "./levenshtein_shared"

describe Edits::Levenshtein do
  cases = SHARED_CASES + [
    # swaps
    {"abc", "acb", 2},
    {"abc", "bac", 2},
    {"abcdef", "abcdfe", 2},
    {"abcdefghij", "acbdegfhji", 6},
    {"a cat", "an act", 3},
    {"caned", "acned", 2},
    {"acre", "acer", 2},
    {"iota", "atom", 4},
    {"minion", "noir", 5},
    {"art", "ran", 3},

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

  describe ".distance" do
    context "without a max distance" do
      cases.each do |(a, b, distance)|
        it "returns #{distance} for #{a}, #{b}" do
          result = Edits::Levenshtein.distance a, b
          result.should eq distance
        end
      end
    end

    context "with max distance" do
      cases.each do |(a, b, distance)|
        it "returns #{distance} for #{a}, #{b}" do
          result = Edits::Levenshtein.distance a, b, 100
          result.should eq distance
        end
      end

      it "does not exceed the given maximum" do
        Edits::Levenshtein.distance("foo", "barbaz", 2).should eq 2
      end
    end
  end

  describe ".most_similar" do
    context "with empty enumerable" do
      it "raises empty error" do
        expect_raises(Enumerable::EmptyError) { Edits::Levenshtein.most_similar("foo", [] of String) }
      end
    end

    context "with a single element" do
      it "returns the element" do
        Edits::Levenshtein.most_similar("foo", ["bar"]).should eq "bar"
      end
    end

    context "with multiple elements" do
      it "returns the element with the least distance" do
        strings = %w(iota roam acre iconic iron seed arm read mine atom farm earn ran ionic distance)
        Edits::Levenshtein.most_similar("minion", strings).should eq "iron"
      end
    end
  end
end
