module Edits
  # Implements Restricted Damerau-Levenshtein distance (Optimal Alignment)
  # algorithm.
  #
  # Determines distance between two strings by counting edits, identifying:
  # * Insertion
  # * Deletion
  # * Substitution
  # * Adjacent transposition
  #
  # This variant is restricted by the condition that no sub-string is edited
  # more than once.
  module RestrictedEdit
    # Calculate the Restricted Damerau-Levenshtein distance (Optimal Alignment)
    # of two sequences.
    #
    # Note: Not a true distance metric, fails to satisfy triangle inequality.
    #
    # `RestrictedEdit.distance("iota", "atom")    # => 3`
    def self.distance(str1, str2)
      # array of codepoints outperforms String
      seq1 = str1.codepoints
      seq2 = str2.codepoints

      rows = seq1.size
      cols = seq2.size
      return cols if rows == 0
      return rows if cols == 0

      # previous two rows of cost matrix are retained
      lastlast_row = [] of Int32
      last_row = [] of Int32
      # Initialize first row of cost matrix.
      # Full initial state where cols=3, rows=2 would be:
      #   [[0, 1, 2, 3],
      #    [1, 0, 0, 0],
      #    [2, 0, 0, 0]]
      curr_row = 0.upto(cols).to_a

      rows.times do |row|
        lastlast_row = last_row
        last_row = curr_row

        # generate next row of cost matrix
        curr_row = Array.new(cols + 1, 0)
        curr_row[0] = row + 1

        curr_item = seq1[row]

        cols.times do |col|
          sub_cost = curr_item == seq2[col] ? 0 : 1
          is_swap = sub_cost == 1 &&
            row > 0 &&
            col > 0 &&
            curr_item == seq2[col - 1] &&
            seq1[row - 1] == seq2[col]

          deletion = last_row[col + 1] + 1
          insertion = curr_row[col] + 1
          substitution = last_row[col] + sub_cost

          # step cost is min of possible operation costs
          cost = Math.min(insertion, deletion)
          cost = Math.min(cost, substitution)

          if is_swap
            swap = lastlast_row[col - 1] + 1
            cost = Math.min(cost, swap)
          end

          curr_row[col + 1] = cost
        end
      end

      curr_row[cols]
    end
  end
end
