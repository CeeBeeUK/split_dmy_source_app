module SplitDmy
  module SplitAccessors
    def split_dmy_accessor(*attrs)
      require 'date_validator'

      attrs.each do |attr|
        validate "validate_#{attr}_partials".to_sym

        override_builtin(attr)
        add_attr_accessors(attr)
        extend_validation(attr)
      end
      add_methods
    end

    private

    def extend_validation(attr)
      define_method("validate_#{attr}_partials") do
        dv = DateValidator.new(self, attr)
        new_errs, field_errors = [], []
        new_errs << 'you need to provide a valid date' if dv.all_partials_empty?
        new_errs << dv.combine_partials_error if dv.partials_valid_date_fails?

        %w[day month year].each do |part|
          error = dv.get_partial_error(part)
          if error.present?
            field_errors << error
            errors.add("#{attr}_#{part}".to_sym, error)
          end
        end
        new_errs << make_sentence_of(field_errors) unless field_errors.empty?
        unless new_errs.empty?
          errors.delete(attr.to_sym)
          errors.add(attr.to_sym, "is not valid, #{make_sentence_of(new_errs)}")
        end
      end
    end

    def override_builtin(attr)
      after_initialize do
        full_date = send("#{attr}")
        split_into_parts(attr, full_date) unless full_date.nil?
      end

      define_method("#{attr}=") do |val|
        super(val)
        split_into_parts(attr, Date.parse(val.to_s)) unless val.nil?
      end
    end

    def add_methods
      define_method('split_into_parts') do |attr, full_date|
        instance_variable_set("@#{attr}_day", full_date.day)
        instance_variable_set("@#{attr}_month", full_date.month)
        instance_variable_set("@#{attr}_year", full_date.year)
      end

      define_method('make_sentence_of') do |errors|
        errors.to_sentence(last_word_connector: ' and ')
      end
    end

    def add_attr_accessors(attr)
      %w[day month year].each do |part|
        define_method("#{attr}_#{part}=") do |val|
          instance_variable_set("@#{attr}_#{part}", val)
          new = DateValidator.new(self, attr).partial_updated
          send("#{attr}=", new)
        end

        define_method("#{attr}_#{part}") do
          instance_variable_get("@#{attr}_#{part}")
        end
      end
    end
  end
end
