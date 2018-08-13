require 'httparty'

require 'candidatexyz/common/user_wrapper'

module CandidateXYZ
  module Concerns
    module Authenticatable
      extend ActiveSupport::Concern

      def authenticate
        begin
          auth_str = "?uid=#{request.headers['uid']}&client=#{request.headers['client']}&access-token=#{request.headers['access-token']}"
          if request.headers['uid'].nil? || request.headers['uid'].empty?
            auth_str = "?uid=#{params['uid']}&client=#{params['client']}&access-token=#{params['access-token']}"
          end

          response = HTTParty.get("#{Rails.application.secrets.auth_api}/auth/validate_token#{auth_str}")
          data = response.parsed_response

          @current_user = CandidateXYZ::Common::UserWrapper.new(data['data'])

          if @current_user.unauthorized?
            render :json => {}, :status => 401
          end
        rescue
          render :json => {}, :status => 401
        end
      end

      def authenticate_admin
        user = CandidateXYZ::Common::UserWrapper.new(@current_user) # just in case we get a user object

        if user.unauthorized? || !user.admin
          render :json => {}, :status => 401

          return
        end
      end

      def authenticate_superuser
        user = CandidateXYZ::Common::UserWrapper.new(@current_user)

        if user.unauthorized? || !user.superuser
          render :json => {}, :status => 401

          return
        end
      end

      def authenticate_campaign_id
        user = CandidateXYZ::Common::UserWrapper.new(@current_user)

        if user.unauthorized?
          render :json => {}, :status => 401

          return
        end

        @campaign_id = user.campaign_id
      end
    end
  end
end
