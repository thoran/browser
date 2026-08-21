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
