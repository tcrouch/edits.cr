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
    def self.distance(str1, str2) : Int32
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
      if str1.bytesize == str1.size && str2.bytesize == str2.size
        seq1 = str1.to_slice
        seq2 = str2.to_slice

        # Strip common prefix and suffix to shrink the effective matrix
        prefix = 0
        while prefix < cols && seq1[prefix] == seq2[prefix]
          prefix += 1
        end

        suffix = 0
        cols_rem = cols - prefix
        while suffix < cols_rem && seq1[rows - 1 - suffix] == seq2[cols - 1 - suffix]
          suffix += 1
        end

        rows -= prefix + suffix
        cols -= prefix + suffix

        return rows if cols.zero?

        distance(seq1[prefix, rows], rows, seq2[prefix, cols], cols)
      else
        distance(Char::Reader.new(str1), rows, str2.chars, cols)
      end
    end

    # Unicode unbounded
    # Char::Reader avoids allocating a codepoint array for seq1.
    private def self.distance(seq1 : Char::Reader, rows : Int, seq2 : Array(Char), cols : Int) : Int32
      inf = rows + 1

      row_size = cols + 1
      all_rows = Slice(Int32).new(3 * row_size, inf)
      row_size.times { |i| all_rows[2 * row_size + i] = i }
      lastlast_row = all_rows[0, row_size]
      last_row = all_rows[row_size, row_size]
      curr_row = all_rows[2 * row_size, row_size]

      # Row 0: no transposition possible.
      curr_row, last_row, lastlast_row = lastlast_row, curr_row, last_row
      curr_row[0] = 1
      seq1_item = seq1.current_char
      seq2.each_with_index do |seq2_item, col|
        sub_cost = seq1_item == seq2_item ? 0 : 1
        curr_row[col + 1] = Math.min(
          Math.min(last_row[col] + sub_cost, last_row[col + 1] + 1),
          curr_row[col] + 1
        )
      end
      last_item = seq1_item

      (1...rows).each do |row|
        curr_row, last_row, lastlast_row = lastlast_row, curr_row, last_row
        curr_row[0] = row + 1
        seq1_item = seq1.next_char

        seq2.each_with_index do |seq2_item, col|
          sub_cost = seq1_item == seq2_item ? 0 : 1
          is_swap = sub_cost > 0 &&
                    col > 0 &&
                    last_item == seq2_item &&
                    seq1_item == seq2[col - 1]

          # | Xt |    |    |
          # |    | Xs | Xd |
          # |    | Xi | ?  |
          # substitution, deletion, insertion, transposition
          substitution = last_row[col] + sub_cost
          insertion = curr_row[col] + 1
          deletion = last_row[col + 1] + 1

          cost = Math.min(Math.min(insertion, deletion), substitution)

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

    private def self.distance(seq1, rows : Int, seq2, cols : Int) : Int32
      inf = rows + 1

      row_size = cols + 1
      all_rows = Slice(Int32).new(3 * row_size, inf)
      row_size.times { |i| all_rows[2 * row_size + i] = i }
      lastlast_row = all_rows[0, row_size]
      last_row = all_rows[row_size, row_size]
      curr_row = all_rows[2 * row_size, row_size]
      last_item = nil

      seq1.each_with_index do |seq1_item, row|
        curr_row, last_row, lastlast_row = lastlast_row, curr_row, last_row
        curr_row[0] = row + 1

        seq2.each_with_index do |seq2_item, col|
          sub_cost = seq1_item == seq2_item ? 0 : 1
          is_swap = sub_cost > 0 &&
                    row > 0 &&
                    col > 0 &&
                    last_item == seq2_item &&
                    seq1_item == seq2[col - 1]

          # | Xt |    |    |
          # |    | Xs | Xd |
          # |    | Xi | ?  |
          # substitution, deletion, insertion, transposition
          substitution = last_row[col] + sub_cost
          insertion = curr_row[col] + 1
          deletion = last_row[col + 1] + 1

          cost = Math.min(Math.min(insertion, deletion), substitution)

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
    def self.distance(str1, str2, max : Int) : Int32
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

      if str1.bytesize == str1.size && str2.bytesize == str2.size
        seq1 = str1.to_slice
        seq2 = str2.to_slice

        prefix = 0
        while prefix < cols && seq1[prefix] == seq2[prefix]
          prefix += 1
        end

        suffix = 0
        cols_rem = cols - prefix
        while suffix < cols_rem && seq1[rows - 1 - suffix] == seq2[cols - 1 - suffix]
          suffix += 1
        end

        rows -= prefix + suffix
        cols -= prefix + suffix

        if cols.zero?
          return rows > max ? max : rows
        end

        distance(seq1[prefix, rows], rows, seq2[prefix, cols], cols, max)
      else
        distance(Char::Reader.new(str1), rows, str2.chars, cols, max)
      end
    end

    private def self.distance(seq1, rows : Int, seq2, cols : Int, max : Int) : Int32
      inf = rows + 1

      row_size = cols + 1
      all_rows = Slice(Int32).new(3 * row_size, inf)
      row_size.times { |i| all_rows[2 * row_size + i] = i }
      lastlast_row = all_rows[0, row_size]
      last_row = all_rows[row_size, row_size]
      curr_row = all_rows[2 * row_size, row_size]
      last_item = nil

      prev_row_min = inf

      seq1.each_with_index do |seq1_item, row|
        curr_row, last_row, lastlast_row = lastlast_row, curr_row, last_row

        diagonal = cols - rows + row

        # Early termination: remaining ops + best achievable cost exceeds max
        remaining_chars = rows - row - 1
        min_remaining_ops = (remaining_chars - cols + diagonal).abs
        return max if row > 0 && min_remaining_ops + prev_row_min > max

        # Ukkonen base bounds
        base_min_col = row > max ? row - max : 0
        base_max_col = Math.min(row + max, cols - 1)

        # Tighten bounds using the min cost tracked from the previous row.
        # prev_row_min is tracked as a side-effect of filling the prior row.
        if row > 0 && prev_row_min < inf
          slack = max - prev_row_min
          min_col = Math.max(base_min_col, diagonal - slack)
          max_col = Math.min(base_max_col, diagonal + slack)
        else
          min_col = base_min_col
          max_col = base_max_col
        end

        # Initialize current row and reset row-minimum tracker
        curr_row[min_col] = min_col.zero? ? row + 1 : inf
        curr_row_min = inf

        min_col.upto(max_col) do |col|
          return max if diagonal == col && last_row[col] >= max

          seq2_item = seq2[col]
          sub_cost = seq1_item == seq2_item ? 0 : 1
          is_swap = sub_cost > 0 &&
                    row > 0 &&
                    col > 0 &&
                    last_item == seq2_item &&
                    seq1_item == seq2[col - 1]

          # | Xt |    |    |
          # |    | Xs | Xd |
          # |    | Xi | ?  |
          # substitution, deletion, insertion, transposition
          substitution = last_row[col] + sub_cost
          insertion = curr_row[col] + 1
          deletion = last_row[col + 1] + 1

          cost = Math.min(Math.min(insertion, deletion), substitution)

          if is_swap
            swap = lastlast_row[col - 1] + 1
            cost = Math.min(cost, swap)
          end

          curr_row[col + 1] = cost
          curr_row_min = Math.min(curr_row_min, cost)
        end

        prev_row_min = curr_row_min
        last_item = seq1_item
      end

      curr_row[cols] > max ? max : curr_row[cols]
    end
  end
end
