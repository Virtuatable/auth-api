# frozen_string_literal: true

module URI
  def add_param(key, value)
    self.query = [query, "#{key}=#{value}"].compact.join('&')
  end
end
