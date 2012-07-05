module DataBaseUtility
# ADD TO .gitignore if using in a public project

  def self.configs
    c = {}
    c[:your_confg] = {
                      :local_database     => '',
                      :local_db_user      => '',
                      :local_db_password  => '', # leave blank to prompt
                      :host               => '',
                      :host_user          => '',
                      :remote_database    => '',
                      :remote_db_user     => '',
                      :remote_db_password => '', # leave blank to prompt
                      :ssh_options        => '-oport=2212 or whatever',
                      :dump_path          => "path to put the dump files"
                     }
    # add more here
    c
  end

  private
  def self.set_configs(name)
    if name and configs[name.to_sym]
      configs[name.to_sym].each do |index, value|
        eval %{
              def self.#{index}
                '#{value}'
              end
              }
      end
      true
    else
      puts 'Configuration Not Found...'
      puts "Configs Available: #{configs.collect { |index, value| index }.join(', ')}"
      false
    end
  end
end
