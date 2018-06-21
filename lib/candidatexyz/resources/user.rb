require 'candidatexyz/resources/resource'

module CandidateXYZ
  module Resources
    class User < Resource
      attr_accessor :id, :email, :first_name, :last_name, :admin, :superuser, :campaign_id

      def initialize(parameters)
        @id = parameters[:id]
        @email = parameters[:email]
        @first_name = parameters[:firstName]
        @last_name = parameters[:lastName]
        @admin = parameters[:admin]
        @superuser = parameters[:superuser]
        @campaign_id = parameters[:campaign_id]
      end

      def self.find(id)
        resource = get(endpoint(id))

        User.new(resource)
      end

      def self.find_by_campaign(campaign_id)
        resource = get(endpoint("?campaign_id=#{campaign_id}"))

        resources.map { |resource|
          User.new(resource)
        }
      end

      def self.all
        resources = get(endpoint())
        
        resources.map { |resource|
          User.new(resource)
        }
      end

      def save
        post(endpoint(), {
          id: id,
          email: email,
          first_name: first_name,
          last_name: last_name,
          admin: admin
        })
      end

      def update(parameters)
        patch(endpoint(), {
          email: email,
          first_name: first_name,
          last_name: last_name,
          admin: admin
        })
      end

      private
      def endpoint(url)
        auth_endpoint("/staff#{url}")
      end
    end
  end
end
  