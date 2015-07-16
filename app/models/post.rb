class Post < ActiveRecord::Base
  Date::DATE_FORMATS[:gov_uk] = '%-d %B %Y'

  validates :posted, presence: true
  # validate :validate_day
  validate:validate_month
  validate :validate_year
  validates :posted_day, presence: true
  validates :posted_month, presence: true
  validates :posted_year, presence: true

  after_find do |item|
    puts "----after_find found #{item.inspect}" unless item.nil?
  end

  after_initialize do |item|

    puts '=--=--=--='
    puts attr_has_presence_validation?(:posted)
    puts '=--=--=--='

    puts "----after_initialize found #{item.inspect}" unless item.nil?
    unless item.posted.nil?
      @posted_day = posted.day
      @posted_month = posted.month
      @posted_year = posted.year
    end
  end

  def attr_has_presence_validation?(attr)
    self.class.validators.collect do |validation|
      validation if validation.class==ActiveRecord::Validations::PresenceValidator
    end.compact.collect(&:attributes).flatten.include? attr
  end

  def posted_govuk
    self.posted.to_s(:gov_uk) unless self.posted.nil?
  end

  def posted_day=(val)
    puts "--- setting posted_day=#{val}"
    @posted_day = val
    posted_update
  end

  def posted_day
    puts "--- reading @posted_day and getting #{@posted_day}"
    @posted_day
  end

  def posted_month=(val)
    puts "--- setting posted_month=#{val}"
    @posted_month = parse_month(val)
    posted_update
  end

  def posted_month
    puts "--- reading @posted_month and getting #{@posted_month}"
    @posted_month
  end

  def posted_year=(val)
    puts "--- setting posted_year=#{val}"
    @posted_year = val
    posted_update
  end

  def posted_year
    puts "--- reading @posted_year and getting #{@posted_year}"
    @posted_year
  end

  def posted_update
    new_posted = partials_valid? ? build_date : nil
    puts "--- posted_update.new_posted=#{new_posted}"
    self.posted = new_posted
  end

  def partials_valid?
    begin
      checks = {
          d: valid_day?,
          m: valid_month?,
          y: valid_year?
      }
      checks.values.all?
    rescue
      false
    end
  end

  def build_date
    Date.new(@posted_year.to_i, @posted_month.to_i, @posted_day.to_i)
  end

  def validate_day
    unless valid_day?
      errors.delete(:posted)
      errors.add(:posted_day, "'#{@posted_day}' is not valid")
    end
  end

  def valid_day?
    (valid_fixnum?(@posted_day, 31) || valid_numeric_string?(@posted_day, 31))
  end

  def validate_month
    unless valid_month?
      errors.delete(:posted)
      errors.add(:posted_month, "'#{@posted_month}' is not valid")
    end
  end

  def valid_month?
    (
      valid_fixnum?(@posted_month, 12) ||
      valid_numeric_string?(@posted_month, 12) ||
      valid_month_name?(@posted_month)
    )
  end

  def parse_month(val)
    if valid_fixnum?(val, 12) || valid_numeric_string?(val, 12)
      result = val.to_i
    else
      mon_name = valid_month_name?(val)
      if mon_name.present?
        result = mon_name
      else
        result = val
      end
    end
    result
  end

  def validate_year
    unless valid_year?
      errors.delete(:posted)
      errors.add(:posted_year, "'#{@posted_year}' is not valid")
    end
  end

  def valid_year?
    (valid_fixnum?(@posted_year, 3333) || valid_numeric_string_year?(@posted_year))
  end

  def valid_fixnum?(x, max)
    x.is_a?(Fixnum) && x > 0 && x <= max
  end

  def valid_numeric_string?(x, max)
    x =~ /^[0-9]{1,2}$/ && x.to_i <= max
  end

  def valid_numeric_string_year?(x)
    x =~ /^[0-9]{4}$/ && x.to_i <= 3333 && x.to_i > 0000
  end

  def convert_year(year)
    Date.parse("31-dec-#{y}").year
  end

  def valid_month_name?(month)
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
