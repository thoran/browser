# browser/ROADMAP.md

Jobs are in TODO. What is here is undecided: questions to be answered rather than
work to be done, which is why they are prose and the jobs are a list.

## Whether a CSV library should do the escaping

`Array#to_csv_row` now quotes every field and doubles a quote within one, which is
correct, but it is our own reading of RFC 4180 rather than a library's. The stdlib
CSV would do it instead, and quote only the fields which need it, which is the
smaller file and the more usual shape. Against that, it is a second way of writing
a row in a library which already has one, and `to_csv_row` is used by History and
Bookmarks alike through one renderer.

The state at the tag `history-formatter-20250923` is the worked example: a
September 2025 side branch whose `History::Formatter::CSV` renders through
`::CSV.generate`. It was written and not taken up. It is also worth deciding
whether quoting every field is a convention worth keeping if the escaping moves.

## The Netscape bookmark file, and writing into browsers

The original purpose, from the load file's own header, was to dump every bookmark from
the browsers on one machine for import on another. Reading is done. The neutral format
for the other half is the Netscape bookmark file, the `<DT><A HREF=…>` HTML that every
browser on LIST both imports and exports: an export to it moves bookmarks between
browsers without writing into any browser's own store, which is the harder and the
riskier half, and may never be wanted.

## Platforms beyond macOS

Every `root_path` is a `~/Library` path and there is no platform detection anywhere.
Linux and Windows keep the same files in other places, and weblink has the idiom, a
`case` on `RbConfig::CONFIG['host_os']`. Safari's plist is the smallest part of the
port, Safari being macOS-only.

## Opera

Chromium-based, so the readers already fit. Where it keeps its data, on each platform,
is the whole question.

## Tags

Firefox's tags root is left out of the tree, a tag being a folder holding a copy of
every bookmark so tagged. Whether tags should surface at all, and if so as a column on
the flat records or otherwise, is open.

## Tor Browser installed outside /Applications

Its data then sits beside the application rather than under Application Support,
which the README says and `bookmarks_location:` and `history_location:` cover. Finding
the bundle instead would mean locating an application, which no other browser needs
and which does not port.
