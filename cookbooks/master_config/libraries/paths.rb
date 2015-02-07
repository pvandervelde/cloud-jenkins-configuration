module Master
  module Config
    module Paths
      # Define the CI directory that contains the jenkins installation
      def ci_directory()
        '${DirJenkinsInstall}'
      end
    end
  end
end
