module Edits
  # Levenshtein edit distance.
  #
  # Determines distance between two string by counting edits, identifying:
  # * Insertion
  # * Deletion
  # * Substitution
  module Levenshtein
    extend Compare

    # Calculate the Levenshtein (edit) distance of two sequences.
    #
    # NOTE: a true distance metric, satisfies triangle inequality.
    #
    # ```
    # Levenshtein.distance("sand", "hands") # => 2
    # ```
    def self.distance(str1, str2) : Int
      rows = str1.size
      cols = str2.size

      return cols if rows.zero?
      return rows if cols.zero?

      # Minimise size of matrix row we store
      if rows < cols
        str1, str2 = str2, str1
        rows, cols = cols, rows
      end

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
      # Initialize first row of cost matrix.
      # Full initial state where cols=2, rows=3 would be:
      #   [[0, 1, 2],
      #    [1, 0, 0],
      #    [2, 0, 0]
      #    [3, 0, 0]]
      last_row = Slice(Int32).new(cols + 1) { |i| i }

      seq1.each_with_index do |seq1_item, row|
        previous_cost = row + 1

        seq2.each_with_index do |seq2_item, col|
          # | Xs | Xd |
          # | Xi | ?  |
          # substitution, deletion, insertion
          substitution = last_row[col] + (seq1_item == seq2_item ? 0 : 1)
          insertion = previous_cost + 1
          deletion = last_row[col + 1] + 1

          # Overwrite previous row as we progress
          last_row[col] = previous_cost

          # Record the current cost.
          # Step cost is min of operation costs
          previous_cost = Math.min(Math.min(insertion, deletion), substitution)
        end
        last_row[cols] = previous_cost
      end

      last_row[cols]
    end

    # Calculate the Levenshtein (edit) distance of two sequences, bounded
    # by a maximum value.
    #
    # ```
    # Levenshtein.distance("cloud", "crayon")    # => 5
    # Levenshtein.distance("cloud", "crayon", 2) # => 2
    # ```
    def self.distance(str1, str2, max : Int) : Int
      rows = str1.size
      cols = str2.size

      return cols > max ? max : cols if rows.zero?
      return rows > max ? max : rows if cols.zero?

      # Minimise size of matrix row we store
      if rows < cols
        str1, str2 = str2, str1
        rows, cols = cols, rows
      end

      return max if rows - cols >= max

      if str1.single_byte_optimizable? && str2.single_byte_optimizable?
        _distance(str1.to_slice, rows, str2.to_slice, cols, max)
      else
        _distance(Char::Reader.new(str1), rows, str2.chars, cols, max)
      end
    end

    private def self._distance(seq1, rows : Int, seq2, cols : Int, max : Int) : Int
      # "Infinite" edit distance to pad cost matrix.
      # Any value > max[rows, cols]
      inf = rows + 1

      # Retain previous row of cost matrix
      last_row = Slice(Int32).new(cols + 1) { |i| i }

      seq1.each_with_index do |seq1_item, row|
        # Ukkonen cut-off
        min_col = row > max ? row - max : 0
        max_col = row + max
        max_col = cols - 1 if max_col > cols - 1
        diagonal = cols - rows + row

        previous_cost = min_col.zero? ? row + 1 : inf

        min_col.upto(max_col) do |col|
          return max if diagonal == col && last_row[col] >= max

          seq2_item = seq2[col]

          # | Xs | Xd |
          # | Xi | ?  |
          # substitution, deletion, insertion
          substitution = last_row[col] + (seq1_item == seq2_item ? 0 : 1)
          insertion = previous_cost + 1
          deletion = last_row[col + 1] + 1

          # Overwrite previous row as we progress
          last_row[col] = previous_cost

          # Record the current cost.
          # Step cost is min of operation costs
          previous_cost = Math.min(Math.min(insertion, deletion), substitution)
        end

        last_row[cols] = previous_cost
      end

      last_row[cols] > max ? max : last_row[cols]
    end
  end
end
