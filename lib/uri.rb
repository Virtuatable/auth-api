# frozen_string_literal: true

# Reopening of the URI module to allow easier apopend of parameters to query.
# @author Vincent Courtois <courtois.vincent@outlook.com>
module URI
  def add_param(key, value)
    self.query = [query, "#{key}=#{value}"].compact.join('&')
  end
end
