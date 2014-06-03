require 'etc'
require 'facter'

begin
  getent = Etc.getpwnam('oracle')

  fh = File.expand_path('~oracle') << '/.locked_users_query.sql'

  if File.readable?(fh)

    oracle_home = getent['dir']
    locked_users = Array.new

    query = Facter::Util::Resolution.exec("su -l oracle -c 'sqlplus /nolog @#{oracle_home}/.locked_users_query.sql'")

    query.each_line do |line|
      name = line.split[0]
      if line =~ /LOCKED/
        locked_users << name
      end

      Facter.add('oracle_locked_users') do
        setcode do
          locked_users
        end
      end
    end
  end
# if there are any errors, we rescue and do not add the fact.
rescue
end
