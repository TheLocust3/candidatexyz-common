require 'httparty'

require 'candidatexyz/common/user_wrapper'

module CandidateXYZ
  module Concerns
    module Authenticatable
      extend ActiveSupport::Concern

      def authenticate
        begin
          response = HTTParty.get("#{Rails.application.secrets.auth_api}/auth/validate_token?uid=#{request.headers['uid']}&client=#{request.headers['client']}&access-token=#{request.headers['access-token']}")
          data = response.parsed_response

          @current_user = data['data']

          if @current_user.nil?
            render :json => {}, :status => 401
          end
        rescue
          render :json => {}, :status => 401
        end
      end

      def authenticate_superuser
        user = UserWrapper.new(@current_user)

        if @current_user.nil? || !user.run('superuser')
          render :json => {}, :status => 401

          return
        end
      end

      def authenticate_campaign_id
        user = UserWrapper.new(@current_user)

        if @current_user.nil?
          render :json => {}, :status => 401

          return
        end

        @campaign_id = user.run('campaign_id')
      end
    end
  end
end
