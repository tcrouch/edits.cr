module Edits
  # Restricted Damerau-Levenshtein edit distance (Optimal Alignment).
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
    extend Compare

    # Calculate the Restricted Damerau-Levenshtein distance (Optimal Alignment)
    # of two sequences.
    #
    # NOTE: Not a true distance metric, fails to satisfy triangle inequality.
    #
    # ```
    # RestrictedEdit.distance("iota", "atom") # => 3
    # ```
    def self.distance(str1, str2)
      rows = str1.size
      cols = str2.size
      str1, str2, rows, cols = str2, str1, cols, rows if rows < cols

      return cols if rows.zero?
      return rows if cols.zero?

      seq1 = str1.codepoints
      seq2 = str2.codepoints

      # 'infinite' edit distance for padding cost matrix.
      # Can be any value > max[rows, cols]
      inf = rows + 1

      # retain previous two rows of cost matrix
      lastlast_row = Slice(Int32).new(cols + 1, inf)
      last_row = Slice(Int32).new(cols + 1, inf)

      # Initialize first row of cost matrix.
      # Full initial state where cols=3, rows=2 would be:
      #   [[0, 1, 2, 3],
      #    [1, 0, 0, 0],
      #    [2, 0, 0, 0]]
      curr_row = Slice.new(cols + 1) { |i| i }

      rows.times do |row|
        # rotate matrix rows
        curr_row, last_row, lastlast_row = lastlast_row, curr_row, last_row

        curr_row[0] = row + 1
        seq1_item = seq1[row]

        cols.times do |col|
          sub_cost = seq1_item == seq2[col] ? 0 : 1
          is_swap = sub_cost == 1 &&
                    row > 0 && col > 0 &&
                    seq1_item == seq2[col - 1] &&
                    seq1[row - 1] == seq2[col]

          # | Xt |    |    |
          # |    | Xs | Xd |
          # |    | Xi | ?  |
          # substitution, deletion, insertion, transposition
          substitution = last_row[col] + sub_cost
          deletion = last_row[col + 1] + 1
          insertion = curr_row[col] + 1

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

    # Calculate the Restricted Damerau-Levenshtein distance (Optimal Alignment)
    # of two sequences, bounded by a maximum value.
    # For low max values, this can be highly performant.
    #
    # ```
    # Edits::RestrictedEdit.distance("cloud", "crayon")    # => 5
    # Edits::RestrictedEdit.distance("cloud", "crayon", 2) # => 2
    # ```
    def self.distance(str1, str2, max : Int)
      rows = str1.size
      cols = str2.size
      str1, str2, rows, cols = str2, str1, cols, rows if rows < cols

      return cols > max ? max : cols if rows.zero?
      return rows > max ? max : rows if cols.zero?
      return max if rows - cols >= max

      seq1 = str1.codepoints
      seq2 = str2.codepoints

      # 'infinite' edit distance for padding cost matrix.
      # Can be any value > max[rows, cols]
      inf = rows + 1

      # retain previous two rows of cost matrix,
      # padded with "inf" as matrix is not fully evaluated
      lastlast_row = Slice.new(cols + 1, inf)
      last_row = Slice.new(cols + 1, inf)
      curr_row = Slice.new(cols + 1) { |i| i }

      rows.times do |row|
        # rotate matrix rows
        curr_row, last_row, lastlast_row = lastlast_row, curr_row, last_row

        # Ukkonen cut-off
        min_col = row > max ? row - max : 0
        max_col = row + max
        max_col = cols - 1 if max_col > cols - 1

        curr_row[min_col] = min_col.zero? ? row + 1 : inf
        seq1_item = seq1[row]
        diagonal = cols - rows + row

        min_col.upto(max_col) do |col|
          return max if diagonal == col && last_row[col] >= max

          sub_cost = seq1_item == seq2[col] ? 0 : 1
          is_swap = sub_cost == 1 &&
                    row > 0 && col > 0 &&
                    seq1_item == seq2[col - 1] &&
                    seq1[row - 1] == seq2[col]

          # | Xt |    |    |
          # |    | Xs | Xd |
          # |    | Xi | ?  |
          # substitution, deletion, insertion, transposition
          substitution = last_row[col] + sub_cost
          deletion = last_row[col + 1] + 1
          insertion = curr_row[col] + 1

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

      curr_row[cols] > max ? max : curr_row[cols]
    end
  end
end
