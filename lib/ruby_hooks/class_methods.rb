class Class
  cattr_accessor :__rh_current_method_name

  def uses_hooks
    cattr_accessor :__rh_hooks

    self.__rh_current_method_name = nil
    self.__rh_hooks = {:class => {}, :instance => {}, :module => {}}
  end

  def prepend_to_after_callbacks(callback_method_name, method_name, options = {})
    method_type = options[:type] || :class

    prepared = __rh_prepare_method_requirements(method_name, options)
    self.__rh_hooks[method_type][method_name.to_sym][:after].unshift([callback_method_name])
    self.__rh_current_method_name = method_name

    __rh_setup_method(method_name, options) unless prepared
  end

  def prepend_to_before_callbacks(callback_method_name, method_name, options = {})
    method_type = options[:type] || :class

    prepared = __rh_prepare_method_requirements(method_name, options)
    self.__rh_hooks[method_type][method_name.to_sym][:before].unshift([callback_method_name])
    self.__rh_current_method_name = method_name

    __rh_setup_method(method_name, options) unless prepared
  end

  def append_to_after_callbacks(callback_method_name, method_name, options = {})
    method_type = options[:type] || :class

    prepared = __rh_prepare_method_requirements(method_name, options)
    self.__rh_hooks[method_type][method_name.to_sym][:after].push([callback_method_name])
    self.__rh_current_method_name = method_name

    __rh_setup_method(method_name, options) unless prepared
  end

  def append_to_before_callbacks(callback_method_name, method_name, options = {})
    method_type = options[:type] || :class

    prepared = __rh_prepare_method_requirements(method_name, options)
    self.__rh_hooks[method_type][method_name.to_sym][:before].push([callback_method_name])
    self.__rh_current_method_name = method_name

    __rh_setup_method(method_name, options) unless prepared
  end

  def __rh_setup_method(method_name, options = {})
    method_type = options[:type] || :class

    if method_type == :class
      class << self
        define_method "#{self.__rh_temporary_method_name(self.__rh_current_method_name)}" do |*args|
          method_name = self.__rh_current_method_name

          self.__rh_before_callbacks(method_name, {:type => :class}, *args)
          result = self.send(__rh_original_method_name(method_name), *args)
          self.__rh_after_callbacks(method_name, {:type => :class}, *args)

          return result
        end

        alias_method __rh_original_method_name(self.__rh_current_method_name), self.__rh_current_method_name
        alias_method self.__rh_current_method_name, __rh_temporary_method_name(self.__rh_current_method_name)
      end
    elsif method_type == :instance
      instance_eval do
        define_method "#{self.__rh_temporary_method_name(self.__rh_current_method_name)}" do |*args|
          method_name = self.class.__rh_current_method_name

          self.class.__rh_before_callbacks(method_name, {:type => :instance, :caller => self}, *args)
          result = self.send(self.class.__rh_original_method_name(method_name), *args)
          self.class.__rh_after_callbacks(method_name, {:type => :instance, :caller => self}, *args)

          return result
        end

        alias_method __rh_original_method_name(self.__rh_current_method_name), self.__rh_current_method_name
        alias_method self.__rh_current_method_name, __rh_temporary_method_name(self.__rh_current_method_name)
      end
    end
  end

  def __rh_prepare_method_requirements(method, options = {})
    method_type = options[:type] || :class

    unless self.__rh_hooks[method_type][method.to_sym]
      self.__rh_hooks[method_type][method.to_sym] = {:before => [], :after => []}
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

  def __rh_before_callbacks(method, options = {}, *args)
    method_type = options[:type] || :class

    if method_type == :class
      self.__rh_hooks[method_type][method.to_sym][:before].each do |m, *a|
        send(m, *args)
      end if self.__rh_hooks[method_type][method.to_sym]
    elsif method_type == :instance
      self.__rh_hooks[method_type][method.to_sym][:before].each do |m, *a|
        options[:caller].send(m, *args)
      end if self.__rh_hooks[method_type][method.to_sym]
    end
  end

  def __rh_after_callbacks(method, options = {}, *args)
    method_type = options[:type] || :class

    if method_type == :class
      self.__rh_hooks[method_type][method.to_sym][:after].each do |m, *a|
        send(m, *args)
      end if self.__rh_hooks[method_type][method.to_sym]
    elsif method_type == :instance
      self.__rh_hooks[method_type][method.to_sym][:after].each do |m, *a|
        options[:caller].send(m, *args)
      end if self.__rh_hooks[method_type][method.to_sym]
    end
  end
end