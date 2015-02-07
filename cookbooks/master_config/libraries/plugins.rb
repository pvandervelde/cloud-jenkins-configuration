module Master
  module Config
    module Plugins
      def plugins()
        hash = {
          ${JenkinsPlugins}
        }
        return hash
      end
    end
  end
end
