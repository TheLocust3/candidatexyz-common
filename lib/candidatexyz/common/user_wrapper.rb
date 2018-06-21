module CandidateXYZ
  module Common
    class UserWrapper
        def initialize(user)
            @local_user = user
        end

        def run(method)
            if @local_user.is_a? Hash
                @local_user[method.camelize(:lower)]
            else
                @local_user.send(method)
            end
        end
    end
  end
end
