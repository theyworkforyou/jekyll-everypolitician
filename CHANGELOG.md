# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [0.7.0] - 2015-12-16

### Changed

- Switched to using Jekyll 3.0's new hook system. We now add EveryPolitician data using a `:site` `:post_read` hook, which means that collections will be populated before any of the generators get run. This makes it easier to write a generator that does something with the EveryPolitician generated collections.

## [0.6.0] - 2015-12-03

### Removed

- Removed the dependency on Active Support - it turned out to not be necessary as Jekyll already has slug related functions built in.

## [0.5.0] - 2015-12-03

### Added

- If you've specified multiple sources the layout property for each document in the collection will first try to use `sourcename_collectionname.html` then fallback to `collectionname.html`. E.g. if you'd specified a source for `assembly`, objects in the `people` collection would first try to use `assembly_people.html`, then fallback to `people.html`.

## [0.4.0] - 2015-12-03

### Changed

- `Jekyll::Everypolitician::Generator` is now `:high` priority. This means it will get run before plugins that don't declare a priority. This should make it easier to make other plugins that depend on the data that `jekyll-everypolitician` adds to the `site` object.

## [0.3.0] - 2015-12-02

### Changed

- `everypolitician_url` in `_config.yml` has been renamed to `everypolitician` and is now a hash. See the [Usage section in the README](https://github.com/everypolitician/jekyll-everypolitician/blob/2d9d9d562e99608b33038f712305c179e0196c8e/README.md#usage) for more details on how to use this. This means you can specify multiple sources for your data [#2](https://github.com/everypolitician/jekyll-everypolitician/issues/2)
- `persons` collection is now called `people` [#3](https://github.com/everypolitician/jekyll-everypolitician/issues/3)

### Fixed

- We no longer raise an error if the config is missing.

## [0.2.0] - 2015-12-02

### Changed

- You can now set `everypolitician_url` in `_config.yml` to an everypolitician popolo url

## 0.1.0 - 2015-12-02

- Initial release


[0.2.0]: https://github.com/everypolitician/jekyll-everypolitician/compare/v0.1.0...v0.2.0
[0.3.0]: https://github.com/everypolitician/jekyll-everypolitician/compare/v0.2.0...v0.3.0
[0.4.0]: https://github.com/everypolitician/jekyll-everypolitician/compare/v0.3.0...v0.4.0
[0.5.0]: https://github.com/everypolitician/jekyll-everypolitician/compare/v0.4.0...v0.5.0
[0.6.0]: https://github.com/everypolitician/jekyll-everypolitician/compare/v0.5.0...v0.6.0
[0.7.0]: https://github.com/everypolitician/jekyll-everypolitician/compare/v0.6.0...v0.7.0
