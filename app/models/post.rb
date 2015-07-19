class Post < ActiveRecord::Base
  Date::DATE_FORMATS[:gov_uk_long] = '%-d %B %Y'
  Date::DATE_FORMATS[:gov_uk_short] = '%-d %b %Y'

  validates :posted, presence: true
  validate :validate_partials

  validates :posted_day, presence: true
  validates :posted_month, presence: true
  validates :posted_year, presence: true

  after_find do |item|
    puts "----after_find found #{item.inspect}" unless item.nil?
  end

  after_initialize do |item|

    puts '=--=--=--='
    puts attr_has_presence_validation?(:posted)
    puts 'can I remove it?'
    _validators[:posted]
        .find { |v| v.is_a? ActiveRecord::Validations::PresenceValidator }
        .attributes
        .delete(:posted)
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

  def posted_govuk_long
    self.posted.to_s(:gov_uk_long) unless self.posted.nil?
  end

  def posted_govuk_short
    self.posted.to_s(:gov_uk_short) unless self.posted.nil?
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
    new_posted = partials_valid? && build_date ? build_date : nil
    puts "--- posted_update.new_posted=#{new_posted}"
    self.posted = new_posted
  end

  def partials_valid?
    begin
      { d: valid_day?, m: valid_month?, y: valid_year? }.values.all?
    rescue
      false
    end
  end

  def partials_empty?
    begin
      { d: @posted_day.empty?, m: @posted_month.empty?, y: @posted_year.empty? }.values.all?
    rescue
      false
    end
  end

  def build_date
    date = Date.new(@posted_year.to_i, @posted_month.to_i, @posted_day.to_i)
    unless date.day == @posted_day.to_i && date.month == @posted_month.to_i && date.year == @posted_year.to_i
      fail 'date does not match your inputted data'
    end
    date
  rescue
    false
  end

  def validate_partials
    new_errs = []

    if partials_empty?
      new_errs << "you need to provide a valid date."
    elsif !build_date
      new_errs << "'#{@posted_day}-#{@posted_month}-#{@posted_year}' is not a valid date"
    else
      new_errs << "'#{@posted_day}' is not a valid day" unless valid_day?
      new_errs << "'#{@posted_month}' is not a valid month" unless valid_month?
      new_errs << "'#{@posted_year}' is not a valid year" unless valid_year?
    end

    unless new_errs.empty?
      errors.delete(:posted)
      errors.delete(:posted_day)
      errors.delete(:posted_month)
      errors.delete(:posted_year)
      errors.add(:posted, "is not valid, #{new_errs.to_sentence(last_word_connector: ' and ')}")
    end
  end

  def valid_day?
    (valid_fixnum?(@posted_day, 31) || valid_numeric_string?(@posted_day, 31))
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
      result = mon_name.present? ? mon_name : val
    end
    result
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
