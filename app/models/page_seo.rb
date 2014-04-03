class PageSeo < ActiveRecord::Base
  def self.for(url)
    match = where(url: extract_url(url)).first
    match ||= where(url: "").first
    match
  end

  private

  def self.extract_url(url)
    url = url.split("?").first
    url = url.split("#").first
    url
  end
end
