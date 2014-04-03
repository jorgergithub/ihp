class CallDurationRounder
  def initialize(seconds)
    @seconds = seconds
  end

  def round
    (@seconds.to_f / 60.to_f).ceil
  end
end
