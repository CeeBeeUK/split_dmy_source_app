module SplitDmy
  module SplitAccessors
    def split_dmy_accessor(*attrs)
      require 'date_validator'
      attrs.each do |attr|
        ['day', 'month', 'year'].each do |part|
          define_method("#{attr}_#{part}=") do |val|
            instance_variable_set("@#{attr}_#{part}", val)
            partial_update attr
          end

          define_method("#{attr}_#{part}") do
            instance_variable_get("@#{attr}_#{part}")
          end
        end
        define_method("partial_update") do |attr|
          send("#{attr}=", DateValidator.date_changed(self, attr))
        end
      end
    end
  end
end
