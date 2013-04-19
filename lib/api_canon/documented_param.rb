module ApiCanon
  class DocumentedParam
    attr_accessor :name, :values, :type, :default, :description, :example_values
    attr_writer :multiple
    def values_for_example
      example_values || values || ""
    end
    def multiple?
      !!@multiple
    end
    def initialize(name, opts={})
      @name = name
      opts.each {|k,v| self.send("#{k}=", v) }
    end
    def form_values
      values.presence || example_values.presence
    end
    def to_field(f, doco_prefix)
      # TODO: This doco_prefix thing sucks. Get rid of it.
      if type == :array
        f.select name, form_values, {:selected => default, :include_blank => true}, {:multiple => multiple?, :class => 'input-block-level', :id => "#{doco_prefix}_#{name}"}
      elsif type == :boolean
        f.select name, [true,false], {:selected => default, :include_blank => true}, :class => 'input-block-level', :id => "#{doco_prefix}_#{name}"
      else
        f.text_field name, :value => default, :class => 'input-block-level', :id => "#{doco_prefix}_#{name}"
      end
    end
    def example_values_field(f, doco_prefix)
      if values_for_example.is_a?(Array)
        if type != :array
          f.select :example_value, values_for_example, {:selected => default, :include_blank => true}, :class => 'input-block-level',
            :onchange => "jQuery('##{doco_prefix}_#{name}').val(this.value)", :id => "#{doco_prefix}_#{name}_example"
        end
      else
        values_for_example
      end
    end
  end
end