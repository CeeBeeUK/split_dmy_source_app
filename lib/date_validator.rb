class DateValidator
  def self.date_changed(object, attribute)
    posted_day = object.instance_variable_get("@#{attribute}_day")
    @split_month = object.instance_variable_get("@#{attribute}_month")
    @split_year = object.instance_variable_get("@#{attribute}_year")

    self.partials_valid? && self.build_date ? self.build_date : nil
  end

  private

  def self.partials_valid?
    begin
      { d: valid_day?, m: valid_month?, y: valid_year? }.values.all?
    rescue
      false
    end
  end

  def self.build_date
    date = Date.new(@split_year.to_i, @split_month.to_i, posted_day.to_i)
    date if date.day == posted_day.to_i && date.month == @split_month.to_i && date.year == @split_year.to_i
  rescue
    false
  end

  def self.valid_day?
    (valid_fixnum?(posted_day, 31) || valid_numeric_string?(posted_day, 31))
  end

  def self.valid_month?
    (
      valid_fixnum?(@split_month, 12) ||
      valid_numeric_string?(@split_month, 12) ||
      valid_month_name?(@split_month)
    )
  end

  def self.parse_month(val)
    if valid_fixnum?(val, 12) || valid_numeric_string?(val, 12)
      result = val.to_i
    else
      mon_name = valid_month_name?(val)
      result = mon_name.present? ? mon_name : val
    end
    result
  end

  def self.valid_year?
    puts 'valid_year?'
    puts "valid_fixnum?(#{@split_year},3333)= #{valid_fixnum?(@split_year, 3333)}"
    puts "valid_numeric_string_year?(#{@split_year})=#{valid_numeric_string_year?(@split_year)}"
    (valid_fixnum?(@split_year, 3333) || valid_numeric_string_year?(@split_year))
  end

  def self.valid_fixnum?(x, max)
    x.is_a?(Fixnum) && x > 0 && x <= max
  end

  def self.valid_numeric_string?(x, max)
    x =~ /^[0-9]{1,2}$/ && x.to_i <= max
  end

  def self.valid_numeric_string_year?(x)
    x =~ /^[0-9]{4}$/ && x.to_i <= 3333 && x.to_i > 0000
  end

  def self.convert_year(year)
    Date.parse("31-dec-#{y}").year
  end

  def self.valid_month_name?(month)
    short_months = I18n.t('date.abbr_month_names')
    full_months  = I18n.t('date.month_names')
    if short_months.include?(month.to_s.capitalize)
      short_months.index(month.capitalize)
    elsif full_months.include?(month.to_s.capitalize)
      full_months.index(month.capitalize)
    else
      nil
    end
  end

end