require "../spec_helper"

module Edits::Jaro
  def self.jaro_matches(str1, str2)
    matches(str1, str2)
  end
end

describe Edits::Jaro do
  describe ".similarity" do
    {
      {"", ""} => 1,
      {"", "a"} => 0,
      {"a", ""} => 0,

      {"abc", "abc"} => 1,
      {"abc", "def"} => 0,
      {"martha", "marhta"} => 0.944,
      {"dwayne", "duane"} => 0.822,
      {"dixon", "dicksonx"} => 0.767,
      {"rear", "aerial"} => 0.639,
      {"jones", "johnson"} => 0.790,
      {"acer", "earn"} => 0.667,
      {"minion", "noir"} => 0.444,
      {"abcvwxyz", "cabvwxyz"} => 0.958,
      {"information", "informant"} => 0.902,
      {"necessary", "nessecary"} => 0.926
    }.each do |(a, b), expected|
      it "returns #{expected} for #{a} vs. #{b}" do
        similarity = Edits::Jaro.similarity(a, b)
        similarity.round(3).should eq expected
      end
    end
  end

  describe ".distance" do
    {
      {"", ""} => 0,
      {"", "a"} => 1,
      {"a", ""} => 1,
      {"acer", "earn"} => 0.333,
      {"minion", "noir"} => 0.556
    }.each do |(a, b), expected|
      it "returns #{expected} for #{a} vs. #{b}" do
        distance = Edits::Jaro.distance(a, b)
        distance.round(3).should eq expected
      end
    end
  end

  describe ".matches" do
    {
      {"", ""} => {0, 0},
      {"", "a"} => {0, 0},
      {"a", ""} => {0, 0},

      {"abc", "abc"} => {3, 0},
      {"abc", "def"} => {0, 0},
      {"martha", "marhta"} => {6, 1},
      {"jones", "johnson"} => {4, 0},
      {"acer", "earn"} => {2, 0},
      {"minion", "noir"} => {2, 1},
      {"abcvwxyz", "cabvwxyz"} => {8, 1},
      {"dwayne", "duane"} => {4, 0},
      {"rear", "aerial"} => {3, 1},
      {"dixon", "dicksonx"} => {4, 0},
      {"information", "informant"} => {9, 1},
      {"necessary", "nessecary"} => {9, 2}
    }.each do |(a, b), result|
      it "returns #{result.first} matches for #{a} vs. #{b}" do
        matches = Edits::Jaro.jaro_matches(a, b).first
        matches.should eq result.first
      end

      it "returns #{result.last} transposes for #{a} vs. #{b}" do
        transposes = Edits::Jaro.jaro_matches(a, b).last
        transposes.should eq result.last
      end
    end
  end
end
