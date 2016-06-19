# edits

A collection of edit distance algorithms in Crystal.

Includes Levenshtein, Restricted Edit (Optimal Alignment) and
Damerau-Levenshtein distances, and Jaro and Jaro-Winkler similarity.

[![docrystal.org](http://docrystal.org/badge.svg)](http://docrystal.org/github.com/tcrouch/edits.cr)


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

Edit distance, taking into account deletion, addition, substitution and swapped
characters.

```crystal
Edits::RestrictedEdit.distance "raked", "bakers"
# => 3
Edits::RestrictedEdit.distance "iota", "atom"
# => 3
Edits::RestrictedEdit.distance "acer", "earn"
# => 4
```

### Damerau-Levenshtein

Edit distance, taking into account deletions, additions, substitution and
transposition.

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
