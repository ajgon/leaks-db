Data file should contain following fields in that particular order,
separated by `\x1e` ascii character. Each row should be separated by `\n`.
Every field can be empty. The file name should be `<source>.lk` i.e. `linkedin.lk`
and you need to create corresponding source row in `sources` index.

* login
* email
* password in plain text
* password hash
* hashing method
  * plain (no hash)
  * md5
  * sha1
  * more to come...
* salt
* how salt is applied (not implemented yet, leave empty)
* json blob with any extra information
