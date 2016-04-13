class Hash

  def self.infinite
    new { |h, k| h[k] = new(&h.default_proc) }
  end

end
