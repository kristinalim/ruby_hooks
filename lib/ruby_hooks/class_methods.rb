class Class
  cattr_accessor :__rh_current_method_name

  def uses_hooks
    cattr_accessor :__rh_hooks

    self.__rh_current_method_name = nil
    self.__rh_hooks = {}
  end

  def append_to_after_callbacks(callback_method_name, method_name, options = {})
    prepared = __rh_prepare_method_requirements(method_name)
    self.__rh_hooks[method_name.to_sym][:after].push([callback_method_name])
    self.__rh_current_method_name = method_name

    __rh_setup_method(method_name) unless prepared
  end

  def append_to_before_callbacks(callback_method_name, method_name, options = {})
    prepared = __rh_prepare_method_requirements(method_name)
    self.__rh_hooks[method_name.to_sym][:before].push([callback_method_name])
    self.__rh_current_method_name = method_name

    __rh_setup_method(method_name) unless prepared
  end

  def __rh_setup_method(method_name)
    puts "self: #{self} #{self.__rh_current_method_name}"
    class << self
      define_method "#{self.__rh_temporary_method_name(self.__rh_current_method_name)}" do |*args|
        method_name = self.__rh_current_method_name

        self.__rh_before_callbacks(method_name, *args)
        result = self.send(__rh_original_method_name(method_name), *args)
        self.__rh_after_callbacks(method_name, *args)

        return result
      end

      alias_method __rh_original_method_name(self.__rh_current_method_name), self.__rh_current_method_name
      alias_method self.__rh_current_method_name, __rh_temporary_method_name(self.__rh_current_method_name)
    end
  end

  def __rh_prepare_method_requirements(method)
    unless self.__rh_hooks[method.to_sym]
      self.__rh_hooks[method.to_sym] = {:before => [], :after => []}
      return false
    end

    return true
  end

  def __rh_original_method_name(method)
    '__rh_original_' + method.to_s
  end

  def __rh_temporary_method_name(method)
    '__rh_temporary_' + method.to_s
  end

  def __rh_before_callbacks(method, *args)
    self.__rh_hooks[method.to_sym][:before].each do |m, *a|
      send(m, *args)
    end if self.__rh_hooks[method.to_sym]
  end

  def __rh_after_callbacks(method, *args)
    self.__rh_hooks[method.to_sym][:after].each do |m, *a|
      send(m, *args)
    end if self.__rh_hooks[method.to_sym]
  end
end