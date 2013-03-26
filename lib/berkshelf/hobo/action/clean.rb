module Berkshelf
  module Hobo
    module Action
      # @author Jamie Winsor <reset@riotgames.com>
      class Clean
        attr_reader :shelf

        def initialize(app, env)
          @app = app
          @shelf = Berkshelf::Hobo.shelf_for(env)
        end

        def call(env)
          if Berkshelf::Hobo.chef_solo?(env[:vm].config) && self.shelf
            Berkshelf.formatter.msg "cleaning Hobo's shelf"
            FileUtils.remove_dir(self.shelf, fore: true)
          end

          @app.call(env)
        rescue BerkshelfError => e
          raise HoboWrapperError.new(e)
        end
      end
    end
  end
end
