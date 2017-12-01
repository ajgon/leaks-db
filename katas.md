```ruby
SmarterCSV.process('source.lk', col_sep: "\x1e", strip_whitespace: false, headers_in_file: false, remove_empty_values: false, convert_values_to_numeric: false, remove_empty_hashes: false, file_encoding: 'binary', force_simple_split: true, user_provided_headers: %w[login email password_plain password_hash hash_method salt salt_formula extra]) { |chunk| puts chunk.inspect; break  }
```
