module Where
  module Extractors
    attr_accessor :ignore

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

      locations = file_groups.sort_by { |fc| fc[:count] }.map { |fc| fc[:data] }
      process_ignores(locations)
    end

    def process_ignores(locations)
      [@ignore].flatten.compact.each do |ign|
        locations.reject! do |location|
          location[:file].match(ign)
        end
      end

      locations
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
