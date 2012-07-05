#!/usr/bin/ruby
require "#{File.dirname(__FILE__)}/database_utility/database_utility.rb"

USAGE = %{
          Usage ......
          dump 'configuration_name',                                       Dump local database to local machine
          undump 'configuration_name' "path/to/dump_file.[sql and or gz]", Dump specified dump file back into the local database
          get_remote 'configuration_name',                                 Dump database on remote host to local machine
          sync_with_remote 'configuration_name',                           Create local backup and Dump the remote database into the local database
         }

begin
  if ARGV[0] and DataBaseUtility.set_configs(ARGV[1])
    puts "Started: #{ARGV.join(', ')}"
    Thread.new do
      while true
        STDOUT.flush
        print '.'
        sleep 1
      end
    end
    if ARGV[2]
      DataBaseUtility.send(ARGV[0], ARGV[2])
    else
      DataBaseUtility.send(ARGV[0])
    end
    puts "\nCompleted!" if ARGV[0]
  else
    puts USAGE
  end
  exit
rescue
  puts USAGE
end
