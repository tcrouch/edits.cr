crystal_doc_search_index_callback({"repository_name":"edits","body":"# edits\n\n![GitHub Workflow Status (branch)](https://img.shields.io/github/workflow/status/tcrouch/edits.cr/CI/master)\n[![Documentation](https://img.shields.io/badge/api-docs-informational)](https://tcrouch.github.io/edits.cr)\n\nA collection of edit distance algorithms in Crystal.\n\nIncludes Levenshtein, Restricted Edit (Optimal Alignment) and\nDamerau-Levenshtein distances, and Jaro and Jaro-Winkler similarity.\n\n## Installation\n\nAdd this to your application's `shard.yml`:\n\n```yaml\ndependencies:\n  edits:\n    github: tcrouch/edits.cr\n```\n\n## Usage\n\n```crystal\nrequire \"edits\"\n```\n\n### Levenshtein variants\n\nCalculate the edit distance between two sequences with variants of the\nLevenshtein distance algorithm.\n\n```crystal\nEdits::Levenshtein.distance \"raked\", \"bakers\"\n# => 3\nEdits::RestrictedEdit.distance \"iota\", \"atom\"\n# => 3\nEdits::DamerauLevenshtein.distance \"acer\", \"earn\"\n# => 3\n```\n\n- **Levenshtein** edit distance, counting insertion, deletion and\n  substitution.\n- **Restricted Damerau-Levenshtein** edit distance (aka **Optimal Alignment**),\n  counting insertion, deletion, substitution and transposition\n  (adjacent symbols swapped). Restricted by the condition that no substring is\n  edited more than once.\n- **Damerau-Levenshtein** edit distance, counting insertion, deletion,\n  substitution and transposition (adjacent symbols swapped).\n\n|                      | Levenshtein | Restricted Damerau-Levenshtein | Damerau-Levenshtein |\n|----------------------|-------------|--------------------------------|---------------------|\n| \"raked\" vs. \"bakers\" | 3           | 3                              | 3                   |\n| \"iota\" vs. \"atom\"    | 4           | 3                              | 3                   |\n| \"acer\" vs. \"earn\"    | 4           | 4                              | 3                   |\n\nLevenshtein and Restricted Edit distances accept an optional maximum bound.\n\n```crystal\nEdits::Levenshtein.distance \"fghijk\", \"abcde\", 3\n# => 3\n```\n\nThe convenience method `most_similar` searches for the best match to a\ngiven sequence from a collection. It is similar to using `min_by`, but leverages\na maximum bound.\n\n```crystal\nEdits::RestrictedEdit.most_similar \"atom\", [\"iota\", \"tome\", \"mown\", \"tame\"]\n# => \"tome\"\n```\n\n### Jaro & Jaro-Winkler\n\nCalculate the Jaro and Jaro-Winkler similarity/distance of two sequences.\n\n```crystal\nEdits::Jaro.similarity \"information\", \"informant\"\n# => 0.90235690235690236\nEdits::Jaro.distance \"information\", \"informant\"\n# => 0.097643097643097643\n\nEdits::JaroWinkler.similarity \"information\", \"informant\"\n# => 0.94141414141414137\nEdits::JaroWinkler.distance \"information\", \"informant\"\n# => 0.05858585858585863\n```\n\n## Contributing\n\n1.  [Fork it](https://github.com/tcrouch/edits.cr/fork)\n2.  Create your feature branch (`git checkout -b my-new-feature`)\n3.  Commit your changes (`git commit -am 'Add some feature'`)\n4.  Push to the branch (`git push origin my-new-feature`)\n5.  Create a new Pull Request\n\n## Contributors\n\n-   [[tcrouch]](https://github.com/tcrouch) Tom Crouch - creator, maintainer\n","program":{"html_id":"edits/toplevel","path":"toplevel.html","kind":"module","full_name":"Top Level Namespace","name":"Top Level Namespace","abstract":false,"superclass":null,"ancestors":[],"locations":[],"repository_name":"edits","program":true,"enum":false,"alias":false,"aliased":null,"aliased_html":null,"const":false,"constants":[],"included_modules":[],"extended_modules":[],"subclasses":[],"including_types":[],"namespace":null,"doc":null,"summary":null,"class_methods":[],"constructors":[],"instance_methods":[],"macros":[],"types":[{"html_id":"edits/Edits","path":"Edits.html","kind":"module","full_name":"Edits","name":"Edits","abstract":false,"superclass":null,"ancestors":[],"locations":[{"filename":"src/edits.cr","line_number":4,"url":"https://github.com/tcrouch/edits.cr/blob/972692efbcd042473fa9cd72acf1ec119a97ce49/src/edits.cr#L4"},{"filename":"src/edits/compare.cr","line_number":1,"url":"https://github.com/tcrouch/edits.cr/blob/972692efbcd042473fa9cd72acf1ec119a97ce49/src/edits/compare.cr#L1"},{"filename":"src/edits/damerau_levenshtein.cr","line_number":1,"url":"https://github.com/tcrouch/edits.cr/blob/972692efbcd042473fa9cd72acf1ec119a97ce49/src/edits/damerau_levenshtein.cr#L1"},{"filename":"src/edits/hamming.cr","line_number":1,"url":"https://github.com/tcrouch/edits.cr/blob/972692efbcd042473fa9cd72acf1ec119a97ce49/src/edits/hamming.cr#L1"},{"filename":"src/edits/jaro.cr","line_number":3,"url":"https://github.com/tcrouch/edits.cr/blob/972692efbcd042473fa9cd72acf1ec119a97ce49/src/edits/jaro.cr#L3"},{"filename":"src/edits/jaro_winkler.cr","line_number":1,"url":"https://github.com/tcrouch/edits.cr/blob/972692efbcd042473fa9cd72acf1ec119a97ce49/src/edits/jaro_winkler.cr#L1"},{"filename":"src/edits/levenshtein.cr","line_number":1,"url":"https://github.com/tcrouch/edits.cr/blob/972692efbcd042473fa9cd72acf1ec119a97ce49/src/edits/levenshtein.cr#L1"},{"filename":"src/edits/restricted_edit.cr","line_number":1,"url":"https://github.com/tcrouch/edits.cr/blob/972692efbcd042473fa9cd72acf1ec119a97ce49/src/edits/restricted_edit.cr#L1"},{"filename":"src/edits/version.cr","line_number":1,"url":"https://github.com/tcrouch/edits.cr/blob/972692efbcd042473fa9cd72acf1ec119a97ce49/src/edits/version.cr#L1"}],"repository_name":"edits","program":false,"enum":false,"alias":false,"aliased":null,"aliased_html":null,"const":false,"constants":[{"id":"VERSION","name":"VERSION","value":"{{ (`shards version /__w/edits.cr/edits.cr/src/edits`).chomp.stringify }}","doc":null,"summary":null}],"included_modules":[],"extended_modules":[],"subclasses":[],"including_types":[],"namespace":null,"doc":"Collection of edit distance algorithms.","summary":"<p>Collection of edit distance algorithms.</p>","class_methods":[],"constructors":[],"instance_methods":[],"macros":[],"types":[{"html_id":"edits/Edits/Compare","path":"Edits/Compare.html","kind":"module","full_name":"Edits::Compare","name":"Compare","abstract":false,"superclass":null,"ancestors":[],"locations":[{"filename":"src/edits/compare.cr","line_number":2,"url":"https://github.com/tcrouch/edits.cr/blob/972692efbcd042473fa9cd72acf1ec119a97ce49/src/edits/compare.cr#L2"}],"repository_name":"edits","program":false,"enum":false,"alias":false,"aliased":null,"aliased_html":null,"const":false,"constants":[],"included_modules":[],"extended_modules":[],"subclasses":[],"including_types":[],"namespace":{"html_id":"edits/Edits","kind":"module","full_name":"Edits","name":"Edits"},"doc":null,"summary":null,"class_methods":[],"constructors":[],"instance_methods":[{"html_id":"most_similar(prototype,strings:Enumerable)-instance-method","name":"most_similar","doc":"Given a prototype string and an array of strings, determines which\nstring is most similar to the prototype.\n\n`Klass.most_similar(\"foo\", strings)` is functionally equivalent to\n`strings.min_by { |s| Klass.distance(\"foo\", s) }`, leveraging a\nmax distance.","summary":"<p>Given a prototype string and an array of strings, determines which string is most similar to the prototype.</p>","abstract":false,"args":[{"name":"prototype","doc":null,"default_value":"","external_name":"prototype","restriction":""},{"name":"strings","doc":null,"default_value":"","external_name":"strings","restriction":"Enumerable"}],"args_string":"(prototype, strings : Enumerable)","args_html":"(prototype, strings : Enumerable)","location":{"filename":"src/edits/compare.cr","line_number":9,"url":"https://github.com/tcrouch/edits.cr/blob/972692efbcd042473fa9cd72acf1ec119a97ce49/src/edits/compare.cr#L9"},"def":{"name":"most_similar","args":[{"name":"prototype","doc":null,"default_value":"","external_name":"prototype","restriction":""},{"name":"strings","doc":null,"default_value":"","external_name":"strings","restriction":"Enumerable"}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"case strings.size\nwhen 0\n  raise(Enumerable::EmptyError.new)\nwhen 1\n  return strings.first\nelse\n  nil\nend\nmin_s = strings[0]\nmin_d = distance(prototype, min_s)\nstrings[1..-1].each do |s|\n  d = distance(prototype, s, min_d)\n  if d < min_d\n    min_d = d\n    min_s = s\n  end\nend\nmin_s\n"}}],"macros":[],"types":[]},{"html_id":"edits/Edits/DamerauLevenshtein","path":"Edits/DamerauLevenshtein.html","kind":"module","full_name":"Edits::DamerauLevenshtein","name":"DamerauLevenshtein","abstract":false,"superclass":null,"ancestors":[],"locations":[{"filename":"src/edits/damerau_levenshtein.cr","line_number":9,"url":"https://github.com/tcrouch/edits.cr/blob/972692efbcd042473fa9cd72acf1ec119a97ce49/src/edits/damerau_levenshtein.cr#L9"}],"repository_name":"edits","program":false,"enum":false,"alias":false,"aliased":null,"aliased_html":null,"const":false,"constants":[],"included_modules":[],"extended_modules":[],"subclasses":[],"including_types":[],"namespace":{"html_id":"edits/Edits","kind":"module","full_name":"Edits","name":"Edits"},"doc":"Damerau-Levenshtein edit distance.\n\nDetermines distance between two strings by counting edits, identifying:\n* Insertion\n* Deletion\n* Substitution\n* Adjacent transposition","summary":"<p>Damerau-Levenshtein edit distance.</p>","class_methods":[{"html_id":"distance(str1,str2):Int-class-method","name":"distance","doc":"Calculate the Damerau-Levenshtein distance of two sequences.\n\n```\nDamerauLevenshtein.distance(\"acer\", \"earn\") # => 3\n```","summary":"<p>Calculate the Damerau-Levenshtein distance of two sequences.</p>","abstract":false,"args":[{"name":"str1","doc":null,"default_value":"","external_name":"str1","restriction":""},{"name":"str2","doc":null,"default_value":"","external_name":"str2","restriction":""}],"args_string":"(str1, str2) : Int","args_html":"(str1, str2) : Int","location":{"filename":"src/edits/damerau_levenshtein.cr","line_number":15,"url":"https://github.com/tcrouch/edits.cr/blob/972692efbcd042473fa9cd72acf1ec119a97ce49/src/edits/damerau_levenshtein.cr#L15"},"def":{"name":"distance","args":[{"name":"str1","doc":null,"default_value":"","external_name":"str1","restriction":""},{"name":"str2","doc":null,"default_value":"","external_name":"str2","restriction":""}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"Int","visibility":"Public","body":"rows = str1.size\ncols = str2.size\nif rows > cols\n  str1, str2, rows, cols = str2, str1, cols, rows\nend\nif rows.zero?\n  return cols\nend\nif cols.zero?\n  return rows\nend\nseq1 = str1.codepoints\nseq2 = str2.codepoints\ninf = cols + 1\nrow_history = Hash(Int32, Int32).new(0)\ncurr_row = Slice.new(cols + 1) do |i|\n  i\nend\nmatrix = Hash(Int32, typeof(curr_row)).new\nrows.times do |row|\n  seq1_item = seq1[row]\n  match_col = 0\n  matrix[seq1_item] = last_row = curr_row\n  curr_row = Slice.new(cols + 1, inf)\n  curr_row[0] = row + 1\n  cols.times do |col|\n    seq2_item = seq2[col]\n    sub_cost = seq1_item == seq2_item ? 0 : 1\n    cost = Math.min(last_row[col] + sub_cost, last_row[col + 1] + 1)\n    cost = Math.min(cost, curr_row[col] + 1)\n    if (sub_cost > 0 && row > 0) && (m = matrix[seq2_item]?)\n      transpose = ((1 + m[match_col]) + ((row - row_history[seq2_item]) - 1)) + ((col - match_col) - 1)\n      cost = Math.min(cost, transpose)\n    end\n    if sub_cost == 0\n      match_col = col\n    end\n    curr_row[col + 1] = cost\n  end\n  row_history[seq1_item] = row\nend\ncurr_row[cols]\n"}}],"constructors":[],"instance_methods":[],"macros":[],"types":[]},{"html_id":"edits/Edits/Hamming","path":"Edits/Hamming.html","kind":"module","full_name":"Edits::Hamming","name":"Hamming","abstract":false,"superclass":null,"ancestors":[],"locations":[{"filename":"src/edits/hamming.cr","line_number":2,"url":"https://github.com/tcrouch/edits.cr/blob/972692efbcd042473fa9cd72acf1ec119a97ce49/src/edits/hamming.cr#L2"}],"repository_name":"edits","program":false,"enum":false,"alias":false,"aliased":null,"aliased_html":null,"const":false,"constants":[],"included_modules":[],"extended_modules":[],"subclasses":[],"including_types":[],"namespace":{"html_id":"edits/Edits","kind":"module","full_name":"Edits","name":"Edits"},"doc":null,"summary":null,"class_methods":[{"html_id":"distance(seq1:Int,seq2:Int)-class-method","name":"distance","doc":"Calculate Hamming distance between the bits comprising two integers","summary":"<p>Calculate Hamming distance between the bits comprising two integers</p>","abstract":false,"args":[{"name":"seq1","doc":null,"default_value":"","external_name":"seq1","restriction":"Int"},{"name":"seq2","doc":null,"default_value":"","external_name":"seq2","restriction":"Int"}],"args_string":"(seq1 : Int, seq2 : Int)","args_html":"(seq1 : Int, seq2 : Int)","location":{"filename":"src/edits/hamming.cr","line_number":15,"url":"https://github.com/tcrouch/edits.cr/blob/972692efbcd042473fa9cd72acf1ec119a97ce49/src/edits/hamming.cr#L15"},"def":{"name":"distance","args":[{"name":"seq1","doc":null,"default_value":"","external_name":"seq1","restriction":"Int"},{"name":"seq2","doc":null,"default_value":"","external_name":"seq2","restriction":"Int"}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"(seq1 ^ seq2).popcount"}},{"html_id":"distance(seq1,seq2)-class-method","name":"distance","doc":"Calculate the Hamming distance between two sequences.\n\nNOTE: a true distance metric, satisfies triangle inequality.","summary":"<p>Calculate the Hamming distance between two sequences.</p>","abstract":false,"args":[{"name":"seq1","doc":null,"default_value":"","external_name":"seq1","restriction":""},{"name":"seq2","doc":null,"default_value":"","external_name":"seq2","restriction":""}],"args_string":"(seq1, seq2)","args_html":"(seq1, seq2)","location":{"filename":"src/edits/hamming.cr","line_number":6,"url":"https://github.com/tcrouch/edits.cr/blob/972692efbcd042473fa9cd72acf1ec119a97ce49/src/edits/hamming.cr#L6"},"def":{"name":"distance","args":[{"name":"seq1","doc":null,"default_value":"","external_name":"seq1","restriction":""},{"name":"seq2","doc":null,"default_value":"","external_name":"seq2","restriction":""}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"if (length = seq1.size) != seq2.size\n  return nil\nend\nlength.times.reduce(0) do |distance, i|\n  seq1[i] == seq2[i] ? distance : distance + 1\nend\n"}}],"constructors":[],"instance_methods":[],"macros":[],"types":[]},{"html_id":"edits/Edits/Jaro","path":"Edits/Jaro.html","kind":"module","full_name":"Edits::Jaro","name":"Jaro","abstract":false,"superclass":null,"ancestors":[],"locations":[{"filename":"src/edits/jaro.cr","line_number":7,"url":"https://github.com/tcrouch/edits.cr/blob/972692efbcd042473fa9cd72acf1ec119a97ce49/src/edits/jaro.cr#L7"}],"repository_name":"edits","program":false,"enum":false,"alias":false,"aliased":null,"aliased_html":null,"const":false,"constants":[],"included_modules":[],"extended_modules":[],"subclasses":[],"including_types":[],"namespace":{"html_id":"edits/Edits","kind":"module","full_name":"Edits","name":"Edits"},"doc":"Jaro similarity measure.\n\n[See wiki](https://en.wikipedia.org/wiki/Jaro-Winkler_distance)","summary":"<p>Jaro similarity measure.</p>","class_methods":[{"html_id":"distance(str1,str2):Float-class-method","name":"distance","doc":"Calculate Jaro distance, where 0 is an exact match\nand 1 is no similarity.\n\n`Dj = 1 - similarity`\n\n```\nJaro.distance \"information\", \"informant\"\n# => 0.097643097643097643\n```","summary":"<p>Calculate Jaro distance, where 0 is an exact match and 1 is no similarity.</p>","abstract":false,"args":[{"name":"str1","doc":null,"default_value":"","external_name":"str1","restriction":""},{"name":"str2","doc":null,"default_value":"","external_name":"str2","restriction":""}],"args_string":"(str1, str2) : Float","args_html":"(str1, str2) : Float","location":{"filename":"src/edits/jaro.cr","line_number":41,"url":"https://github.com/tcrouch/edits.cr/blob/972692efbcd042473fa9cd72acf1ec119a97ce49/src/edits/jaro.cr#L41"},"def":{"name":"distance","args":[{"name":"str1","doc":null,"default_value":"","external_name":"str1","restriction":""},{"name":"str2","doc":null,"default_value":"","external_name":"str2","restriction":""}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"Float","visibility":"Public","body":"1.0 - (similarity(str1, str2))"}},{"html_id":"similarity(str1,str2):Float-class-method","name":"similarity","doc":"Calculate Jaro similarity of two sequences, where 1 is an exact match\nand 0 is no similarity.\n\n`Sj = 1/3 * ((m / |A|) + (m / |B|) + ((m - t) / m))`\nWhere `m` is #matches and `t` is #transposes\n\n```\nJaro.distance(\"information\", \"informant\")\n# => 0.9023569023569024\n```","summary":"<p>Calculate Jaro similarity of two sequences, where 1 is an exact match and 0 is no similarity.</p>","abstract":false,"args":[{"name":"str1","doc":null,"default_value":"","external_name":"str1","restriction":""},{"name":"str2","doc":null,"default_value":"","external_name":"str2","restriction":""}],"args_string":"(str1, str2) : Float","args_html":"(str1, str2) : Float","location":{"filename":"src/edits/jaro.cr","line_number":18,"url":"https://github.com/tcrouch/edits.cr/blob/972692efbcd042473fa9cd72acf1ec119a97ce49/src/edits/jaro.cr#L18"},"def":{"name":"similarity","args":[{"name":"str1","doc":null,"default_value":"","external_name":"str1","restriction":""},{"name":"str2","doc":null,"default_value":"","external_name":"str2","restriction":""}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"Float","visibility":"Public","body":"if str1 == str2\n  return 1.0\nend\nif str1.empty? || str2.empty?\n  return 0.0\nend\nif str1.single_byte_optimizable? && str2.single_byte_optimizable?\n  m, t = matches(str1.to_slice, str2.to_slice)\nelse\n  m, t = matches(str1.codepoints, str2.codepoints)\nend\nif m == 0\n  return 0.0\nend\n(((m / str1.size) + (m / str2.size)) + ((m - t) / m)) / 3\n"}}],"constructors":[],"instance_methods":[],"macros":[],"types":[]},{"html_id":"edits/Edits/JaroWinkler","path":"Edits/JaroWinkler.html","kind":"module","full_name":"Edits::JaroWinkler","name":"JaroWinkler","abstract":false,"superclass":null,"ancestors":[],"locations":[{"filename":"src/edits/jaro_winkler.cr","line_number":9,"url":"https://github.com/tcrouch/edits.cr/blob/972692efbcd042473fa9cd72acf1ec119a97ce49/src/edits/jaro_winkler.cr#L9"}],"repository_name":"edits","program":false,"enum":false,"alias":false,"aliased":null,"aliased_html":null,"const":false,"constants":[{"id":"WINKLER_PREFIX_WEIGHT","name":"WINKLER_PREFIX_WEIGHT","value":"0.1","doc":"Prefix scaling factor for jaro-winkler metric. Default is 0.1\nShould not exceed 0.25 or metric range will leave 0..1","summary":"<p>Prefix scaling factor for jaro-winkler metric.</p>"},{"id":"WINKLER_THRESHOLD","name":"WINKLER_THRESHOLD","value":"0.7","doc":"Threshold for boosting Jaro with Winkler prefix multiplier.\nDefault is 0.7","summary":"<p>Threshold for boosting Jaro with Winkler prefix multiplier.</p>"}],"included_modules":[],"extended_modules":[],"subclasses":[],"including_types":[],"namespace":{"html_id":"edits/Edits","kind":"module","full_name":"Edits","name":"Edits"},"doc":"Jaro-Winkler similarity measure.\n\nWhen Jaro similarity exceeds a threshold, the Winkler extension adds\nadditional weighting if a common prefix exists.\n\nSee also:\n* [Wikipedia](https://en.wikipedia.org/wiki/Jaro-Winkler_distance)","summary":"<p>Jaro-Winkler similarity measure.</p>","class_methods":[{"html_id":"distance(str1,str2,threshold=WINKLER_THRESHOLD,weight=WINKLER_PREFIX_WEIGHT):Float-class-method","name":"distance","doc":"Calculate Jaro-Winkler distance, where 0 is an exact match and 1\nis no similarity.\n\n`Dw = 1 - similarity`\n\n```\nJaroWinkler.distance \"information\", \"informant\"\n# => 0.05858585858585863\n```","summary":"<p>Calculate Jaro-Winkler distance, where 0 is an exact match and 1 is no similarity.</p>","abstract":false,"args":[{"name":"str1","doc":null,"default_value":"","external_name":"str1","restriction":""},{"name":"str2","doc":null,"default_value":"","external_name":"str2","restriction":""},{"name":"threshold","doc":null,"default_value":"WINKLER_THRESHOLD","external_name":"threshold","restriction":""},{"name":"weight","doc":null,"default_value":"WINKLER_PREFIX_WEIGHT","external_name":"weight","restriction":""}],"args_string":"(str1, str2, threshold = WINKLER_THRESHOLD, weight = WINKLER_PREFIX_WEIGHT) : Float","args_html":"(str1, str2, threshold = <span class=\"t\">WINKLER_THRESHOLD</span>, weight = <span class=\"t\">WINKLER_PREFIX_WEIGHT</span>) : Float","location":{"filename":"src/edits/jaro_winkler.cr","line_number":60,"url":"https://github.com/tcrouch/edits.cr/blob/972692efbcd042473fa9cd72acf1ec119a97ce49/src/edits/jaro_winkler.cr#L60"},"def":{"name":"distance","args":[{"name":"str1","doc":null,"default_value":"","external_name":"str1","restriction":""},{"name":"str2","doc":null,"default_value":"","external_name":"str2","restriction":""},{"name":"threshold","doc":null,"default_value":"WINKLER_THRESHOLD","external_name":"threshold","restriction":""},{"name":"weight","doc":null,"default_value":"WINKLER_PREFIX_WEIGHT","external_name":"weight","restriction":""}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"Float","visibility":"Public","body":"1.0 - (similarity(str1, str2, threshold, weight))"}},{"html_id":"similarity(str1,str2,threshold=WINKLER_THRESHOLD,weight=WINKLER_PREFIX_WEIGHT):Float-class-method","name":"similarity","doc":"Calculate Jaro-Winkler similarity, where 1 is an exact match and 0 is\nno similarity.\n\n`Sw = Sj + (l * p * (1 - Sj))`\n\nWhere `Sj` is Jaro, `l` is prefix length, and `p` is prefix weight\n\n```\nJaroWinkler.similarity(\"information\", \"informant\")\n# => 0.9414141414141414\n```\nNOTE: not a true distance metric, fails to satisfy triangle inequality.","summary":"<p>Calculate Jaro-Winkler similarity, where 1 is an exact match and 0 is no similarity.</p>","abstract":false,"args":[{"name":"str1","doc":null,"default_value":"","external_name":"str1","restriction":""},{"name":"str2","doc":null,"default_value":"","external_name":"str2","restriction":""},{"name":"threshold","doc":null,"default_value":"WINKLER_THRESHOLD","external_name":"threshold","restriction":""},{"name":"weight","doc":null,"default_value":"WINKLER_PREFIX_WEIGHT","external_name":"weight","restriction":""}],"args_string":"(str1, str2, threshold = WINKLER_THRESHOLD, weight = WINKLER_PREFIX_WEIGHT) : Float","args_html":"(str1, str2, threshold = <span class=\"t\">WINKLER_THRESHOLD</span>, weight = <span class=\"t\">WINKLER_PREFIX_WEIGHT</span>) : Float","location":{"filename":"src/edits/jaro_winkler.cr","line_number":30,"url":"https://github.com/tcrouch/edits.cr/blob/972692efbcd042473fa9cd72acf1ec119a97ce49/src/edits/jaro_winkler.cr#L30"},"def":{"name":"similarity","args":[{"name":"str1","doc":null,"default_value":"","external_name":"str1","restriction":""},{"name":"str2","doc":null,"default_value":"","external_name":"str2","restriction":""},{"name":"threshold","doc":null,"default_value":"WINKLER_THRESHOLD","external_name":"threshold","restriction":""},{"name":"weight","doc":null,"default_value":"WINKLER_PREFIX_WEIGHT","external_name":"weight","restriction":""}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"Float","visibility":"Public","body":"sj = Jaro.similarity(str1, str2)\nif sj > threshold\n  max_bound = Math.min(str2.size, str1.size)\n  if max_bound > 4\n    max_bound = 4\n  end\n  l = 0\n  while !(l >= max_bound || (str1[l] != str2[l]))\n    l = l + 1\n  end\n  (  l < 1) ? sj : sj + ((l * weight) * (1 - sj))\nelse\n  sj\nend\n"}}],"constructors":[],"instance_methods":[],"macros":[],"types":[]},{"html_id":"edits/Edits/Levenshtein","path":"Edits/Levenshtein.html","kind":"module","full_name":"Edits::Levenshtein","name":"Levenshtein","abstract":false,"superclass":null,"ancestors":[],"locations":[{"filename":"src/edits/levenshtein.cr","line_number":8,"url":"https://github.com/tcrouch/edits.cr/blob/972692efbcd042473fa9cd72acf1ec119a97ce49/src/edits/levenshtein.cr#L8"}],"repository_name":"edits","program":false,"enum":false,"alias":false,"aliased":null,"aliased_html":null,"const":false,"constants":[],"included_modules":[],"extended_modules":[{"html_id":"edits/Edits/Compare","kind":"module","full_name":"Edits::Compare","name":"Compare"}],"subclasses":[],"including_types":[],"namespace":{"html_id":"edits/Edits","kind":"module","full_name":"Edits","name":"Edits"},"doc":"Levenshtein edit distance.\n\nDetermines distance between two string by counting edits, identifying:\n* Insertion\n* Deletion\n* Substitution","summary":"<p>Levenshtein edit distance.</p>","class_methods":[{"html_id":"distance(str1,str2,max:Int):Int-class-method","name":"distance","doc":"Calculate the Levenshtein (edit) distance of two sequences, bounded\nby a maximum value.\n\n```\nLevenshtein.distance(\"cloud\", \"crayon\")    # => 5\nLevenshtein.distance(\"cloud\", \"crayon\", 2) # => 2\n```","summary":"<p>Calculate the Levenshtein (edit) distance of two sequences, bounded by a maximum value.</p>","abstract":false,"args":[{"name":"str1","doc":null,"default_value":"","external_name":"str1","restriction":""},{"name":"str2","doc":null,"default_value":"","external_name":"str2","restriction":""},{"name":"max","doc":null,"default_value":"","external_name":"max","restriction":"Int"}],"args_string":"(str1, str2, max : Int) : Int","args_html":"(str1, str2, max : Int) : Int","location":{"filename":"src/edits/levenshtein.cr","line_number":82,"url":"https://github.com/tcrouch/edits.cr/blob/972692efbcd042473fa9cd72acf1ec119a97ce49/src/edits/levenshtein.cr#L82"},"def":{"name":"distance","args":[{"name":"str1","doc":null,"default_value":"","external_name":"str1","restriction":""},{"name":"str2","doc":null,"default_value":"","external_name":"str2","restriction":""},{"name":"max","doc":null,"default_value":"","external_name":"max","restriction":"Int"}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"Int","visibility":"Public","body":"rows = str1.size\ncols = str2.size\nif rows.zero?\n  return cols > max ? max : cols\nend\nif cols.zero?\n  return rows > max ? max : rows\nend\nif rows < cols\n  str1, str2 = str2, str1\n  rows, cols = cols, rows\nend\nif (rows - cols) >= max\n  return max\nend\nif str1.single_byte_optimizable? && str2.single_byte_optimizable?\n  _distance(str1.to_slice, rows, str2.to_slice, cols, max)\nelse\n  _distance(Char::Reader.new(str1), rows, str2.chars, cols, max)\nend\n"}},{"html_id":"distance(str1,str2):Int-class-method","name":"distance","doc":"Calculate the Levenshtein (edit) distance of two sequences.\n\nNOTE: a true distance metric, satisfies triangle inequality.\n\n```\nLevenshtein.distance(\"sand\", \"hands\") # => 2\n```","summary":"<p>Calculate the Levenshtein (edit) distance of two sequences.</p>","abstract":false,"args":[{"name":"str1","doc":null,"default_value":"","external_name":"str1","restriction":""},{"name":"str2","doc":null,"default_value":"","external_name":"str2","restriction":""}],"args_string":"(str1, str2) : Int","args_html":"(str1, str2) : Int","location":{"filename":"src/edits/levenshtein.cr","line_number":18,"url":"https://github.com/tcrouch/edits.cr/blob/972692efbcd042473fa9cd72acf1ec119a97ce49/src/edits/levenshtein.cr#L18"},"def":{"name":"distance","args":[{"name":"str1","doc":null,"default_value":"","external_name":"str1","restriction":""},{"name":"str2","doc":null,"default_value":"","external_name":"str2","restriction":""}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"Int","visibility":"Public","body":"rows = str1.size\ncols = str2.size\nif rows.zero?\n  return cols\nend\nif cols.zero?\n  return rows\nend\nif rows < cols\n  str1, str2 = str2, str1\n  rows, cols = cols, rows\nend\nif str1.single_byte_optimizable? && str2.single_byte_optimizable?\n  _distance(str1.to_slice, rows, str2.to_slice, cols)\nelse\n  _distance(Char::Reader.new(str1), rows, str2.chars, cols)\nend\n"}}],"constructors":[],"instance_methods":[],"macros":[],"types":[]},{"html_id":"edits/Edits/RestrictedEdit","path":"Edits/RestrictedEdit.html","kind":"module","full_name":"Edits::RestrictedEdit","name":"RestrictedEdit","abstract":false,"superclass":null,"ancestors":[],"locations":[{"filename":"src/edits/restricted_edit.cr","line_number":12,"url":"https://github.com/tcrouch/edits.cr/blob/972692efbcd042473fa9cd72acf1ec119a97ce49/src/edits/restricted_edit.cr#L12"}],"repository_name":"edits","program":false,"enum":false,"alias":false,"aliased":null,"aliased_html":null,"const":false,"constants":[],"included_modules":[],"extended_modules":[{"html_id":"edits/Edits/Compare","kind":"module","full_name":"Edits::Compare","name":"Compare"}],"subclasses":[],"including_types":[],"namespace":{"html_id":"edits/Edits","kind":"module","full_name":"Edits","name":"Edits"},"doc":"Restricted Damerau-Levenshtein edit distance (Optimal Alignment).\n\nDetermines distance between two strings by counting edits, identifying:\n* Insertion\n* Deletion\n* Substitution\n* Adjacent transposition\n\nThis variant is restricted by the condition that no sub-string is edited\nmore than once.","summary":"<p>Restricted Damerau-Levenshtein edit distance (Optimal Alignment).</p>","class_methods":[{"html_id":"distance(str1,str2,max:Int):Int-class-method","name":"distance","doc":"Calculate the Restricted Damerau-Levenshtein distance (Optimal Alignment)\nof two sequences, bounded by a maximum value.\n\n```\nEdits::RestrictedEdit.distance(\"cloud\", \"crayon\")    # => 5\nEdits::RestrictedEdit.distance(\"cloud\", \"crayon\", 2) # => 2\n```","summary":"<p>Calculate the Restricted Damerau-Levenshtein distance (Optimal Alignment) of two sequences, bounded by a maximum value.</p>","abstract":false,"args":[{"name":"str1","doc":null,"default_value":"","external_name":"str1","restriction":""},{"name":"str2","doc":null,"default_value":"","external_name":"str2","restriction":""},{"name":"max","doc":null,"default_value":"","external_name":"max","restriction":"Int"}],"args_string":"(str1, str2, max : Int) : Int","args_html":"(str1, str2, max : Int) : Int","location":{"filename":"src/edits/restricted_edit.cr","line_number":108,"url":"https://github.com/tcrouch/edits.cr/blob/972692efbcd042473fa9cd72acf1ec119a97ce49/src/edits/restricted_edit.cr#L108"},"def":{"name":"distance","args":[{"name":"str1","doc":null,"default_value":"","external_name":"str1","restriction":""},{"name":"str2","doc":null,"default_value":"","external_name":"str2","restriction":""},{"name":"max","doc":null,"default_value":"","external_name":"max","restriction":"Int"}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"Int","visibility":"Public","body":"rows = str1.size\ncols = str2.size\nif rows.zero?\n  return cols > max ? max : cols\nend\nif cols.zero?\n  return rows > max ? max : rows\nend\nif rows < cols\n  str1, str2 = str2, str1\n  rows, cols = cols, rows\nend\nif (rows - cols) >= max\n  return max\nend\nif str1.single_byte_optimizable? && str2.single_byte_optimizable?\n  _distance(str1.to_slice, rows, str2.to_slice, cols, max)\nelse\n  _distance(Char::Reader.new(str1), rows, str2.chars, cols, max)\nend\n"}},{"html_id":"distance(str1,str2):Int-class-method","name":"distance","doc":"Calculate the Restricted Damerau-Levenshtein distance (Optimal Alignment)\nof two sequences.\n\nNOTE: Not a true distance metric, fails to satisfy triangle inequality.\n\n```\nRestrictedEdit.distance(\"iota\", \"atom\") # => 3\n```","summary":"<p>Calculate the Restricted Damerau-Levenshtein distance (Optimal Alignment) of two sequences.</p>","abstract":false,"args":[{"name":"str1","doc":null,"default_value":"","external_name":"str1","restriction":""},{"name":"str2","doc":null,"default_value":"","external_name":"str2","restriction":""}],"args_string":"(str1, str2) : Int","args_html":"(str1, str2) : Int","location":{"filename":"src/edits/restricted_edit.cr","line_number":23,"url":"https://github.com/tcrouch/edits.cr/blob/972692efbcd042473fa9cd72acf1ec119a97ce49/src/edits/restricted_edit.cr#L23"},"def":{"name":"distance","args":[{"name":"str1","doc":null,"default_value":"","external_name":"str1","restriction":""},{"name":"str2","doc":null,"default_value":"","external_name":"str2","restriction":""}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"Int","visibility":"Public","body":"rows = str1.size\ncols = str2.size\nif rows.zero?\n  return cols\nend\nif cols.zero?\n  return rows\nend\nif rows < cols\n  str1, str2 = str2, str1\n  rows, cols = cols, rows\nend\nif str1.single_byte_optimizable? && str2.single_byte_optimizable?\n  _distance(str1.to_slice, rows, str2.to_slice, cols)\nelse\n  _distance(Char::Reader.new(str1), rows, str2.chars, cols)\nend\n"}}],"constructors":[],"instance_methods":[],"macros":[],"types":[]}]}]}})