# Changelog

## 0.4.0 on 2018-01-15

### Features
- Support for has_many/belongs_to associations
- Create a project README
- New CHANGELOG

### Fixes
- Models now inherit from `ApplicationRecord`


## 0.3.0 on 2018-01-11

### Features
- Generating a Rails 5.1.4 app on Ruby 2.5.0
- Dropped asset pipeline in favor of Webpacker
- The generated application now has a sleek, simple design based on Bootstrap
- Employing [Unpoly](https://unpoly.com)
- New DSL command `crud` for creating Model plus WebUI
- The generated application model is now a transformable example of katapult's features

### Development improvements
- Add katapult update script
- Speed up tests (now running in about 9 min)
- Improve development workflow (see README)
- No bundler issues in tests any more

See [all changes](https://github.com/makandra/katapult/compare/v0.2.0...v0.3.0).
