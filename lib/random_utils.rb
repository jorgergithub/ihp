class RandomUtils
  def self.digits_s(len)
    "%0#{len}d" % rand(10 ** len)
  end

  def self.alpha_s(len)
    o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
    (0...len).map{ o[rand(o.length)] }.join
  end

  def self.random_extension(existing_extensions)
    all_extensions  = [*1..9999].map { |e| "%04d" % e }
    extensions_left = all_extensions - existing_extensions
    raise "no extensions left" if extensions_left.length < 1
    extensions_left.sample
  end
end
