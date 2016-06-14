require "bit_array"

module Edits
  # Jaro similarity measure.
  #
  # `Sj = 1/3 * ((m / |A|) + (m / |B|) + ((m - t) / m))`
  #
  # Where `m` is #matches and `t` is #transposes
  #
  # see https://en.wikipedia.org/wiki/Jaro-Winkler_distance
  module Jaro
    # Calculate Jaro similarity, where 1 is an exact match and 0 is
    # no similarity.
    #
    # ```
    # Jaro.distance('information', 'informant')
    # # => 0.9023569023569024
    # ```
    def self.similarity(str1, str2)
      return 1.0 if str1 == str2
      return 0.0 if str1.empty? || str2.empty?

      seq1 = str1.codepoints
      seq2 = str2.codepoints

      m, t = matches(seq1, seq2)
      return 0.0 if m == 0

      m = m.to_f
      (1.0 / 3) * ((m / str1.size) + (m / str2.size) + ((m - t) / m))
    end

    # Calculate Jaro distance, where 0 is an exact match and 1
    # is no similarity.
    # ```
    # Jaro.distance "information", "informant"
    # # => 0.097643097643097643
    # ```
    def self.distance(str1, str2)
      1.0 - similarity(str1, str2)
    end

    # Calculate number of Jaro matches and transpositions
    private def self.matches(seq1, seq2)
      # search range: (max(|A|, |B|) / 2) - 1
      seq1, seq2 = seq2, seq1 if seq1.size > seq2.size
      seq1_length = seq1.size
      range = (seq2.size / 2) - 1
      range = 0 if range < 0

      seq1_flags = BitArray.new(seq1_length, false)
      seq2_flags = BitArray.new(seq2.size, false)

      matches = 0
      last2 = seq2.size - 1

      # Pass 1:
      # - determine number of matches
      # - initialize transposition flags
      seq1_length.times do |i|
        min_bound = (i >= range) ? i - range : 0
        max_bound = (i + range) <= last2 ? (i + range) : last2

        min_bound.upto(max_bound) do |j|
          next unless seq2_flags[j] != true && seq2[j] == seq1[i]

          seq2_flags[j] = true
          seq1_flags[i] = true
          matches += 1
          break
        end
      end

      return [0, 0] if matches == 0

      transposes = 0
      j = 0

      # Pass 2: determine number of half-transpositions
      seq1_length.times do |i|
        # find a match in first string
        next unless seq1_flags[i] == true
        # go to location of next match on second string
        until seq2_flags[j]
          j += 1
        end

        # transposition if not the current match
        transposes += 1 if seq1[i] != seq2[j]
        j += 1
      end

      # half-transpositions -> transpositions
      transposes /= 2

      {matches, transposes}
    end
  end
end
