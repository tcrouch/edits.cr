# edits

[![Travis (.com)](https://img.shields.io/travis/com/tcrouch/edits.cr)](https://www.travis-ci.com/github/tcrouch/edits.cr)
[![Codacy grade](https://img.shields.io/codacy/grade/55107996a0e444a3b273d265780ccc38)](https://www.codacy.com/manual/t.crouch/edits.cr)
[![Documentation](https://img.shields.io/badge/api-docs-informational)](https://tcrouch.github.io/edits.cr)

A collection of edit distance algorithms in Crystal.

Includes Levenshtein, Restricted Edit (Optimal Alignment) and
Damerau-Levenshtein distances, and Jaro and Jaro-Winkler similarity.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  edits:
    github: tcrouch/edits.cr
```

## Usage

```crystal
require "edits"
```

### Levenshtein variants

Calculate the edit distance between two sequences with variants of the
Levenshtein distance algorithm.

```crystal
Edits::Levenshtein.distance "raked", "bakers"
# => 3
Edits::RestrictedEdit.distance "iota", "atom"
# => 3
Edits::DamerauLevenshtein.distance "acer", "earn"
# => 3
```

- **Levenshtein** edit distance, counting insertion, deletion and
  substitution.
- **Restricted Damerau-Levenshtein** edit distance (aka **Optimal Alignment**),
  counting insertion, deletion, substitution and transposition
  (adjacent symbols swapped). Restricted by the condition that no substring is
  edited more than once.
- **Damerau-Levenshtein** edit distance, counting insertion, deletion,
  substitution and transposition (adjacent symbols swapped).

|                      | Levenshtein | Restricted Damerau-Levenshtein | Damerau-Levenshtein |
|----------------------|-------------|--------------------------------|---------------------|
| "raked" vs. "bakers" | 3           | 3                              | 3                   |
| "iota" vs. "atom"    | 4           | 3                              | 3                   |
| "acer" vs. "earn"    | 4           | 4                              | 3                   |

Levenshtein and Restricted Edit distances accept an optional maximum bound.

```crystal
Edits::Levenshtein.distance "fghijk", "abcde", 3
# => 3
```

The convenience method `most_similar` searches for the best match to a
given sequence from a collection. It is similar to using `min_by`, but leverages
a maximum bound.

```crystal
Edits::RestrictedEdit.most_similar "atom", ["iota", "tome", "mown", "tame"]
# => "tome"
```

### Jaro & Jaro-Winkler

Calculate the Jaro and Jaro-Winkler similarity/distance of two sequences.

```crystal
Edits::Jaro.similarity "information", "informant"
# => 0.90235690235690236
Edits::Jaro.distance "information", "informant"
# => 0.097643097643097643

Edits::JaroWinkler.similarity "information", "informant"
# => 0.94141414141414137
Edits::JaroWinkler.distance "information", "informant"
# => 0.05858585858585863
```

## Contributing

1.  [Fork it](https://github.com/tcrouch/edits.cr/fork)
2.  Create your feature branch (`git checkout -b my-new-feature`)
3.  Commit your changes (`git commit -am 'Add some feature'`)
4.  Push to the branch (`git push origin my-new-feature`)
5.  Create a new Pull Request

## Contributors

-   [[tcrouch]](https://github.com/tcrouch) Tom Crouch - creator, maintainer
