# String/pascalcase.rb
# String#pascalcase

# 20230923
# 0.0.0

class String
  def pascalcase
    if self.match?(/_/)
      self.split('_').collect{|e| e.capitalize}.join
    else
      self
    end
  end
end
