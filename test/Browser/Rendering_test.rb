# Rendering_test.rb

gem 'minitest'
gem 'minitest-spec-context'

require 'minitest/autorun'
require 'minitest-spec-context'
require 'rspec/expectations/minitest_integration'

lib_dir = File.expand_path(File.join(__FILE__, '..', '..', '..', 'lib'))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'browser'

describe Browser::Rendering do
  let(:records){[{title: 'Home', url: 'https://example.com/', folder: 'Bar'}, {title: 'Docs', url: 'https://example.com/docs', folder: ''}]}
  let(:column_names){%i{title url folder}}

  describe Browser::Rendering::CSV do
    it "renders the column names, then a row per record in their order, every field quoted" do
      expect(Browser::Rendering::CSV.new(records, column_names).render).to eq(%Q{"title","url","folder"\n"Home","https://example.com/","Bar"\n"Docs","https://example.com/docs",""\n})
    end

    it "renders the column names alone when there are no records" do
      expect(Browser::Rendering::CSV.new([], column_names).render).to eq(%Q{"title","url","folder"\n})
    end

    it "takes the columns in the order given, whatever the records' own" do
      expect(Browser::Rendering::CSV.new(records, %i{url title}).render).to eq(%Q{"url","title"\n"https://example.com/","Home"\n"https://example.com/docs","Docs"\n})
    end
  end

  describe Browser::Rendering::JSON do
    it "renders the records as a JSON array" do
      expect(Browser::Rendering::JSON.new(records).render).to eq(records.to_json)
    end
  end

  describe Browser::Rendering::Plist do
    it "renders the records as an XML property list which reads back as they were" do
      plist = Browser::Rendering::Plist.new(records).render
      read_back = CFPropertyList.native_types(CFPropertyList::List.new(data: plist).value)
      expect(plist).to start_with('<?xml')
      expect(read_back).to eq(records.collect{|record| record.transform_keys(&:to_s)})
    end
  end
end
