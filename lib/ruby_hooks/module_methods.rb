module RubyHooks
  module ModuleMethods
  end
end

Module.send(:include, RubyHooks::ModuleMethods)