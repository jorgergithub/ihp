require "spec_helper"

describe PsychicEvent do
  it { should belong_to :psychic }

  it { should validate_presence_of :psychic }
  it { should validate_presence_of :state }
end
