module CandidateXYZ
  module Common
    class UserWrapper
        def initialize(user)
            @local_user = user
        end

        def method_missing(m, *args, &block)
            if @local_user.is_a? Hash
                @local_user[m.camelize(:lower)]
            else
                @local_user.send(m)
            end
        end
    end
  end
end
