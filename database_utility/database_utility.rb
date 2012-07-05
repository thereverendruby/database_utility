require 'date'
require "#{File.dirname(__FILE__)}/config.rb"

module DataBaseUtility

  def self.dump
    `#{dump_command} #{local_database}-local-#{file_name}`
  end

  def self.undump(fl)
    unless fl
      puts "\nYou Must Specify A File To UnDump!\n\n"
      exit!
    end
    if fl =~ /\.gz/
      `gunzip #{fl} -c | mysql #{db_local_command}`
    else
      `mysql #{db_local_command} < #{ARGV[2]}`
    end
  end

  def self.get_remote
    `#{get_remote_command} > #{@remote_database}-remote-#{file_name}`
  end

  def self.sync_with_remote
    puts 'Creating local backup'
    `#{dump_command} #{local_database}-sync_backup-#{file_name}`
    puts "\nSyncing now"
    `#{get_remote_command} | gunzip -c | mysql #{db_local_command}`
  end

  private
  def self.file_name
    "#{DateTime.now.strftime('%Y-%m-%d-%H-%M-%S')}.sql.gz"
  end

  def self.get_remote_command
    "ssh -C #{ssh_options} #{host_user}@#{host} \"mysqldump --opt --compress #{remote_database} -u#{remote_db_user} -p#{remote_db_password} | gzip -9 -c\" "
  end

  def self.dump_command
    "mysqldump -u#{local_db_user} -p#{local_db_password} #{local_database} | gzip > "
  end

  def self.db_local_command
    "-u#{local_db_user} -p#{local_db_password} #{local_database}"
  end
end
