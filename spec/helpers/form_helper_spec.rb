require "spec_helper"

describe FormHelper do
  describe "#text_field" do
    let(:form) { double(:form) }
    it "returns the HTML" do
      form.stub(label: "<label>", text_field: "<textfield>")
      expected = "<div class=\"control-group\"><label><div class=\"controls\"><textfield></div></div>"
      actual = helper.add_text_field(form, :email, "Email", option: "one")

      expect(actual).to eql(expected)
    end
  end
end
