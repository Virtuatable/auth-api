module URI
  def add_param(key, value)
    self.query = [self.query, "#{key}=#{value}"].compact.join('&')
  end
end