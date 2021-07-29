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
    def self.distance(str1, str2) : Int
      rows = str1.size
      cols = str2.size
      str1, str2, rows, cols = str2, str1, cols, rows if rows < cols

      return cols if rows.zero?
      return rows if cols.zero?

      # If the strings contain only single-byte characters, compare the
      # raw values without decoding.
      # Otherwise, decode the chars. The first string is only iterated over
      # once, so avoid storing its chars.
      if str1.single_byte_optimizable? && str2.single_byte_optimizable?
        _distance(str1.to_slice, rows, str2.to_slice, cols)
      else
        _distance(Char::Reader.new(str1), rows, str2.chars, cols)
      end
    end

    private def self._distance(seq1, rows : Int, seq2, cols : Int) : Int
      # "Infinite" edit distance for padding cost matrix.
      # Any value > max[rows, cols]
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
      last_item = Nil

      seq1.each_with_index do |seq1_item, row|
        # rotate matrix rows and initialize current row
        curr_row, last_row, lastlast_row = lastlast_row, curr_row, last_row
        curr_row[0] = row + 1

        seq2.each_with_index do |seq2_item, col|
          sub_cost = seq1_item == seq2_item ? 0 : 1
          is_swap = sub_cost > 0 &&
                    row > 0 && col > 0 &&
                    last_item == seq2_item &&
                    seq1_item == seq2[col - 1]

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
        last_item = seq1_item
      end

      curr_row[cols]
    end

    # Calculate the Restricted Damerau-Levenshtein distance (Optimal Alignment)
    # of two sequences, bounded by a maximum value.
    #
    # ```
    # Edits::RestrictedEdit.distance("cloud", "crayon")    # => 5
    # Edits::RestrictedEdit.distance("cloud", "crayon", 2) # => 2
    # ```
    def self.distance(str1, str2, max : Int) : Int
      rows = str1.size
      cols = str2.size
      str1, str2, rows, cols = str2, str1, cols, rows if rows < cols

      return cols > max ? max : cols if rows.zero?
      return rows > max ? max : rows if cols.zero?
      return max if rows - cols >= max

      if str1.single_byte_optimizable? && str2.single_byte_optimizable?
        _distance(str1.to_slice, rows, str2.to_slice, cols, max)
      else
        _distance(Char::Reader.new(str1), rows, str2.chars, cols, max)
      end
    end

    private def self._distance(seq1, rows : Int, seq2, cols : Int, max : Int) : Int
      # "Infinite" edit distance for padding cost matrix.
      # Any value > max[rows, cols]
      inf = rows + 1

      # retain previous two rows of cost matrix,
      # padded with "inf" as matrix is not fully evaluated
      lastlast_row = Slice.new(cols + 1, inf)
      last_row = Slice.new(cols + 1, inf)
      curr_row = Slice.new(cols + 1) { |i| i }
      last_item = Nil

      seq1.each_with_index do |seq1_item, row|
        # rotate matrix rows
        curr_row, last_row, lastlast_row = lastlast_row, curr_row, last_row

        # Ukkonen cut-off
        min_col = row > max ? row - max : 0
        max_col = row + max
        max_col = cols - 1 if max_col > cols - 1
        diagonal = cols - rows + row

        # Initialize current row
        curr_row[min_col] = min_col.zero? ? row + 1 : inf

        min_col.upto(max_col) do |col|
          return max if diagonal == col && last_row[col] >= max

          seq2_item = seq2[col]
          sub_cost = seq1_item == seq2_item ? 0 : 1
          is_swap = sub_cost > 0 &&
                    row > 0 && col > 0 &&
                    last_item == seq2_item &&
                    seq1_item == seq2[col - 1]

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
        last_item = seq1_item
      end

      curr_row[cols] > max ? max : curr_row[cols]
    end
  end
end
