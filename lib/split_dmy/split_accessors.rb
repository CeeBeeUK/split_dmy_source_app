module SplitDmy
  module SplitAccessors
    def split_dmy_accessor(*attrs)
      require 'date_validator'

      attrs.each do |attr|
        after_initialize do
          full_date = send("#{attr}")
          unless full_date.nil?
            instance_variable_set("@#{attr}_day", full_date.day)
            instance_variable_set("@#{attr}_month", full_date.month)
            instance_variable_set("@#{attr}_year", full_date.year)
          end
        end

        validate "validate_#{attr}_partials".to_sym

        define_method("#{attr}=") do |val|
          super(val)
          unless val.nil?
            instance_variable_set("@#{attr}_day", Date.parse(val.to_s).day)
            instance_variable_set("@#{attr}_month", Date.parse(val.to_s).month)
            instance_variable_set("@#{attr}_year", Date.parse(val.to_s).year)
          end
        end

        define_method("#{attr}_day=") do |val|
          instance_variable_set("@#{attr}_day", val)
          new = DateValidator.new(self, attr).partial_updated
          send("#{attr}=", new)
        end

        define_method("#{attr}_month=") do |val|
          instance_variable_set("@#{attr}_month", val)
          new = DateValidator.new(self, attr).partial_updated
          send("#{attr}=", new)
        end

        define_method("#{attr}_year=") do |val|
          instance_variable_set("@#{attr}_year", val)
          new = DateValidator.new(self, attr).partial_updated
          send("#{attr}=", new)
        end

        ['day', 'month', 'year'].each do |part|
          define_method("#{attr}_#{part}") do
            instance_variable_get("@#{attr}_#{part}")
          end
        end

        define_method("validate_#{attr}_partials") do
          dv = DateValidator.new(self, attr)

          new_errs = []

          if dv.all_partials_empty?
            new_errs << "you need to provide a valid date"
          elsif dv.partials_valid? && !dv.build_date
            temp_date = [instance_variable_get("@#{attr}_day"),
                         instance_variable_get("@#{attr}_month"),
                         instance_variable_get("@#{attr}_year")].join('-')
            new_errs << "'#{temp_date}' is not a valid date"
          else
            field_errors = []
            ['day', 'month', 'year'].each do |part|
              err_msg = ''
              if instance_variable_get("@#{attr}_#{part}").to_s.empty?
                err_msg = 'must be completed'
                field_errors << "#{part} #{err_msg}"
              else
                unless DateValidator.new(self, attr).send("valid_#{part}?")
                  err_msg = "is not a valid #{part}"
                  field_errors << "'#{instance_variable_get("@#{attr}_#{part}")}' #{err_msg}"
                end
              end
              errors.add("#{attr}_#{part}".to_sym, err_msg) if err_msg.present?
            end

            new_errs << "#{field_errors.to_sentence(last_word_connector: ' and ')}" unless field_errors.empty?

          end

          unless new_errs.empty?
            errors.delete(attr.to_sym)
            errors.add(attr.to_sym, "is not valid, #{new_errs.to_sentence(last_word_connector: ' and ')}")
          end
        end
      end
    end
  end
end
