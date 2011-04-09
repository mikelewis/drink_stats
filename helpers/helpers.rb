module DrinkStats
  module Helpers
    def pretty_date(date, hours=true)
      if !date.is_a?(Fixnum)
        date.strftime("%B %d#{", %Y" if date.year != Date.today.year} #{"%I:%M%p" if hours}")
      else
        "Hour #{date}"
      end
    end
    def debug_mysql(result)
      result.to_a
    end
    def generate_graph_items(arr, key, options={})
      options[:integer] ||= false
      options[:quoted] ||= false
      options[:link] ||= false
      arr.map do |d|
        el = (options[:qouted]) ? "\"#{d[key]}\"" : d[key]
        el = el.to_i if options[:integer]
        el = "#{"/" if options[:link] != ""}#{options[:link]}/#{el}" if options[:link]
        el
      end
    end
  end
end
