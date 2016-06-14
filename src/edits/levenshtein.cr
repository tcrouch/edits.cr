module Edits
  # Implementation of Levenshtein distance algorithm.
  #
  # Determines distance between two string by counting edits, identifying:
  # * Insertion
  # * Deletion
  # * Substitution
  module Levenshtein
    # Calculate the Levenshtein (edit) distance of two sequences.
    #
    # Note: a true distance metric, satisfies triangle inequality.
    #
    # `Levenshtein.distance('sand', 'hands')    # => 2`
    def self.distance(str1, str2)
      # array of Fixnum codepoints outperforms String
      seq1 = str1.codepoints
      seq2 = str2.codepoints

      rows = seq1.size
      cols = seq2.size
      return cols if rows == 0
      return rows if cols == 0

      if cols > rows
        seq2, seq1 = seq1, seq2
        cols, rows = rows, cols
      end

      # Initialize first row of cost matrix.
      # Full initial state where cols=2, rows=3 would be:
      #   [[0, 1, 2],
      #    [1, 0, 0],
      #    [2, 0, 0]
      #    [3, 0, 0]]
      last_row = Pointer(Int32).malloc(cols + 1) { |i| i }

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

    # Calculate the Levenshtein (edit) distance of two sequences, bounded by
    # a maximum value. For low max values, this can have better performance.
    #
    # ```
    # Levenshtein.distance 'cloud', 'crayon'                # => 5
    # Levenshtein.distance_with_max 'cloud', 'crayon', 2    # => 2
    # ```
    def self.distance(str1, str2, max : Int32)
      seq1 = str1.codepoints
      seq2 = str2.codepoints

      rows = seq1.size
      cols = seq2.size
      return cols if rows == 0
      return rows if cols == 0
      return max if (rows - cols).abs >= max

      if cols > rows
        seq2, seq1 = seq1, seq2
        cols, rows = rows, cols
      end

      last_row = Pointer(Int32).malloc(cols + 1) { |i| i }

      rows.times do |row|
        last_col_cost = row + 1
        seq1_item = seq1[row]

        min_col = row > max ? row - max : 0
        max_col = row + max
        max_col = cols - 1 if max_col > cols - 1
        diagonal = cols - rows + row

        cols.times do |col|
          return max if diagonal == col && last_row[col] >= max
          col_cost =
            if col > max_col || col < min_col
              max + 1
            else
              # step cost is min of possible operation costs
              deletion = last_row[col + 1] + 1
              insertion = last_col_cost + 1
              substitution = last_row[col] + (seq1_item == seq2[col] ? 0 : 1)

              cost = Math.min(deletion, insertion)
              Math.min(cost, substitution)
            end

          last_row[col] = last_col_cost
          last_col_cost = col_cost
        end

        last_row[cols] = last_col_cost
      end

      last_row[cols] > max ? max : last_row[cols]
    end

    # Given a prototype string and an array of strings, determines which
    # string is most similar to the prototype.
    #
    # `Levenshtein.most_similar('foo', strings)` is functionally equivalent to
    # `strings.min_by { |s| Levenshtein.distance('foo', s) }`, leveraging a
    # max distance.
    def self.most_similar(prototype, strings : Enumerable)
      case strings.size
      when 0 then raise Enumerable::EmptyError.new
      when 1 then return strings.first
      end

      min_s = strings[0]
      min_d = distance(prototype, min_s)

      strings[1..-1].each do |s|
        d = distance(prototype, s, min_d)
        if d < min_d
          min_d = d
          min_s = s
        end
      end

      min_s
    end
  end
end
