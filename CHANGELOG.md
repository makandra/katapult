# Changelog

All notable changes to this project will be documented in this file. Changes are
segmented into: New Features / Improvements.

This project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## 0.6.0 - 2018-11-09

### New Features
- Turned `katapult templates` command into `katapult enhance`. It will now
  perform all required steps for enhancing an existing application: install
  Katapult, generate an application model, and copy over Katapult's templates.
- Enhancing an application multiple times will not generate file conflicts.
  Katapult will leave existing templates untouched and only generate missing
  files. It will also respect existing application models and generate new ones
  with a counter.


## 0.5.0 - 2018-11-09

### New Features
- Deployment ready for Opscomplete
- Copying view and controller templates over to target application via new
  command `katapult templates` or generator `katapult:templates`.

### Improvements
- Generating a fixed Gemfile.lock. Run `bundle update` after code generation to
  update all gems to recent versions.
- Better deployment with Webpack
- Navigation only rendered if requested
- "Usage" section in README rewritten
- Some minor fixes


## 0.4.1 - 2018-02-16

### Improvements
- Changed CHANGELOG to satisfy [How to write a good changelog](https://makandracards.com/makandra/54223-how-to-write-a-good-changelog) format
- Minor fixes and improvements


## 0.4.0 - 2018-01-15

### New Features
- Support for has_many/belongs_to associations
- Create a project README
- New CHANGELOG
- Models now inherit from `ApplicationRecord`


## 0.3.0 2018-01-11

### New Features
- Generating a Rails 5.1.4 app on Ruby 2.5.0
- Dropped asset pipeline in favor of Webpacker
- Employing [Unpoly](https://unpoly.com)
- New DSL command `crud` for creating Model plus WebUI
- The generated application model is now a transformable example of katapult's features
- The generated application now has a sleek, simple design based on Bootstrap
- Add katapult update script

### Improvements
- Speed up tests (now running in about 9 min)
- Improve development workflow (see README)
- No bundler issues in tests any more
