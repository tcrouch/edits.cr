module Edits
  # Jaro-Winkler similarity measure.
  #
  # When Jaro similarity exceeds a threshold, the Winkler extension adds
  # additional weighting if a common prefix exists.
  #
  # See also:
  # * [Wikipedia](https://en.wikipedia.org/wiki/Jaro-Winkler_distance)
  module JaroWinkler
    # Prefix scaling factor for jaro-winkler metric. Default is 0.1
    # Should not exceed 0.25 or metric range will leave 0..1
    WINKLER_PREFIX_WEIGHT = 0.1

    # Threshold for boosting Jaro with Winkler prefix multiplier.
    # Default is 0.7
    WINKLER_THRESHOLD = 0.7

    # Calculate Jaro-Winkler similarity, where 1 is an exact match and 0 is
    # no similarity.
    #
    # `Sw = Sj + (l * p * (1 - Sj))`
    #
    # Where `Sj` is Jaro, `l` is prefix length, and `p` is prefix weight
    #
    # ```
    # JaroWinkler.similarity("information", "informant")
    # # => 0.9414141414141414
    # ```
    # NOTE: not a true distance metric, fails to satisfy triangle inequality.
    def self.similarity(str1, str2,
                        threshold = WINKLER_THRESHOLD,
                        weight = WINKLER_PREFIX_WEIGHT) : Float
      sj = Jaro.similarity(str1, str2)

      if sj > threshold
        # size of common prefix, max 4
        max_bound = Math.min(str2.size, str1.size)
        max_bound = 4 if max_bound > 4

        l = 0
        until l >= max_bound || str1[l] != str2[l]
          l += 1
        end

        (l < 1) ? sj : sj + (l * weight * (1 - sj))
      else
        sj
      end
    end

    # Calculate Jaro-Winkler distance, where 0 is an exact match and 1
    # is no similarity.
    #
    # `Dw = 1 - similarity`
    #
    # ```
    # JaroWinkler.distance "information", "informant"
    # # => 0.05858585858585863
    # ```
    def self.distance(str1, str2,
                      threshold = WINKLER_THRESHOLD,
                      weight = WINKLER_PREFIX_WEIGHT) : Float
      1.0 - similarity(str1, str2, threshold, weight)
    end
  end
end
