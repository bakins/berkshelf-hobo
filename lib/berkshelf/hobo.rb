require 'vagrant'
require 'berkshelf'
require 'berkshelf/hobo/errors'

module Berkshelf
  # @author Jamie Winsor <reset@riotgames.com>
  # @author Andrew Garson <andrew.garson@gmail.com>
  module Hobo
    module Action
      autoload :Install, 'berkshelf/hobo/action/install'
      autoload :Upload, 'berkshelf/hobo/action/upload'
      autoload :Clean, 'berkshelf/hobo/action/clean'
      autoload :SetUI, 'berkshelf/hobo/action/set_ui'
      autoload :Validate, 'berkshelf/hobo/action/validate'
    end

    autoload :Config, 'berkshelf/hobo/config'
    autoload :Middleware, 'berkshelf/hobo/middleware'

    class << self
      # @param [Hobo::Action::Environment] env
      #
      # @return [String, nil]
      def shelf_for(env)
        return nil if env[:vm].uuid.nil?

        File.join(Berkshelf.berkshelf_path, "hobo", env[:vm].uuid)
      end

      # @param [Symbol] shortcut
      # @param [Hobo::Config::Top] config
      #
      # @return [Array]
      def provisioners(shortcut, config)
        config.vm.provisioners.select { |prov| prov.shortcut == shortcut }
      end

      # Determine if the given instance of Hobo::Config::Top contains a
      # chef_solo provisioner
      #
      # @param [Hobo::Config::Top] config
      #
      # @return [Boolean]
      def chef_solo?(config)
        !provisioners(:chef_solo, config).empty?
      end

      # Determine if the given instance of Hobo::Config::Top contains a
      # chef_client provisioner
      #
      # @param [Hobo::Config::Top] config
      #
      # @return [Boolean]
      def chef_client?(config)
        !provisioners(:chef_client, config).empty?
      end

      # Initialize the Berkshelf Hobo middleware stack
      def init!
        ::Vagrant.config_keys.register(:berkshelf) { Berkshelf::Hobo::Config }

        [ :provision, :start ].each do |action|
          ::Vagrant.actions[action].insert(::Vagrant::Action::General::Validate, Berkshelf::Hobo::Action::Validate)
          ::Vagrant.actions[action].insert(::Vagrant::Action::VM::Provision, Berkshelf::Hobo::Middleware.install)
          ::Vagrant.actions[action].insert(::Vagrant::Action::VM::Provision, Berkshelf::Hobo::Middleware.upload)
        end

        ::Vagrant.actions[:destroy].insert(::Vagrant::Action::VM::ProvisionerCleanup, Berkshelf::Hobo::Middleware.clean)
      end
    end
  end
end

Berkshelf::Hobo.init!
