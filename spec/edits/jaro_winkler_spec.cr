require "../spec_helper"

describe Edits::Jaro do
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
    end
  end
end
