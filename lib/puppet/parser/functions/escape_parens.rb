module Puppet::Parser::Functions

  newfunction(:escape_parens, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|
    Take a string that may include parentheses and return a string where any parenthesis is escaped with a back slash.

    For example:

        $escaped = escape_parens('VARCHAR(80)')

        escaped would be 'VARCHAR\(80\)'
    ENDHEREDOC

    unless args.length == 1
      raise Puppet::ParseError, ("escape_parens(): wrong number of arguments (#{args.length}; must be 1)")
    end

    args[0].gsub('(','\(').gsub(')','\)')
  end
end
