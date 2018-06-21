require 'httparty'

module CandidateXYZ
  module Concerns
    module Request
      extend ActiveSupport::Concern

      def get(url)
        response = HTTParty.post(url, {
          headers: auth_headers
        })

        response.parsed_response
      end

      def post(url, data)
        response = HTTParty.post(url, {
          query: data,
          headers: auth_headers
        })

        response.parsed_response
      end

      def patch(url, data)
        response = HTTParty.patch(url, {
          query: data,
          headers: auth_headers
        })

        response.parsed_response
      end

      def put(url, data)
        response = HTTParty.put(url, {
          query: data,
          headers: auth_headers
        })

        response.parsed_response
      end
      
      def delete(url, data)
        response = HTTParty.delete(url, {
          query: data,
          headers: auth_headers
        })

        response.parsed_response
      end

      private
      def auth_headers
        {
          uid: request.headers['uid'],
          client: request.headers['client'],
          'access-token': request.headers['access-token']
        }
      end
    end
  end
end