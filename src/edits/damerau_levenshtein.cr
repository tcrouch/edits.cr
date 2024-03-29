module Edits
  # Damerau-Levenshtein edit distance.
  #
  # Determines distance between two strings by counting edits, identifying:
  # * Insertion
  # * Deletion
  # * Substitution
  # * Adjacent transposition
  module DamerauLevenshtein
    # Calculate the Damerau-Levenshtein distance of two sequences.
    #
    # ```
    # DamerauLevenshtein.distance("acer", "earn") # => 3
    # ```
    def self.distance(str1, str2) : Int
      rows = str1.size
      cols = str2.size
      str1, str2, rows, cols = str2, str1, cols, rows if rows > cols

      return cols if rows.zero?
      return rows if cols.zero?

      seq1 = str1.codepoints
      seq2 = str2.codepoints

      # 'infinite' edit distance to pad cost matrix.
      # Any value > max[rows, cols]
      inf = cols + 1

      # element => last row seen
      row_history = Hash(Int32, Int32).new(0)

      # initialize alphabet-keyed cost matrix
      curr_row = Slice.new(cols + 1) { |i| i }
      matrix = Hash(Int32, typeof(curr_row)).new

      rows.times do |row|
        seq1_item = seq1[row]
        match_col = 0

        # rotate matrix rows & generate next
        matrix[seq1_item] = last_row = curr_row
        curr_row = Slice.new(cols + 1, inf)
        curr_row[0] = row + 1

        cols.times do |col|
          seq2_item = seq2[col]
          sub_cost = seq1_item == seq2_item ? 0 : 1

          # | Xs | Xd |
          # | Xi | ?  |
          # substitution, deletion, insertion
          cost = Math.min(
            last_row[col] + sub_cost,
            last_row[col + 1] + 1
          )
          cost = Math.min(cost, curr_row[col] + 1)

          # transposition cost
          # skip missed matrix lookup (inf cost)
          if sub_cost > 0 && row > 0 && (m = matrix[seq2_item]?)
            transpose = 1 + m[match_col] \
              + (row - row_history[seq2_item] - 1) \
                + (col - match_col - 1)
            cost = Math.min(cost, transpose)
          end

          match_col = col if sub_cost == 0
          curr_row[col + 1] = cost
        end

        row_history[seq1_item] = row
      end

      curr_row[cols]
    end
  end
end
