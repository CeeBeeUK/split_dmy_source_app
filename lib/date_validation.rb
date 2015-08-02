module DateValidation
  def partials_valid?
    begin
      {d : valid_day?, m : valid_month?, y : valid_year?}.values.all?
    rescue
      false
    end
  end

  def all_partials_empty?
    begin
      { d: @posted_day.empty?, m: @posted_month.empty?, y: @posted_year.empty? }.values.all?
    rescue
      false
    end
  end

  def some_partials_empty?
    { d: @posted_day.blank?, m: @posted_month.blank?, y: @posted_year.blank? }.values.count > 0
  end
end
