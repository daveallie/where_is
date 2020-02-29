# frozen_string_literal: true

require 'where_is/extractors'
require 'where_is/version'

module Where
  class << self
    include Where::Extractors

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

    def is_class_primarily(klass)
      is_class(klass)[0]
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
  end
end
