class String
  def camelcase
    if self.match?(/_/)
      self.split('_').collect{|e| e.capitalize}.join
    else
      self
    end
  end
end
