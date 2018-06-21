require 'candidatexyz/concerns/request'

module CandidateXYZ
  module Resources
    class Resource
      include CandidateXYZ::Concerns::Request

      @@auth_url = 'https://auth.candidatexyz.com'
      @@api_url = 'https://api.candidatexyz.com'

      class << self
        attr_accessor :auth_url, :api_url
      end

      def self.find(id)

      end

      def self.all

      end

      def save

      end

      def update(parameters)

      end

      protected
      def auth_endpoint(endpoint)
        auth_url + endpoint
      end

      def api_endpoint(endpoint)
        api_url + endpoint
      end
    end
  end
end
  