class String
  def to_seconds
    self.split(':').map { |a| a.to_i }.inject(0) { |a, b| a * 60 + b}
  end
end