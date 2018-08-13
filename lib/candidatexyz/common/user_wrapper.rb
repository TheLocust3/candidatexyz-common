module CandidateXYZ
  module Common
    class UserWrapper
        def initialize(user)
            @local_user = user
        end

        def unauthorized?
            if @local_user.is_a? Hash
                return @local_user.nil? || @local_user.empty?
            end

            return @local_user.nil?
        end

        def method_missing(m, *args, &block)
            if @local_user.is_a? Hash
                @local_user[m.to_s.camelize(:lower)]
            else
                @local_user.send(m)
            end
        end
    end
  end
end
