# browser.rb

## Description

Read the bookmarks and history of the web browsers on a machine — Brave, Chrome,
Chromium, Firefox, Safari and Tor Browser — and render them to CSV, JSON or a
property list.  Bookmarks and history each come through as one common representation
whatever the browser.

## Installation

Add this line to your application's Gemfile:
```ruby
gem 'browser.rb'
```

And then execute:
```shell
$ bundle
```

Or install directly:
```shell
$ gem install browser.rb
```

Note the `.rb`. The plain `browser` gem is someone else's — a user-agent parser —
so this one is `browser.rb`. The require is the plain name, as it is for `http.rb`:
```ruby
require 'browser'
```
The `gem 'browser.rb'` line is what makes that require load this gem rather than
the other; the two ship the same file name.

## Usage

```ruby
require 'browser'

chrome = Browser.new(:chrome)
chrome.bookmarks.to_objects   # => [{title:, url:, folder:}, ...]
chrome.bookmarks.tree         # => Browser::Bookmark, the folders and all
chrome.bookmarks.to_csv       # title,url,folder rows
chrome.bookmarks.to_json
chrome.history.to_objects     # => [{url:, title:, visited_at:}, ...]
chrome.history.visits         # => Browser::Visit, the browser's own columns too
chrome.profile_path           # => the directory the profile sits in
```

Name a browser by string or symbol, in any case:
```ruby
Browser.new(:brave)
Browser.new('TorBrowser')
Browser.new('tor_browser')
```

Firefox and Tor Browser open the profile their profiles.ini names as the default, so
none need be named. To reach another:
```ruby
Browser.new(:firefox, profile_name: 'abcd1234.default-release').bookmarks.to_objects
```

Or opt into top-level names:
```ruby
require 'browser-classes'
Chrome.new.bookmarks
```

The renderers are `to_objects` (an array of `{title:, url:, folder:}`), `to_csv`,
`to_json` and `to_plist`. `dump(format:, path:, filename:)` writes one to a file and
returns the path. `readable?` says whether the data can be read right now.

Underneath the renderers, `bookmarks.tree` is the bookmarks as `Browser::Bookmark`:
a titleless root whose children are the browser's own roots, each folder holding its
children. The renderers flatten that to leaves and drop the folders, so the tree is
where a folder, or `Bookmark#name`, is to be had.

`history.visits` is the history as `Browser::Visit`: a `url`, a `title` and
`visited_at`, which is a `Time` in UTC, with the browser's own row kept on
`attributes`. The three browsers count from three epochs — Chromium in microseconds
from 1601, Firefox in microseconds from 1970, Safari in seconds from 2001 — and all
three arrive converted. `attributes` carries everything else the browser holds which
a consumer could want, leaving out its internal keys, index helpers and ranking
scores: Firefox's `guid`, `description` and `visit_type`, Safari's `load_successful`
and `status_code`, the Chromium family's `typed_count`.

`profile_path` is the directory the profile sits in, which a Selenium front end wants
in place of a throwaway one. Safari, having no profiles, answers `nil`.

## Capabilities

| browser | bookmarks read from | history read from | folders | profile |
|---|---|---|---|---|
| Brave | JSON | SQLite | yes | default, or named |
| Chrome | JSON | SQLite | yes | default, or named |
| Chromium | JSON | SQLite | yes | default, or named |
| Firefox | SQLite, places.sqlite | SQLite, the same file | yes | default, or named |
| Safari | binary plist | SQLite | yes | none |
| Tor Browser | SQLite, places.sqlite | SQLite, the same file | yes | default, or named |

## Caveats

- **macOS only, for now.** Every location is a macOS path; Linux and Windows are on
  the Todo.
- **A Chromium row is a URL, not a visit.** Chromium's history table holds one row per
  URL, with a visit count and the time it was last visited, where Firefox and Safari
  hold one row per visit. So a page visited three times is one record for Chrome,
  Chromium and Brave and three for the others, and their `visited_at` is the last
  visit rather than a visit. `attributes` carries `visit_count` for the family.
- **A running browser locks its database.** History, and Firefox's bookmarks, are
  read from SQLite, which the browser locks while it is open — so reading a browser
  you are using raises `Browser::Unreadable`. Ask `readable?` first, or quit it.
- **Which Firefox profile.** Firefox and Tor Browser keep profiles in hashed
  directories, and the default is the one profiles.ini names, which is the one
  Firefox itself would open. A directory named plainly `default` is usually a
  leftover, the live one being `<hash>.default-release`, and the install entry in
  profiles.ini knows which. Two installations, say release and Nightly, each name a
  default, and then `profile_name:` is required.
- **Tor Browser is looked for in `~/Library/Application Support/TorBrowser-Data`.**
  That is where an install in `/Applications` keeps its data. One installed elsewhere
  keeps it beside the application, and wants `bookmarks_location:` and
  `history_location:` passed to the constructor.
- **Safari's Bookmarks.plist is a mirror.** With iCloud bookmark sync on, a sync
  agent maintains it and writes it on change, so it can be absent while Safari is
  working perfectly. It is a binary property list, read here via CFPropertyList.

## History

I realised when wanting to dump all bookmarks from any browsers on one machine for import to another that I'd already written something of the sort for history called dump_browser_history_to_csv and that it would probably be a good idea to combine those efforts into a single browser library to handle both bookmarks and history, as well as any other similar browser data extraction effort.

## Contributing

1. Fork it (https://github.com/thoran/browser/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new pull request

## License

MIT
