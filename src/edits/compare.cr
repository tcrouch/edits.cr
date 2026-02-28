module Edits
  module Compare
    # Given a prototype string and an array of strings, determines which
    # string is most similar to the prototype.
    #
    # `Klass.most_similar("foo", strings)` is functionally equivalent to
    # `strings.min_by { |s| Klass.distance("foo", s) }`, leveraging a
    # max distance.
    def most_similar(prototype, strings : Indexable)
      raise Enumerable::EmptyError.new if strings.empty?
      return strings.first if strings.size == 1

      min_s = strings[0]
      min_d = distance(prototype, min_s)

      (1...strings.size).each do |i|
        d = distance(prototype, strings[i], min_d)
        if d < min_d
          min_d = d
          min_s = strings[i]
        end
      end

      min_s
    end
  end
end
