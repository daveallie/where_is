require "where_is/version"

module Where
  class <<self
    def is(klass, method = nil)
      if method
        begin
          Where.is_instance_method(klass, method)
        rescue NameError
          Where.is_method(klass, method)
        end
      else
        Where.is_class_primarily(klass)
      end
    end

    def is_proc(proc)
      source_location(proc)
    end

    def is_method(klass, method_name)
      source_location(klass.method(method_name))
    end

    def is_instance_method(klass, method_name)
      source_location(klass.instance_method(method_name))
    end

    def are_methods(klass, method_name)
      source_locations = are_via_extractor(:method, klass, method_name)

      if source_locations.empty?
        raise NameError, "#{klass} has no methods called #{method_name}"
      else
        source_locations
      end
    end

    def are_instance_methods(klass, method_name)
      source_locations = are_via_extractor(:instance_method, klass, method_name)

      if source_locations.empty?
        raise NameError, "#{klass} has no methods called #{method_name}"
      else
        source_locations
      end
    end

    def is_class(klass)
      methods = defined_methods(klass)
      file_groups = methods.group_by{|sl| sl[0]}
      file_counts = file_groups.map do |file, sls|
        lines = sls.map{|sl| sl[1]}
        count = lines.size
        line = lines.min
        {file: file, count: count, line: line}
      end
      file_counts.sort_by{|fc| fc[:count]}.map{|fc| [fc[:file], fc[:line]]}
    end

    # Raises ArgumentError if klass does not have any Ruby methods defined in it.
    def is_class_primarily(klass)
      source_locations = is_class(klass)
      if source_locations.empty?
        methods = defined_methods(klass)
        raise ArgumentError, (methods.empty? ?
            "#{klass} has no methods" :
            "#{klass} only has built-in methods (#{methods.size} in total)"
        )
      end
      source_locations[0]
    end

    private

    def source_location(method)
      method.source_location || (
      method.to_s =~ /: (.*)>/
      $1
      )
    end

    def are_via_extractor(extractor, klass, method_name)
      klass.ancestors.map do |ancestor|
        source_location(ancestor.send(extractor, method_name)) rescue nil
      end.compact
    end

    def defined_methods(klass)
      methods = klass.methods(false).map{|m| klass.method(m)} +
          klass.instance_methods(false).map{|m| klass.instance_method(m)}
      methods.map(&:source_location).compact
    end
  end
end
