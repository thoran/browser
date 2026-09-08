# Browser/FirefoxBased.rb
# Browser::FirefoxBased

require_relative './Base'

class Browser
  class FirefoxBased < Base
    class << self
      def bookmarks_location(profile_name: nil)
        profile_name ||= default_profile_name
        File.expand_path("#{profiles_path}/#{profile_name}/places.sqlite")
      end

      def history_location(profile_name: nil)
        profile_name ||= default_profile_name
        File.expand_path("#{profiles_path}/#{profile_name}/places.sqlite")
      end

      # The profile Firefox itself would open, which profiles.ini records: the one an
      # [Install] section names, as Firefox has written since 67; else the one
      # [Profile] flagged Default=1, as it wrote before and still does; else the only
      # profile there is.  A directory is named for a hash, so nothing else could
      # stand in for a name.
      def default_profile_name(profiles_ini = read_profiles_ini)
        File.basename(default_profile_path(profiles_ini))
      end

      private

      def profiles_ini_path
        File.expand_path("#{root_path}/profiles.ini")
      end

      def read_profiles_ini
        File.read(profiles_ini_path)
      rescue Errno::ENOENT
        raise Browser::Unreadable, "#{profiles_ini_path} is not there, so no profile is the default: pass profile_name:"
      end

      # Two installations each naming a default, or two profiles flagged, or three
      # profiles and no flag, are a question only the caller can answer.
      def default_profile_path(profiles_ini)
        candidates = default_profile_candidates(ini_sections(profiles_ini))
        unless candidates.size == 1
          raise Browser::Unreadable, "#{profiles_ini_path} names #{candidates.size} profiles as the default: pass profile_name:"
        end
        candidates.first
      end

      def default_profile_candidates(sections)
        installs = sections.select{|name, _| name.start_with?('Install')}.values.filter_map{|section| section['Default']}
        profiles = sections.select{|name, _| name.start_with?('Profile')}.values
        flagged = profiles.select{|section| section['Default'] == '1'}.filter_map{|section| section['Path']}
        [installs, flagged, profiles.filter_map{|section| section['Path']}].find{|candidates| candidates.any?} || []
      end

      def ini_sections(text)
        text.scan(/^\[([^\]]+)\]\n((?:[^\[\n].*\n?)*)/).to_h{|name, body| [name, body.scan(/^(\w+)=(.*)$/).to_h]}
      end

      def root_path
        raise NotImplementedError, "#{self} must implement root_path"
      end

      def profiles_path
        "#{root_path}/Profiles"
      end

      def bookmarks_format
        :sqlite
      end

      def history_format
        :sqlite
      end

      def bookmarks_sql
        'SELECT moz_bookmarks.id, moz_places.url, moz_bookmarks.title, moz_bookmarks.dateAdded FROM moz_bookmarks LEFT JOIN moz_places ON moz_bookmarks.fk = moz_places.id WHERE moz_bookmarks.type = 1 ORDER BY moz_bookmarks.dateAdded DESC;'
      end

      def history_sql
        'SELECT moz_historyvisits.id, moz_places.url, moz_places.title, moz_historyvisits.visit_date FROM moz_historyvisits LEFT JOIN moz_places ON moz_historyvisits.place_id = moz_places.id ORDER BY moz_historyvisits.visit_date DESC;'
      end
    end
  end
end
