# lcov

An LCOV parser and serializer.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     lcov:
       github: nishtahir/lcov
   ```

2. Run `shards install`

## Usage

```crystal
require "lcov"
```

To parse a file, read the content and invoke the Lcov parser

```
file = File.read("path/to/lcov_file.info")
report = Lcov.parse(file)
```

to serialize a report invoke `to_s`.

```
File.write("path/to/lcov_file.info", report)
```

## Contributing

1. Fork it (<https://github.com/nishtahir/lcov/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Nish Tahir](https://github.com/nishtahir) - creator and maintainer
