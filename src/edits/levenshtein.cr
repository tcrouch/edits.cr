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
    def self.distance(str1, str2)
      rows = str1.size
      cols = str2.size
      str1, str2, rows, cols = str2, str1, cols, rows if rows < cols

      return cols if rows.zero?
      return rows if cols.zero?

      seq1 = str1.codepoints
      seq2 = str2.codepoints

      # Initialize first row of cost matrix.
      # Full initial state where cols=2, rows=3 would be:
      #   [[0, 1, 2],
      #    [1, 0, 0],
      #    [2, 0, 0]
      #    [3, 0, 0]]
      last_row = Slice(Int32).new(cols + 1) { |i| i }

      rows.times do |row|
        last_col = row + 1

        seq1_item = seq1[row]

        cols.times do |col|
          deletion = last_row[col + 1] + 1
          insertion = last_col + 1
          substitution = last_row[col] + (seq1_item == seq2[col] ? 0 : 1)

          # step cost is min of possible operation costs
          cost = Math.min(deletion, insertion)
          cost = Math.min(cost, substitution)

          # overwrite previous row as we progress; old value no longer required
          last_row[col] = last_col
          last_col = cost
        end
        last_row[cols] = last_col
      end

      last_row[cols]
    end

    # Calculate the Levenshtein (edit) distance of two sequences, bounded
    # by a maximum value. For low max values, this can be highly performant.
    #
    # ```
    # Levenshtein.distance("cloud", "crayon")    # => 5
    # Levenshtein.distance("cloud", "crayon", 2) # => 2
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

      # retain previous row of cost matrix
      last_row = Slice(Int32).new(cols + 1) { |i| i }

      rows.times do |row|
        # Ukkonen cut-off
        min_col = row > max ? row - max : 0
        max_col = row + max
        max_col = cols - 1 if max_col > cols - 1

        prev_col_cost = min_col.zero? ? row + 1 : inf
        seq1_item = seq1[row]
        diagonal = cols - rows + row

        min_col.upto(max_col) do |col|
          return max if diagonal == col && last_row[col] >= max

          # | Xs | Xd |
          # | Xi | ?  |
          # substitution, deletion, insertion
          substitution = last_row[col] + (seq1_item == seq2[col] ? 0 : 1)
          deletion = last_row[col + 1] + 1
          insertion = prev_col_cost + 1

          cost = Math.min(deletion, insertion)
          cost = Math.min(cost, substitution)

          # overwrite previous row as we progress
          last_row[col] = prev_col_cost
          prev_col_cost = cost
        end

        last_row[cols] = prev_col_cost
      end

      last_row[cols] > max ? max : last_row[cols]
    end
  end
end
