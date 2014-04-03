class Admin::DebugController < AuthorizedController
  def index
    @vars = ENV
  end
end
