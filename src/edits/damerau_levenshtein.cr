module Edits
  # Implemention of the Damerau/Levenshtein distance algorithm.
  #
  # Determines distance between two strings by counting edits, identifying:
  # * Insertion
  # * Deletion
  # * Substitution
  # * Transposition
  module DamerauLevenshtein
    # Calculate the Damerau/Levenshtein distance of two sequences.
    #
    # `DamerauLevenshtein.distance("acer", "earn")    # => 3`
    def self.distance(str1, str2)
      # array of codepoints outperforms String
      seq1 = str1.codepoints
      seq2 = str2.codepoints

      rows = seq1.size
      cols = seq2.size
      return cols if rows == 0
      return rows if cols == 0

      # 'infinite' edit distance for padding cost matrix.
      # Can be any value greater than max[rows, cols]
      inf = rows + cols

      # Initialize first two rows of cost matrix.
      # Full initial state where cols=3, rows=2 (inf=5) would be:
      #   [[5, 5, 5, 5, 5],
      #    [5, 0, 1, 2, 3],
      #    [5, 1, 0, 0, 0],
      #    [5, 2, 0, 0, 0]]
      matrix = [Array.new(cols + 2, inf)]
      matrix << 0.upto(cols).to_a.unshift(inf)

      # element => last row seen
      item_history = Hash(Int32, Int32).new(0)

      1.upto(rows) do |row|
        # generate next row of cost matrix
        new_row = Array.new(cols + 2, 0)
        new_row[0] = inf
        new_row[1] = row
        matrix << new_row

        last_match_col = 0
        seq1_item = seq1[row - 1]

        1.upto(cols) do |col|
          seq2_item = seq2[col - 1]
          last_match_row = item_history[seq2_item]

          transposition = matrix[last_match_row][last_match_col] \
                          + (row - last_match_row - 1) \
                          + 1 \
                          + (col - last_match_col - 1)

          # TODO: do addition/deletion need to be considered when
          # seq1_item == seq2_item ?
          substitution = matrix[row][col] + (seq1_item == seq2_item ? 0 : 1)
          addition     = matrix[row + 1][col] + 1
          deletion     = matrix[row][col + 1] + 1

          # step cost is min of possible operation costs
          cost = Math.min(substitution, addition)
          cost = Math.min(cost, deletion)
          cost = Math.min(cost, transposition)

          matrix[row + 1][col + 1] = cost

          last_match_col = col if seq1_item == seq2_item
        end

        item_history[seq1_item] = row
      end

      matrix[rows + 1][cols + 1]
    end
  end
end
