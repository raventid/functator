def define_method_taking_block(name, &method_body_proc)
  self.class.send :define_method, "__cardinal_helper_#{name}__", &method_body_proc
  eval <<-EOM
    def #{name}(a_value, &a_proc)
      __cardinal_helper_#{name}__(a_value, a_proc)
    end
  EOM
end

def cardinal_define(name, &proc_over_proc)
  define_method_taking_block(name) do |a_value, a_proc|
    proc_over_proc.call(a_proc).call(a_value)
    # Elixir style pipe operator, why not create this tiny op for Ruby
    # object.call() looks really OPish, but so ugly :((
    # proc_over_proc
    # <| a_proc
    # <| a_value
  end
end

# Example of cardinal implementation and usage.

# cardinal_define(:maybe) do |a_proc|
#   -> (a_value) { a_proc.call(a_value) unless a_value.nil? }
# end
