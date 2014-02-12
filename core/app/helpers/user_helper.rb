module UserHelper
  def nil_if_empty x
    x.blank? ? nil : x
  end
end
