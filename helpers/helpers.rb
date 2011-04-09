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
  end
end
