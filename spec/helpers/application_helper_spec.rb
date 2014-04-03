require "spec_helper"

describe ApplicationHelper do
  describe "#limit_text" do
    let(:long_text)  { "This is a very long text with millions of characters!" }
    let(:short_text) { "Told you" }

    it "limits text to the given amount" do
      expect(limited_text(long_text, 10)).to include long_text[0..9]
    end

    it "adds ... to the end of the text" do
      expect(limited_text(long_text, 10)).to include "..."
    end

    context "when text is shorter than limit" do
      it "does nothing" do
        expect(limited_text(short_text, 10)).to be == short_text
      end
    end
  end
end