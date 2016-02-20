def quirky_bird_define(name, &value_proc)
  define_method_taking_block(name) do |a_value, a_proc|
    a_proc.call(value_proc.call(a_value))
  end
end

# method_body_proc should expect (a_value, a_proc)
# see http://coderrr.wordpress.com/2008/10/29/using-define_method-with-blocks-in-\

# ruby-18/
def define_method_taking_block(name, &method_body_proc)
  self.class.send :define_method, "__quirky_bird_helper_#{name}__", &method_body_proc

  eval <<-EOM
    def #{name}(a_value, &a_proc)
      __quirky_bird_helper_#{name}__(a_value, a_proc)
    end
  EOM
  
  puts <<-METHOD
    def #{name}(a_value, &a_proc)
      #{method_body_proc.source}
      __quirky_bird_helper_#{name}__(a_value, a_proc)
    end


  METHOD
end

# Example of using quirky

quirky_bird_define(:square_first) do |a_value|
  a_value * a_value
end

quirky_bird_define(:maybe) do |value|
  if value.nil?
    BasicObject.tap do |it|
      def it.method_missing(*args)
        nil
      end
    end
  else
    value
  end
end

