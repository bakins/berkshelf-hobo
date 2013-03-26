require 'vagrant/errors'

module Berkshelf
  # A wrapper for a BerkshelfError for Hobo. All Berkshelf exceptions should be
  # wrapped in this proxy object so they are properly handled when Hobo encounters
  # an exception.
  #
  # @example wrapping an error encountered within the Hobo plugin
  #   rescue BerkshelfError => e
  #     HoboWrapperError.new(e)
  #   end
  class HoboWrapperError < Vagrant::Errors::VagrantError
    # @param [BerkshelfError]
    attr_reader :original

    # @param [BerkshelfError] original
    def initialize(original)
      @original = original
    end

    def to_s
      "#{original.class}: #{original.to_s}"
    end

    private

      def method_missing(fun, *args, &block)
        original.send(fun, *args, &block)
      end
  end
end
