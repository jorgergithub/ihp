require 'spec_helper'
require 'random_utils'

describe RandomUtils do
  describe ".random_extension" do
    it "returns an unused extension" do
      existing_extensions = [*1..9999].map { |e| "%04d" % e } - ["0010"]
      expect(RandomUtils.random_extension(existing_extensions)).to eql("0010")
    end

    it "raises an exception if none left" do
      existing_extensions = [*1..9999].map { |e| "%04d" % e }
      expect { RandomUtils.random_extension(existing_extensions) }.to raise_error(/no extensions left/)
    end
  end
end
