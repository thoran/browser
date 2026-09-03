class String
  def ascii_only
    self.bytes.select{|byte| byte.between?(0x20, 0x7e)}.pack('C*')
  end
end
