require 'mysql2'

#ssh -f -N madmike@rancor.csh.rit.edu -L 3307:db.csh.rit.edu:3306

module Sinatra::Partials
  def partial(template, *args)
    template_array = template.to_s.split('/')
    template = template_array[0..-2].join('/') + "/_#{template_array[-1]}"
    options = args.last.is_a?(Hash) ? args.pop : {}
    options.merge!(:layout => false)
    if collection = options.delete(:collection) then
      collection.inject([]) do |buffer, member|
        buffer << haml(:"#{template}", options.merge(:layout =>
                                                     false, :locals => {template_array[-1].to_sym => member}))
      end.join("\n")
    else
      haml(:"#{template}", options)
    end
  end

end

module DrinkStatHelper
  module Helpers
    def pretty_date(date)
      date.strftime("%B %d#{", %Y" if date.year != Date.today.year} %I:%M%p")
    end

  end

  class Database
    def initialize
      @connection ||=  Mysql2::Client.new(:host => "127.0.0.1", :username => "drink_read", :password => "drink_read", :port=>3307, :database=>"drink")
    end

    def get_top_drinks(username=nil)
      where_clause = (username) ? "WHERE username = '#{escape(username)}'" : ""
      query("SELECT COUNT(slot) as slot_count, slot FROM drop_log #{where_clause}  GROUP BY slot ORDER BY slot_count DESC LIMIT 10")
    end

    def get_top_ten_users(options={})
      where_clause = case
                     when options[:all_time]
                       ""
                     when options[:year]
                       "WHERE YEAR(time) = '#{options[:year]}'"
                     else
                       "WHERE YEAR(time) = YEAR(CURDATE())"
                     end

      query("SELECT COUNT(*) as row_count, username FROM drop_log #{where_clause} GROUP BY username ORDER BY row_count DESC LIMIT 10")
    end

    def get_recent_drops(username=nil)
      where_clause = (username) ? "WHERE username = '#{escape(username)}'" : ""
      query("SELECT * FROM drop_log #{where_clause} ORDER BY time DESC LIMIT 10")
    end

    def top_users_per_drink(item)
      query("SELECT COUNT(*) as row_count, username, slot FROM drop_log WHERE slot='#{escape(item)}' GROUP BY username ORDER BY row_count DESC LIMIT 10")
    end

    private 
    def escape(str)
      @connection.escape(str)
    end

    def query(sql)
      @connection.query(sql)
    end

  end
end
