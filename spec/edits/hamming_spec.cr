require "../spec_helper"

describe Edits::Hamming do
  describe ".distance" do
    it "returns nil for strings of unequal length" do
      result = Edits::Hamming.distance "foo", "barbaz"
      result.should be_nil
    end

    {
      {"", ""} => 0,
      {"foo", "foo"} => 0,
      {"foo", "bar"} => 3,
      {"toned", "roses"} => 3,
      {"1011101", "1001001"} => 2,
      {"2173896", "2233796"} => 3,
    }.each do |(a, b), distance|
      it "returns #{distance} for #{a}, #{b}" do
        result = Edits::Hamming.distance a, b
        result.should eq distance
      end
    end

    {
      {0, 0} => 0,
      {93, 73} => 2,
      {4, 69} => 2,
      {0x33333333, 0} => 16,
      {2863311530, 1431655765} => 32
    }.each do |(a, b), distance|
      it "returns #{distance} for #{a}, #{b}" do
        result = Edits::Hamming.distance a, b
        result.should eq distance
      end
    end
  end
end
