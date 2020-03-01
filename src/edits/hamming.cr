module Edits
  module Hamming
    # Calculate the Hamming distance between two sequences.
    #
    # Note: a true distance metric, satisfies triangle inequality.
    def self.distance(seq1, seq2)
      return nil if (length = seq1.size) != seq2.size

      length.times.reduce(0) do |distance, i|
        seq1[i] == seq2[i] ? distance : distance + 1
      end
    end

    def self.distance(seq1 : Int, seq2 : Int)
      (seq1 ^ seq2).popcount
    end
  end
end
