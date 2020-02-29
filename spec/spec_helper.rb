# frozen_string_literal: true

require 'where_is'
require 'tempfile'

def with_temp_file(contents)
  contents = { name: 'source', content: contents } if contents.is_a?(String)
  file = Tempfile.new([contents[:name], '.rb'])
  begin
    file.write(contents[:content])
    file.close
    yield file.path
  ensure
    file.unlink
  end
end

def with_required_temp_files(file_contents, paths = [], &block)
  return yield paths if file_contents.empty?

  next_contents, *rest = Array(file_contents)
  with_temp_file(next_contents) do |file_path|
    require_relative file_path
    with_required_temp_files rest, paths + [file_path], &block
  end
end
