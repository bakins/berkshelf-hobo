module Berkshelf
  module Hobo
    module Action
      # @author Jamie Winsor <reset@riotgames.com>
      # @author Andrew Garson <andrew.garson@gmail.com>
      class Install
        attr_reader :shelf
        attr_reader :berksfile

        def initialize(app, env)
          @app       = app
          @shelf     = Berkshelf::Hobo.shelf_for(env)
          @berksfile = Berksfile.from_file(env[:vm].config.berkshelf.berksfile_path)
        end

        def call(env)
          if Berkshelf::Hobo.chef_solo?(env[:vm].config)
            configure_cookbooks_path(env)
            install(env)
          end

          @app.call(env)
        rescue BerkshelfError => e
          raise HoboWrapperError.new(e)
        end

        private

          def install(env)
            Berkshelf.formatter.msg "installing cookbooks..."
            opts = {
              path: self.shelf
            }.merge(env[:vm].config.berkshelf.to_hash).symbolize_keys!
            berksfile.install(opts)
          end

          def configure_cookbooks_path(env)
            Berkshelf::Hobo.provisioners(:chef_solo, env[:vm].config).each do |provisioner|
              unless provisioner.config.cookbooks_path.is_a?(Array)
                provisioner.config.cookbooks_path = Array(provisioner.config.cookbooks_path)
              end

              provisioner.config.cookbooks_path.unshift(self.shelf)
            end
          end
      end
    end
  end
end
