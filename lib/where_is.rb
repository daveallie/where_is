require 'where_is/version'

module Where
  class << self
    def is(klass, method = nil)
      are(klass, method)[0]
    end

    def are(klass, method = nil)
      if method
        begin
          Where.are_instance_methods(klass, method)
        rescue NameError
          Where.are_methods(klass, method)
        end
      else
        Where.is_class(klass)
      end
    end

    def is_proc(proc)
      source_location(proc)
    end

    def is_method(klass, method_name)
      are_methods(klass, method_name)[0]
    end

    def is_instance_method(klass, method_name)
      are_instance_methods(klass, method_name)[0]
    end

    def are_methods(klass, method_name)
      ensured_class = ensure_class(klass)
      methods = are_via_extractor(:method, ensured_class, method_name)
      source_locations = group_and_combine_source_locations(methods)

      if source_locations.empty?
        raise NameError, "#{ensured_class} has no methods called #{method_name}"
      end

      source_locations
    end

    def are_instance_methods(klass, method_name)
      ensured_class = ensure_class(klass)
      methods = are_via_extractor(:instance_method, ensured_class, method_name)
      source_locations = group_and_combine_source_locations(methods)

      if source_locations.empty?
        raise NameError, "#{ensured_class} has no methods called #{method_name}"
      end

      source_locations
    end

    def is_class_primarily(klass)
      is_class(klass)[0]
    end

    def is_class(klass)
      ensured_class = ensure_class(klass)
      methods = defined_methods(ensured_class)
      source_locations = group_and_combine_source_locations(methods)

      if source_locations.empty?
        raise NameError, "#{ensured_class} has no methods" if methods.empty?
        raise NameError, "#{ensured_class} only has built-in methods " \
                             "(#{methods.size} in total)"
      end

      source_locations
    end

    private

    def ensure_class(klass)
      [Class, Module].include?(klass.class) ? klass : klass.class
    end

    def source_location(method)
      source_location = method.source_location
      source_location = [method.to_s[/: (.*)>/, 1]] if source_location.nil?

      # source_location is a 2 element array
      # [filename, line_number]
      # some terminals (eg. iterm) will jump to the file if you cmd+click it
      # but they can jump to the specific line if you concat file & line number
      filename, line = source_location
      build_location_hash(filename, line)
    end

    def group_and_combine_source_locations(source_locations)
      file_groups = source_locations.group_by { |src_loc| src_loc[:file] }.to_a

      file_groups.map! do |file, src_locs|
        lines = src_locs.map { |sl| sl[:line] }
        count = lines.size
        line = lines.min
        { count: count, data: build_location_hash(file, line) }
      end

      file_groups.sort_by { |fc| fc[:count] }.map { |fc| fc[:data] }
    end

    def are_via_extractor(extractor, klass, method_name)
      klass.ancestors.map do |ancestor|
        begin
          source_location(ancestor.send(extractor, method_name))
        rescue NameError
          nil
        end
      end.compact
    end

    def defined_methods(klass)
      methods = klass.methods(false).map { |m| klass.method(m) }
      methods += klass.instance_methods(false)
                      .map { |m| klass.instance_method(m) }
      source_locations = methods.map(&:source_location).compact
      source_locations.map { |(file, line)| build_location_hash(file, line) }
    end

    def build_location_hash(file, line)
      { file: file, line: line, path: [file, line].compact.join(':') }
    end
  end
end
