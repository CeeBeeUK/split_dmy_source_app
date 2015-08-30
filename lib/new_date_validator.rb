class NewDateValidator
  def initialize(object, attribute)
    @posted_day = object.instance_variable_get("@#{attribute}_day")
    @split_month = object.instance_variable_get("@#{attribute}_month")
    @split_year = object.instance_variable_get("@#{attribute}_year")
  end

  private

  def valid_fixnum?(x, max)
    x.is_a?(Fixnum) && x > 0 && x <= max
  end

  def valid_numeric_string?(x, max)
    x =~ /^[0-9]{1,2}$/ && x.to_i <= max
  end

  def valid_numeric_string_year?(x)
    x =~ /^[0-9]{4}$/ && x.to_i <= 3333 && x.to_i > 0000
  end
end
