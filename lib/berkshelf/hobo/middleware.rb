module Berkshelf
  module Hobo
    # @author Jamie Winsor <reset@riotgames.com>
    #
    # Middleware stacks for use with Hobo
    module Middleware
      class << self
        # Return the Berkshelf install middleware stack. When placed in the action chain
        # this stack will find retrieve and resolve the cookbook dependencies describe
        # in your configured Berksfile.
        #
        # Cookbooks will installed into a temporary directory, called a Shelf, and mounted
        # into the VM. This mounted path will be appended to the chef_solo.cookbooks_path value.
        #
        # @return [::Hobo::Action::Builder]
        def install
          @install ||= ::Vagrant::Action::Builder.new do
            use Berkshelf::Hobo::Action::SetUI
            use Berkshelf::Hobo::Action::Install
          end
        end

        # Return the Berkshelf upload middleware stack. When placed in the action chain
        # this stack will upload cookbooks to a Chef Server if the Chef-Client provisioner
        # is used. The Chef Server where the cookbooks will be uploaded to is the same Chef
        # Server used in the Chef-Client provisioner.
        #
        # Nothing will be done if the Chef-Solo provisioner is used.
        #
        # @return [::Hobo::Action::Builder]
        def upload
          @upload ||= ::Vagrant::Action::Builder.new do
            use Berkshelf::Hobo::Action::SetUI
            use Berkshelf::Hobo::Action::Upload
          end
        end

        # Return the Berkshelf clean middleware stack. When placed in the action chain
        # this stack will clean up any temporary directories or files created by the other
        # middleware stacks.
        #
        # @return [::Hobo::Action::Builder]
        def clean
          @clean ||= ::Vagrant::Action::Builder.new do
            use Berkshelf::Hobo::Action::SetUI
            use Berkshelf::Hobo::Action::Clean
          end
        end
      end
    end
  end
end
