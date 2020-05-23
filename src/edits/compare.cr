module Edits
  module Compare
    # Given a prototype string and an array of strings, determines which
    # string is most similar to the prototype.
    #
    # `Klass.most_similar("foo", strings)` is functionally equivalent to
    # `strings.min_by { |s| Klass.distance("foo", s) }`, leveraging a
    # max distance.
    def most_similar(prototype, strings : Enumerable)
      case strings.size
      when 0 then raise Enumerable::EmptyError.new
      when 1 then return strings.first
      else nil
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
