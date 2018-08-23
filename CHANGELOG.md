# Changelog
All notable changes to this project will be documented in this file.

This project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).


## Unreleased

### Compatible changes
- Changed CHANGELOG to satisfy [How to write a good changelog](https://makandracards.com/makandra/54223-how-to-write-a-good-changelog) format

## 0.4.0 - 2018-01-15

### Added
- Support for has_many/belongs_to associations
- Create a project README
- New CHANGELOG

### Fixed
- Models now inherit from `ApplicationRecord`

## 0.3.0 2018-01-11

### Changed
- Generating a Rails 5.1.4 app on Ruby 2.5.0
- Dropped asset pipeline in favor of Webpacker
- The generated application now has a sleek, simple design based on Bootstrap
- Employing [Unpoly](https://unpoly.com)
- New DSL command `crud` for creating Model plus WebUI
- The generated application model is now a transformable example of katapult's features
- Add katapult update script
- Speed up tests (now running in about 9 min)
- Improve development workflow (see README)
- No bundler issues in tests any more

