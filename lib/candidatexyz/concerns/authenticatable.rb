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
            auth_str = "?uid=#{params['uid']}&client=#{params['client']}&access-token=#{params['access-token']}&test=fuk"
          end

          response = HTTParty.get("#{Rails.application.secrets.auth_api}/auth/validate_token#{auth_str}")
          data = response.parsed_response

          @current_user = data['data']

          if @current_user.nil?
            render :json => {}, :status => 401
          end
        rescue
          render :json => {}, :status => 401
        end
      end

      def authenticate_admin
        user = CandidateXYZ::Common::UserWrapper.new(@current_user)

        if @current_user.nil? || !user.run('admin')
          render :json => {}, :status => 401

          return
        end
      end

      def authenticate_superuser
        user = CandidateXYZ::Common::UserWrapper.new(@current_user)

        if @current_user.nil? || !user.run('superuser')
          render :json => {}, :status => 401

          return
        end
      end

      def authenticate_campaign_id
        user = CandidateXYZ::Common::UserWrapper.new(@current_user)

        if @current_user.nil?
          render :json => {}, :status => 401

          return
        end

        @campaign_id = user.run('campaign_id')
      end
    end
  end
end
