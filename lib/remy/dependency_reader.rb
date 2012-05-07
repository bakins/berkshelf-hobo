module Remy
  module DependencyReader
    class << self
      def read cookbook
        @dependency_list = []
        Dir.chdir(cookbook.full_path) do
          # XXX this filename is required because it sets __FILE__, which is
          # used for README.md parsing among other things in metadata.rb files
          instance_eval(cookbook.metadata_file, cookbook.metadata_filename)
        end
        @dependency_list
      end
      
      def depends *args
        @dependency_list << Cookbook.new(*args)
      end

      def method_missing method, *args
        # Don't blow up when other metadata DSL methods are called, we
        # only care about #depends.
      end

      def name the_name
        # Module#name is defined, so method_missing won't catch it
        # when running instance_eval on a metadata.rb that overrides
        # the name
      end
    end
  end
end