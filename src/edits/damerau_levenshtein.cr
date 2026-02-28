module Edits
  # Damerau-Levenshtein edit distance.
  #
  # Determines distance between two strings by counting edits, identifying:
  # * Insertion
  # * Deletion
  # * Substitution
  # * Adjacent transposition
  module DamerauLevenshtein
    extend Compare

    # Calculate the Damerau-Levenshtein distance of two sequences.
    #
    # ```
    # DamerauLevenshtein.distance("acer", "earn") # => 3
    # ```
    def self.distance(str1, str2) : Int32
      rows = str1.size
      cols = str2.size
      str1, str2, rows, cols = str2, str1, cols, rows if rows > cols

      return cols if rows.zero?
      return rows if cols.zero?

      # If the strings contain only single-byte characters, compare the raw
      # values without decoding and use array-indexed lookups (0-255) in place
      # of hash operations for row_history and matrix.
      if str1.ascii_only? && str2.ascii_only?
        distance(str1.to_slice, rows, str2.to_slice, cols)
      else
        distance(str1.codepoints, rows, str2.codepoints, cols)
      end
    end

    private def self.distance(seq1 : Bytes, rows : Int, seq2 : Bytes, cols : Int) : Int32
      inf = cols + 1

      # row_map[byte] encodes both row_history and matrix: it stores the row
      # index r where byte was last seq1_item; -1 means never seen.
      row_map = StaticArray(Int32, 256).new(-1)

      row_size = cols + 1
      all_data = Slice(Int32).new((rows + 1) * row_size, inf)
      row_size.times { |i| all_data[i] = i }
      curr_row = all_data[0, row_size]

      rows.times do |row|
        seq1_item = seq1[row]
        match_col = 0

        last_row = curr_row
        curr_row = all_data[(row + 1) * row_size, row_size]
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
          if sub_cost > 0
            prev_row_idx = row_map[seq2_item]

            if prev_row_idx >= 0
              prev_row = all_data[prev_row_idx * row_size, row_size]
              transpose = 1 + prev_row[match_col] \
                + (row - prev_row_idx - 1) \
                + (col - match_col - 1)
              cost = Math.min(cost, transpose)
            end
          end

          match_col = col if sub_cost == 0
          curr_row[col + 1] = cost
        end

        row_map[seq1_item] = row
      end

      curr_row[cols]
    end

    private def self.distance(seq1 : Array(Int32), rows : Int, seq2 : Array(Int32), cols : Int) : Int32
      inf = cols + 1

      # char => last row index seen; -1 means never seen.
      row_map = Hash(Int32, Int32).new(-1)

      row_size = cols + 1
      all_data = Slice(Int32).new((rows + 1) * row_size, inf)
      row_size.times { |i| all_data[i] = i }
      curr_row = all_data[0, row_size]

      rows.times do |row|
        seq1_item = seq1[row]
        match_col = 0

        last_row = curr_row
        curr_row = all_data[(row + 1) * row_size, row_size]
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
          if sub_cost > 0
            prev_row_idx = row_map[seq2_item]

            if prev_row_idx >= 0
              prev_row = all_data[prev_row_idx * row_size, row_size]
              transpose = 1 + prev_row[match_col] \
                + (row - prev_row_idx - 1) \
                + (col - match_col - 1)
              cost = Math.min(cost, transpose)
            end
          end

          match_col = col if sub_cost == 0
          curr_row[col + 1] = cost
        end

        row_map[seq1_item] = row
      end

      curr_row[cols]
    end

    # Calculate the Damerau-Levenshtein distance of two sequences, bounded
    # by a maximum value.
    #
    # ```
    # DamerauLevenshtein.distance("acer", "earn")    # => 3
    # DamerauLevenshtein.distance("acer", "earn", 2) # => 2
    # ```
    def self.distance(str1, str2, max : Int) : Int32
      rows = str1.size
      cols = str2.size

      return cols > max ? max : cols if rows.zero?
      return rows > max ? max : rows if cols.zero?

      # Minimise size of matrix row we store
      if rows > cols
        str1, str2 = str2, str1
        rows, cols = cols, rows
      end

      return max if rows - cols >= max

      if str1.ascii_only? && str2.ascii_only?
        distance(str1.to_slice, rows, str2.to_slice, cols, max)
      else
        distance(str1.codepoints, rows, str2.codepoints, cols, max)
      end
    end

    private def self.distance(seq1 : Bytes, rows : Int, seq2 : Bytes, cols : Int, max : Int) : Int32
      inf = cols + 1

      # Same stack-allocated row_map as the unbounded ASCII path.
      # Encodes both row_history and matrix; slice reconstructed via all_data.
      row_map = StaticArray(Int32, 256).new(-1)

      row_size = cols + 1
      all_data = Slice(Int32).new((rows + 1) * row_size, inf)
      row_size.times { |i| all_data[i] = i }
      curr_row = all_data[0, row_size]

      prev_row_min = inf

      rows.times do |row|
        seq1_item = seq1[row]
        match_col = 0

        last_row = curr_row
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

        curr_row = all_data[(row + 1) * row_size, row_size]
        curr_row[0] = row + 1
        curr_row_min = inf

        min_col.upto(max_col) do |col|
          # Early termination if we've exceeded max distance on diagonal
          return max if diagonal == col && last_row[col] >= max

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
          if sub_cost > 0
            prev_row_idx = row_map[seq2_item]

            if prev_row_idx >= 0
              prev_row = all_data[prev_row_idx * row_size, row_size]
              transpose = 1 + prev_row[match_col] \
                + (row - prev_row_idx - 1) \
                + (col - match_col - 1)
              cost = Math.min(cost, transpose)
            end
          end

          match_col = col if sub_cost == 0
          curr_row[col + 1] = cost
          curr_row_min = Math.min(curr_row_min, cost)
        end

        prev_row_min = curr_row_min
        row_map[seq1_item] = row
      end

      curr_row[cols] > max ? max : curr_row[cols]
    end

    private def self.distance(seq1 : Array(Int32), rows : Int, seq2 : Array(Int32), cols : Int, max : Int) : Int32
      inf = cols + 1

      # char => last row index seen; -1 means never seen.
      row_map = Hash(Int32, Int32).new(-1)

      row_size = cols + 1
      all_data = Slice(Int32).new((rows + 1) * row_size, inf)
      row_size.times { |i| all_data[i] = i }
      curr_row = all_data[0, row_size]

      prev_row_min = inf

      rows.times do |row|
        seq1_item = seq1[row]
        match_col = 0

        last_row = curr_row

        diagonal = cols - rows + row

        # Early termination: remaining ops + best achievable cost exceeds max
        remaining_chars = rows - row - 1
        min_remaining_ops = (remaining_chars - cols + diagonal).abs
        return max if row > 0 && min_remaining_ops + prev_row_min > max

        # Ukkonen base bounds
        base_min_col = row > max ? row - max : 0
        base_max_col = Math.min(row + max, cols - 1)

        # Tighten bounds using the min cost tracked from the previous row.
        if row > 0 && prev_row_min < inf
          slack = max - prev_row_min
          min_col = Math.max(base_min_col, diagonal - slack)
          max_col = Math.min(base_max_col, diagonal + slack)
        else
          min_col = base_min_col
          max_col = base_max_col
        end

        curr_row = all_data[(row + 1) * row_size, row_size]
        curr_row[0] = row + 1
        curr_row_min = inf

        min_col.upto(max_col) do |col|
          # Early termination if we've exceeded max distance on diagonal
          return max if diagonal == col && last_row[col] >= max

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
          if sub_cost > 0
            prev_row_idx = row_map[seq2_item]

            if prev_row_idx >= 0
              prev_row = all_data[prev_row_idx * row_size, row_size]
              transpose = 1 + prev_row[match_col] \
                + (row - prev_row_idx - 1) \
                + (col - match_col - 1)
              cost = Math.min(cost, transpose)
            end
          end

          match_col = col if sub_cost == 0
          curr_row[col + 1] = cost
          curr_row_min = Math.min(curr_row_min, cost)
        end

        prev_row_min = curr_row_min
        row_map[seq1_item] = row
      end

      curr_row[cols] > max ? max : curr_row[cols]
    end
  end
end
