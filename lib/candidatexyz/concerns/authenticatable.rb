require 'httparty'

module CandidateXYZ
  module Concerns
    module Authenticatable
      extend ActiveSupport::Concern

      def authenticate
        begin
          response = HTTParty.get("#{Rails.application.secrets.auth_api}/auth/validate_token?uid=#{request.headers['uid']}&client=#{request.headers['client']}&access-token=#{request.headers['access-token']}")
          data = response.parsed_response

          current_user = data['data']
        rescue
          render :json => {}, :status => 401
        end
      end

      def authenticate_campaign_id
        campaign_id = current_user.campaign_id

        if campaign_id != params[:campaign_id]
          render :json => {}, :status => 401
        end
      end
    end
  end
end
