require 'spec_helper'

describe PageSeo do
  describe ".for" do
    let!(:page_seo) { create(:page_seo, url: "/page") }
    let!(:gen_page_seo) { create(:page_seo, url: "") }

    context "with a simple, existing URL" do
      it "returns the SEO data for the page" do
        expect(PageSeo.for("/page")).to eql(page_seo)
      end
    end

    context "with a simple URL with querystrings" do
      it "returns the SEO data for the page" do
        expect(PageSeo.for("/page?query1=a")).to eql(page_seo)
      end
    end

    context "with a simple URL with an anchor" do
      it "returns the SEO data for the page" do
        expect(PageSeo.for("/page#anchor")).to eql(page_seo)
      end
    end

    context "with a non-existing URL" do
      it "returns the generic SEO data" do
        expect(PageSeo.for("/inexistent")).to eql(gen_page_seo)
      end
    end
  end
end
