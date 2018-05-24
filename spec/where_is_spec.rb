require 'spec_helper'

describe Where do
  it 'has a version number' do
    expect(Where::VERSION).not_to be nil
  end

  context 'with files' do
    context 'with a single reference' do
      let(:file_contents) { [file1] }

      describe '.is' do
        it "throws an error if method doesn't exist" do
          expect { Where.is(MyClass, :unknown_method) }
            .to raise_error(NameError, 'MyClass has no methods ' \
                                       'called unknown_method')
        end

        it 'resolves the class' do
          expect(Where.is(MyClass)).to eq(file1_def1_res)
        end

        it 'resolves the first method' do
          expect(Where.is(MyClass, :first_method)).to eq(file1_def1_res)
        end

        it 'resolves the second method' do
          expect(Where.is(MyClass, :second_method)).to eq(file1_def2_res)
        end
      end

      describe '.are' do
        it "throws an error if method doesn't exist" do
          expect { Where.are(MyClass, :unknown_method) }
            .to raise_error(NameError, 'MyClass has no methods ' \
                                       'called unknown_method')
        end

        it 'resolves the class' do
          expect(Where.are(MyClass)).to eq([file1_def1_res])
        end

        it 'resolves the first method' do
          expect(Where.are(MyClass, :first_method)).to eq([file1_def1_res])
        end

        it 'resolves the second method' do
          expect(Where.are(MyClass, :second_method)).to eq([file1_def2_res])
        end
      end
    end

    context 'with multiple references' do
      let(:file_contents) { [file1, file2, file3] }

      describe '.is' do
        it 'resolves the class' do
          expect(Where.is(MyClass)).to eq(file1_def1_res)
        end

        it 'resolves the first method' do
          expect(Where.is(MyClass, :first_method)).to eq(file1_def1_res)
        end

        it 'resolves the first method in the module' do
          expect(Where.is(MyModule, :first_method)).to eq(file2_def1_res)
        end

        it 'resolves the second method' do
          expect(Where.is(MyClass, :second_method)).to eq(file3_def1_res)
        end

        it 'resolves the third method' do
          expect(Where.is(MyClass, :third_method)).to eq(file2_def2_res)
        end

        it 'resolves the forth method' do
          expect(Where.is(MyClass, :forth_method)).to eq(file3_def2_res)
        end
      end

      describe '.are' do
        it 'resolves the class' do
          expect(Where.are(MyClass)).to eq([file1_def1_res, file3_def1_res])
        end

        it 'resolves the first method in the module' do
          expect(Where.are(MyModule, :first_method)).to eq([file2_def1_res])
        end

        it 'resolves the first method' do
          expect(Where.are(MyClass, :first_method))
            .to eq([file1_def1_res, file2_def1_res])
        end

        it 'resolves the second method' do
          expect(Where.are(MyClass, :second_method)).to eq([file3_def1_res])
        end

        it 'resolves the third method' do
          expect(Where.are(MyClass, :third_method)).to eq([file2_def2_res])
        end

        it 'resolves the forth method' do
          expect(Where.are(MyClass, :forth_method)).to eq([file3_def2_res])
        end
      end
    end

    context 'with method defined in C' do
      let(:file_contents) { [] }
      let(:split_location) do
        {
          file: 'String#split',
          line: nil,
          path: 'String#split'
        }
      end

      describe '.is' do
        it 'resolves String#split' do
          expect(Where.is(String, :split)).to eq(split_location)
        end
      end

      describe '.are' do
        it 'resolves String#split' do
          expect(Where.are(String, :split)).to eq([split_location])
        end
      end
    end

    around(:example) do |example|
      named_content = file_contents.each_with_index.map do |content, i|
        { content: content, name: "source-#{i}-" }
      end

      with_required_temp_files(named_content) do |file_paths|
        @file_paths = file_paths
        example.run
      end
    end

    let(:file1) do
      <<-RUBY
        class MyClass
          def first_method; end
          def self.second_method; end
        end
      RUBY
    end

    let(:file1_def1_res) do
      {
        file: @file_paths[0],
        line: 2,
        path: "#{@file_paths[0]}:2"
      }
    end

    let(:file1_def2_res) do
      {
        file: @file_paths[0],
        line: 3,
        path: "#{@file_paths[0]}:3"
      }
    end

    let(:file2) do
      <<-RUBY
        module MyModule
          def first_method; end

          def third_method; end
        end
      RUBY
    end

    let(:file2_def1_res) do
      {
        file: @file_paths[1],
        line: 2,
        path: "#{@file_paths[1]}:2"
      }
    end

    let(:file2_def2_res) do
      {
        file: @file_paths[1],
        line: 4,
        path: "#{@file_paths[1]}:4"
      }
    end

    let(:file3) do
      <<-RUBY
        class MyClass
          include MyModule
          def self.second_method; end
          def forth_method; end
        end
      RUBY
    end

    let(:file3_def1_res) do
      {
        file: @file_paths[2],
        line: 3,
        path: "#{@file_paths[2]}:3"
      }
    end

    let(:file3_def2_res) do
      {
        file: @file_paths[2],
        line: 4,
        path: "#{@file_paths[2]}:4"
      }
    end
  end
end
