require 'candidatexyz/resources/resource'

module CandidateXYZ
  module Resources
    class Campaign < Resource
      attr_accessor :id, :name

      def initialize(parameters)
        @id = parameters[:id]
        @name = parameters[:name]
      end

      def self.find(id)
        resource = get(endpoint("/#{id}"))

        Campaign.new(resource)
      end

      def self.all
        resources = get(endpoint())
        
        resources.map { |resource|
          Campaign.new(resource)
        }
      end

      def save
        post(endpoint(), {
          id: id,
          name: name
        })
      end

      def update(parameters)
        patch(endpoint(), {
          name: name
        })
      end

      private
      def endpoint(url)
        auth_endpoint("/campaigns#{url}")
      end
    end
  end
end
  