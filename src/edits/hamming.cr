module Edits
  module Hamming
    # Calculate the Hamming distance between two sequences.
    #
    # NOTE: a true distance metric, satisfies triangle inequality.
    def self.distance(seq1, seq2)
      length = seq1.size
      return nil if length != seq2.size

      distance = 0
      length.times do |i|
        distance += 1 if seq1[i] != seq2[i]
      end
      distance
    end

    # Calculate Hamming distance between the bits comprising two integers
    def self.distance(seq1 : Int, seq2 : Int)
      (seq1 ^ seq2).popcount
    end
  end
end
