module Berkshelf
  module Hobo
    module Action
      # @author Jamie Winsor <reset@riotgames.com>
      class SetUI
        def initialize(app, env)
          @app = app
        end

        def call(env)
          Berkshelf.ui = ::Hobo::UI::Colored.new('Berkshelf')
          @app.call(env)
        end
      end
    end
  end
end
