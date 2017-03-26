require "../spec_helper"

describe Edits::JaroWinkler do
  describe ".similarity" do
    {
      {"", ""}  => 1,
      {"", "a"} => 0,
      {"a", ""} => 0,

      {"abc", "abc"}               => 1,
      {"abc", "def"}               => 0,
      {"martha", "marhta"}         => 0.961,
      {"dwayne", "duane"}          => 0.84,
      {"dixon", "dicksonx"}        => 0.813,
      {"rear", "aerial"}           => 0.639,
      {"jones", "johnson"}         => 0.832,
      {"acer", "earn"}             => 0.667,
      {"minion", "noir"}           => 0.444,
      {"abcvwxyz", "cabvwxyz"}     => 0.958,
      {"information", "informant"} => 0.941,
      {"necessary", "nessecary"}   => 0.941,
    }.each do |(a, b), expected|
      it "returns #{expected} for #{a} vs. #{b}" do
        similarity = Edits::JaroWinkler.similarity(a, b)
        similarity.round(3).should eq expected
      end
    end

    context "with a custom threshold" do
      it "returns jaro when lt threshold" do
        similarity = Edits::JaroWinkler.similarity "abcde", "abdef", threshold: 0.87
        similarity.round(3).should eq 0.867
      end

      it "returns jaro-winkler when gt threshold" do
        similarity = Edits::JaroWinkler.similarity "abcde", "abdef", threshold: 0.86
        similarity.round(3).should eq 0.893
      end
    end
  end

  describe ".distance" do
    {
      {"", ""}           => 0,
      {"", "a"}          => 1,
      {"a", ""}          => 1,
      {"acer", "earn"}   => 0.333,
      {"minion", "noir"} => 0.556,
    }.each do |(a, b), expected|
      it "returns #{expected} for #{a} vs. #{b}" do
        distance = Edits::JaroWinkler.distance(a, b)
        distance.round(3).should eq expected
      end
    end

    context "with a custom threshold" do
      it "returns jaro when lt threshold" do
        distance = Edits::JaroWinkler.distance "abcde", "abdef", threshold: 0.87
        distance.round(3).should eq 0.133
      end

      it "returns jaro-winkler when gt threshold" do
        distance = Edits::JaroWinkler.distance "abcde", "abdef", threshold: 0.86
        distance.round(3).should eq 0.107
      end
    end
  end
end
