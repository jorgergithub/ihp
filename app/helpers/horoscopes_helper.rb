module HoroscopesHelper
  def select_if_first(index, prefix = nil)
    prefix = "#{prefix}_" if prefix
    
    if index == 0
      "#{prefix}selected" 
    else
      ""
    end
  end
end