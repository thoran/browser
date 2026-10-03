# browser/ROADMAP.md

The discrete jobs are in TODO. What is here is the direction: themes larger than any
one change, each with whatever about it is still undecided.

## One representation for both bookmarks and history

Bookmarks have `Browser::Bookmark`, one shape whatever the browser. History has no
representation at all: `to_objects` zips each browser's own column names to its rows,
so Chrome yields `visit_count`, `typed_count` and `hidden` where Firefox yields none
of them, and Safari has no title. A neutral record of url, title and a `Time` would
make one browser's history convertible to another's, which is the stated purpose, but
it drops what only one browser keeps. Whether that record replaces the raw columns or
sits beside them, and whether the surplus fields are carried or lost, is undecided.

Bookmarks are closer but not there. The roots have no canonical identity: Firefox's
menu, toolbar, unfiled and mobile become display titles, where Chromium's and Safari's
are not normalised at all, so a converted toolbar arrives as a folder named after one.
`Browser::Bookmark` carries title, name, url and children, and drops what all three
sources hold besides: the dates added and modified, and the guid a second import would
need if it is not to duplicate everything. Separators are skipped. Firefox's tags root
is left out, a tag being a folder holding a copy of every bookmark so tagged, and
whether tags should surface at all, and if so as a column or otherwise, is open.

## Writing into browsers

The original purpose, from the load file's own header, was to dump every bookmark from
the browsers on one machine for import on another. Reading is done. The neutral format
for the other half is the Netscape bookmark file, the `<DT><A HREF=…>` HTML that every
browser on LIST both imports and exports: an export to it moves bookmarks between
browsers without writing into any browser's own store, which is the harder and the
riskier half, and may never be wanted.

## Cookies

The third thing a browser stores, and the one which would make a client useful. Both
Chromium and Firefox keep it beside the bookmarks already found, as `Cookies` and
`cookies.sqlite`, so a `Browser::Cookies` including `Rendering` is a small addition.
Safari is the outlier again, keeping `Cookies.binarycookies` outside the profile in a
format of its own. Writing them means mutating a store a running browser holds open,
which `readable?` and `Browser::Unreadable` already model for reads.

## A client, for scraping and spidering

Fetching a URL, keeping a cookie jar, parsing the HTML and extracting from it. What
this library would bring to it is the stored data beside it: a jar seeded from the
Chrome profile already signed in is something the fetch libraries cannot offer.
Whether it belongs here or in a gem which depends on this one is undecided, since a
consumer who wants bookmarks should not have to acquire a parser to get them.

## Driving a browser

A front end to Selenium, which wants a real profile directory rather than a throwaway
one. 0.13.0 resolves which profile that is and where it sits, and 0.17.0 opens the
path as `profile_path`, so what is left is the front end itself. Rendering a page is
not this. An engine is a separate project, and would consume a client rather than
live here.

## Platforms beyond macOS

Every `root_path` is a `~/Library` path and there is no platform detection anywhere.
Linux and Windows keep the same files in other places, and weblink has the idiom, a
`case` on `RbConfig::CONFIG['host_os']`. Safari's plist is the smallest part of the
port, Safari being macOS-only.

## Opera

Chromium-based, so the readers already fit. Where it keeps its data, on each platform,
is the whole question.

## The require path

Both this gem and Nando Vieira's `browser`, the user-agent parser, install a
`lib/browser.rb`, so `require 'browser'` resolves by load-path order in a project
which depends on both, and a scraper is the sort of program that would want both.
That gem is current, 6.2.0 in December 2024, so the clash is with something common.
`require 'browser-classes'` is unambiguous, reaching this gem through
`require_relative`, but it also defines six top-level names, so it is not a neutral
way in. A second entry point under a namespace, say `thoran/browser`, would settle
it. 0.16.0 is published with the plain name, so moving it is now a breaking change
rather than a free choice.
