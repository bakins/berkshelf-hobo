module Berkshelf
  module Hobo
    module Action
      # @author Jamie Winsor <reset@riotgames.com>
      class Upload
        attr_reader :berksfile

        def initialize(app, env)
          @app       = app
          @berksfile = Berksfile.from_file(env[:vm].config.berkshelf.berksfile_path)
        end

        def call(env)
          if Berkshelf::Hobo.chef_client?(env[:vm].config)
            upload(env)
          end

          @app.call(env)
        rescue BerkshelfError => e
          raise HoboWrapperError.new(e)
        end

        private

          def upload(env)
            Berkshelf::Hobo.provisioners(:chef_client, env[:vm].config).each do |provisioner|
              Berkshelf.formatter.msg "uploading cookbooks to '#{provisioner.config.chef_server_url}'"
              berksfile.upload(
                server_url: provisioner.config.chef_server_url,
                client_name: Berkshelf::Config.instance.chef.node_name,
                client_key: Berkshelf::Config.instance.chef.client_key,
                ssl: {
                  verify: Berkshelf::Config.instance.ssl.verify
                }
              )
            end
          end
      end
    end
  end
end
