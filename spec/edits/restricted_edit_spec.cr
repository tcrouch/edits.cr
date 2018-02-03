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
      {"roam", "art", 4},
    ]

    describe ".distance" do
      context "with no max distance" do
        cases.each do |(a, b, distance)|
          it "returns #{distance} for #{a}, #{b}" do
            result = Edits::RestrictedEdit.distance a, b
            result.should eq distance
          end
        end
      end

      context "when max is 100" do
        cases.each do |(a, b, distance)|
          it "returns #{distance} for #{a}, #{b}" do
            Edits::RestrictedEdit.distance(a, b, 100).should eq distance
          end
        end
      end

      context "when max is 4" do
        cases.each do |(a, b, distance)|
          it "returns lte 4 for #{a}, #{b}" do
            Edits::RestrictedEdit.distance(a, b, 4).should be <= 4
          end
        end

        it "returns 4 for \"\", abcdfe" do
          Edits::RestrictedEdit.distance("", "abcdfe", 4).should eq 4
        end

        it "returns 4 for abcdfe, \"\"" do
          Edits::RestrictedEdit.distance("abcdfe", "", 4).should eq 4
        end
      end
    end
  end

  describe ".most_similar" do
    context "with empty enumerable" do
      it "raises empty error" do
        expect_raises(Enumerable::EmptyError) { Edits::RestrictedEdit.most_similar("foo", [] of String) }
      end
    end

    context "with a single element" do
      it "returns the element" do
        Edits::RestrictedEdit.most_similar("foo", ["bar"]).should eq "bar"
      end
    end

    context "with multiple elements" do
      it "returns the element with the least distance" do
        strings = %w(iota roam acre iconic iron seed arm read mine atom farm earn ran ionic distance)
        Edits::RestrictedEdit.most_similar("minion", strings).should eq "iron"
      end
    end
  end
end
