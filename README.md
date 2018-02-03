# edits

[![Build Status](https://travis-ci.org/tcrouch/edits.cr.svg)](https://travis-ci.org/tcrouch/edits.cr)
[![docrystal.org](http://docrystal.org/badge.svg)](http://docrystal.org/github.com/tcrouch/edits.cr)

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

### Levenshtein

Edit distance, taking into account deletion, addition and substitution.

```crystal
Edits::Levenshtein.distance "raked", "bakers"
# => 3
Edits::Levenshtein.distance "iota", "atom"
# => 4
Edits::Levenshtein.distance "acer", "earn"
# => 4

# Max distance
Edits::Levenshtein.distance "iota", "atom", 2
# => 2
Edits::Levenshtein.most_similar "atom", ["atlas", "tram", "rota", "racer"]
# => "atlas"
```

### Restricted Edit (Optimal Alignment)

Edit distance, accounting for deletion, addition, substitution and
transposition (two adjacent characters are swapped). This variant is
restricted by the condition that no sub-string is edited more than once.

```crystal
Edits::RestrictedEdit.distance "raked", "bakers"
# => 3
Edits::RestrictedEdit.distance "iota", "atom"
# => 3
Edits::RestrictedEdit.distance "acer", "earn"
# => 4

# Max distance
Edits::RestrictedEdit.distance "iota", "atom", 2
# => 2
Edits::RestrictedEdit.most_similar "atom", ["iota", "tome", "mown", "tame"]
# => "tome"
```

### Damerau-Levenshtein

Edit distance, accounting for deletions, additions, substitution and
transposition (two adjacent characters are swapped).

```crystal
Edits::DamerauLevenshtein.distance "raked", "bakers"
# => 3
Edits::DamerauLevenshtein.distance "iota", "atom"
# => 3
Edits::DamerauLevenshtein.distance "acer", "earn"
# => 3
```

### Jaro & Jaro-Winkler

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

1. Fork it ( https://github.com/tcrouch/edits.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [[tcrouch]](https://github.com/tcrouch) Tom Crouch - creator, maintainer
