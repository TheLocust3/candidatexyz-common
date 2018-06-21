require 'httparty'

module CandidateXYZ
  module Concerns
    module Authenticatable
      extend ActiveSupport::Concern

      def authenticate
        begin
          response = HTTParty.get("#{Rails.application.secrets.auth_api}/auth/validate_token?uid=#{request.headers['uid']}&client=#{request.headers['client']}&access-token=#{request.headers['access-token']}")
          data = response.parsed_response

          @current_user = data['data']
        rescue
          render :json => {}, :status => 401
        end
      end

      def authenticate_superuser
        if @current_user.nil? || !@current_user.superuser
          render :json => {}, :status => 401

          return
        end
      end

      def authenticate_campaign_id
        if @current_user.nil?
          render :json => {}, :status => 401

          return
        end

        @campaign_id = @current_user.campaign_id
      end
    end
  end
end
