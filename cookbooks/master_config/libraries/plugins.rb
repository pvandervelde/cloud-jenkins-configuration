module Master
  module Config
    module Plugins
      def plugins
        hash = {
          ${JenkinsPlugins}
        }
        hash
      end
    end
  end
end
