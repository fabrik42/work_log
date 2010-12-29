require 'yaml'
require 'rubygems'
require 'date'
require 'chronic'

module WorkLog

  class Logger

    attr_accessor :logfile
    attr_accessor :entries

    HOME_PATH           = ENV['HOME']
    CONFIGURATION_FILE  = HOME_PATH + "/.work_log_gem"
    DEFAULT_LOGFILE     = HOME_PATH + "/work_log.yml"

    def initialize(args)
      action = args.shift
      load_config

      begin
        load
      rescue
        save
        load
      end

      time = args.empty? ? DateTime.now : DateTime.parse((Chronic.parse(args.join(' ')) || DateTime.now).to_s)

      puts '', ''

      if action == 'start' || action == 's'
        add "Work started", time
        print entries.last
      elsif action == 'end' || action == 'e'
        add "Work ended", time
        print entries.last
      elsif action == 'all' || action == 'a'
        entries.each {|e| print e }
      elsif action == 'week' || action == 'w'
        puts "Entries for this week:"
        entries.select{|entry| entry['time'].cwyear == Date.today.cwyear && entry['time'].cweek == Date.today.cweek }.each {|e| print e }
      elsif action == 'since'
        puts "Entries since #{args.join(' ')}"
        entries.select{|entry| entry['time'] > time }.each {|e| print e }
      elsif action == 'last'
        print entries.last
      elsif action == 'undo'
        removed_entry = entries.pop
        save
        puts "Removed the following entry:"
        print removed_entry
      else
        puts "Unknown arguments."
      end

      puts '', ''

    end

    def load_config
      return @logfile = DEFAULT_LOGFILE unless File.exist?(CONFIGURATION_FILE)

      config = YAML::load_file(CONFIGURATION_FILE)
      @logfile = config['logfile'] ? config['logfile'] : DEFAULT_LOGFILE
    end

    def print(entry)
      puts "#{entry['time'].strftime("%a, %b %d %Y at %H:%M")} -> #{entry['message']}"
    end

    def add(message, time = DateTime.now)
      @entries << {
        'time'    => time,
        'message' => message
      }
      save
    end

    def load
      file_content = YAML.load_file(logfile)
      @entries = file_content && file_content['entries'] ? file_content['entries']: []
      @entries.each {|entry| entry['time'] = DateTime.parse entry['time'].to_s }
      @entries
    end

    def save
      File.open(logfile, 'w') do |file|
        file.write YAML.dump({'entries' => entries})
      end
    end

  end

end
