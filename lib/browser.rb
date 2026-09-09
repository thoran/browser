# browser.rb
# Browser

class Browser
  LIST = %w{
    Brave
    Chrome
    Chromium
    Firefox
    Safari
    TorBrowser
  }
end

Browser::LIST.each do |browser|
  browser_filename = File.expand_path("#{__FILE__}/../Browser/#{browser}")
  require browser_filename
end

class Browser
  def self.new(name = nil, **options)
    return super(**options) unless self == Browser
    browser_name = LIST.detect{|browser| browser.downcase == name.to_s.downcase.delete('_')}
    raise ArgumentError, "Unknown browser: #{name.inspect}." unless browser_name
    const_get(browser_name).new(**options)
  end
end
