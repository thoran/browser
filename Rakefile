require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files = FileList['test/**/*_test.rb']
end

task default: :test

namespace :fixtures do
  desc "Build test/fixtures/ChromiumBased_history.sqlite"
  task :chromium_based_history do
    require 'fileutils'
    require 'sqlite3'
    path = File.join(__dir__, 'test/fixtures/ChromiumBased_history.sqlite')
    FileUtils.rm_f(path)
    db = SQLite3::Database.new(path)
    # The urls table as Chromium creates it, shared by every Chromium-based browser.
    db.execute_batch(<<~SQL)
      CREATE TABLE urls(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        url LONGVARCHAR,
        title LONGVARCHAR,
        visit_count INTEGER DEFAULT 0 NOT NULL,
        typed_count INTEGER DEFAULT 0 NOT NULL,
        last_visit_time INTEGER NOT NULL,
        hidden INTEGER DEFAULT 0 NOT NULL
      );
      CREATE INDEX urls_url_index ON urls (url);
    SQL
    # last_visit_time is microseconds since 1601-01-01, which is Chromium's epoch.
    [
      ['https://www.chromium.org/chromium-projects/', 'Home', 3, 1, 13403232000000000, 0],
      ['chrome://welcome/', 'Welcome', 1, 0, 13403231000000000, 0],
    ].each do |row|
      db.execute('INSERT INTO urls (url, title, visit_count, typed_count, last_visit_time, hidden) VALUES (?, ?, ?, ?, ?, ?)', row)
    end
    db.close
    puts "Wrote #{path} (#{File.size(path)} bytes)."
  end

  desc "Build test/fixtures/FirefoxBased_places.sqlite"
  task :firefox_based_places do
    require 'fileutils'
    require 'sqlite3'
    path = File.join(__dir__, 'test/fixtures/FirefoxBased_places.sqlite')
    FileUtils.rm_f(path)
    db = SQLite3::Database.new(path)
    # moz_places, moz_bookmarks and moz_historyvisits as Firefox creates them.  A
    # bookmark's label is moz_bookmarks.title; moz_places.title is the page's own, and
    # is empty until the page has been visited.
    db.execute_batch(<<~SQL)
      CREATE TABLE moz_origins (
        id INTEGER PRIMARY KEY, prefix TEXT NOT NULL, host TEXT NOT NULL,
        frecency INTEGER NOT NULL, recalc_frecency INTEGER NOT NULL DEFAULT 0,
        alt_frecency INTEGER, recalc_alt_frecency INTEGER NOT NULL DEFAULT 0,
        block_until_ms INTEGER, block_pages_until_ms INTEGER, UNIQUE (prefix, host)
      );
      CREATE TABLE moz_places (
        id INTEGER PRIMARY KEY, url LONGVARCHAR, title LONGVARCHAR,
        rev_host LONGVARCHAR, visit_count INTEGER DEFAULT 0,
        hidden INTEGER DEFAULT 0 NOT NULL, typed INTEGER DEFAULT 0 NOT NULL,
        frecency INTEGER DEFAULT -1 NOT NULL, last_visit_date INTEGER, guid TEXT,
        foreign_count INTEGER DEFAULT 0 NOT NULL, url_hash INTEGER DEFAULT 0 NOT NULL,
        description TEXT, preview_image_url TEXT, site_name TEXT,
        origin_id INTEGER REFERENCES moz_origins(id),
        recalc_frecency INTEGER NOT NULL DEFAULT 0, alt_frecency INTEGER,
        recalc_alt_frecency INTEGER NOT NULL DEFAULT 0
      );
      CREATE TABLE moz_bookmarks (
        id INTEGER PRIMARY KEY, type INTEGER, fk INTEGER DEFAULT NULL,
        parent INTEGER, position INTEGER, title LONGVARCHAR, keyword_id INTEGER,
        folder_type TEXT, dateAdded INTEGER, lastModified INTEGER, guid TEXT,
        syncStatus INTEGER NOT NULL DEFAULT 0, syncChangeCounter INTEGER NOT NULL DEFAULT 1
      );
      CREATE TABLE moz_historyvisits (
        id INTEGER PRIMARY KEY, from_visit INTEGER, place_id INTEGER,
        visit_date INTEGER, visit_type INTEGER, session INTEGER,
        source INTEGER DEFAULT 0 NOT NULL, triggeringPlaceId INTEGER
      );
    SQL

    # dateAdded and visit_date are microseconds since 1970-01-01, which is Firefox's epoch.
    added = 1787449000000000

    [
      [1, 'https://support.mozilla.org/products/firefox', nil, 'gro.allizom.troppus.'],
      [2, 'https://support.mozilla.org/kb/customize-firefox-controls-buttons-and-toolbars', nil, 'gro.allizom.troppus.'],
      [3, 'https://www.mozilla.org/contribute/', nil, 'gro.allizom.www.'],
      [4, 'https://www.mozilla.org/about/', nil, 'gro.allizom.www.'],
      [5, 'https://addons.mozilla.org/en-US/firefox/', 'Extension Starter Pack', 'gro.allizom.snodda.'],
    ].each do |id, url, title, rev_host|
      db.execute('INSERT INTO moz_places (id, url, title, rev_host) VALUES (?, ?, ?, ?)', [id, url, title, rev_host])
    end

    # type 2 is a folder, type 1 a bookmark.  The roots are fixed ids with padded guids.
    [
      [1, 2, nil, 0, 0, nil, 'root________'],
      [2, 2, nil, 1, 0, 'menu', 'menu________'],
      [3, 2, nil, 1, 1, 'toolbar', 'toolbar_____'],
      [4, 2, nil, 1, 2, 'tags', 'tags________'],
      [5, 2, nil, 1, 3, 'unfiled', 'unfiled_____'],
      [6, 2, nil, 1, 4, 'mobile', 'mobile______'],
      [7, 2, nil, 2, 0, 'Mozilla Firefox', 'j47T12MG8hux'],
      [8, 1, 1, 7, 0, 'Get Help', '50OxxDFUahwc'],
      [9, 1, 2, 7, 1, 'Customize Firefox', 'dTBx_Z-u_6U6'],
      [10, 1, 3, 7, 2, 'Get Involved', 'l00bhg3kKbYX'],
      [11, 1, 4, 7, 3, 'About Us', 'pJ9IZ7ivzMw6'],
    ].each do |id, type, fk, parent, position, title, guid|
      db.execute(
        'INSERT INTO moz_bookmarks (id, type, fk, parent, position, title, dateAdded, lastModified, guid) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [id, type, fk, parent, position, title, added + id, added + id, guid]
      )
    end

    db.execute('INSERT INTO moz_historyvisits (id, place_id, visit_date, visit_type) VALUES (?, ?, ?, ?)', [1, 5, added + 152741667, 1])
    db.close
    puts "Wrote #{path} (#{File.size(path)} bytes)."
  end

  desc "Build test/fixtures/Safari_history.sqlite"
  task :safari_history do
    require 'fileutils'
    require 'sqlite3'
    path = File.join(__dir__, 'test/fixtures/Safari_history.sqlite')
    FileUtils.rm_f(path)
    db = SQLite3::Database.new(path)
    # history_items and history_visits as Safari creates them.
    db.execute_batch(<<~SQL)
      CREATE TABLE history_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        url TEXT NOT NULL UNIQUE,
        domain_expansion TEXT NULL,
        visit_count INTEGER NOT NULL,
        daily_visit_counts BLOB NOT NULL,
        weekly_visit_counts BLOB NULL,
        autocomplete_triggers BLOB NULL,
        should_recompute_derived_visit_counts INTEGER NOT NULL,
        visit_count_score INTEGER NOT NULL
      );
      CREATE TABLE history_visits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        history_item INTEGER NOT NULL REFERENCES history_items(id) ON DELETE CASCADE,
        visit_time REAL NOT NULL,
        title TEXT NULL,
        load_successful BOOLEAN NOT NULL DEFAULT 1,
        http_non_get BOOLEAN NOT NULL DEFAULT 0,
        synthesized BOOLEAN NOT NULL DEFAULT 0,
        redirect_source INTEGER NULL UNIQUE,
        redirect_destination INTEGER NULL UNIQUE,
        origin INTEGER NOT NULL DEFAULT 0,
        generation INTEGER NOT NULL DEFAULT 0,
        attributes INTEGER NOT NULL DEFAULT 0,
        score INTEGER NOT NULL DEFAULT 0
      );
      CREATE INDEX history_visits_history_item_index ON history_visits (history_item);
    SQL
    [
      [1, 'https://www.apple.com/', 'apple', 3, 1],
      [2, 'https://support.apple.com/', 'support.apple', 1, 0],
    ].each do |id, url, domain, visit_count, score|
      db.execute(
        'INSERT INTO history_items (id, url, domain_expansion, visit_count, daily_visit_counts, should_recompute_derived_visit_counts, visit_count_score) VALUES (?, ?, ?, ?, ?, 0, ?)',
        [id, url, domain, visit_count, SQLite3::Blob.new(''), score]
      )
    end
    # visit_time is seconds since 2001-01-01, which is Core Data's epoch.
    [
      [1, 1, 780451200.0, 'Apple'],
      [2, 2, 780450000.0, 'Apple Support'],
    ].each do |id, item, time, title|
      db.execute('INSERT INTO history_visits (id, history_item, visit_time, title) VALUES (?, ?, ?, ?)', [id, item, time, title])
    end
    db.close
    puts "Wrote #{path} (#{File.size(path)} bytes)."
  end
end
