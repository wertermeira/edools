require "edools/version"
require 'excon'
require 'json'

require File.dirname(__FILE__) + '/edools/utils'
require File.dirname(__FILE__) + '/edools/exceptions'

module Edools
  class Client

    BASE_URI = "https://core.myedools.info/api".freeze

    attr_accessor :access_token

    def initialize(config = {})
      @access_token  = config[:access_token]
      @raise_errors  = config[:raise_errors] || false
      @retries       = config[:retries] || 0
      @read_timeout  = config[:read_timeout] || 10
      @write_timeout = config[:write_timeout] || 10
      @connection    = Excon.new(BASE_URI, persistent: config[:persistent] || false)
    end

    def inspect
      vars = instance_variables.map { |v| "#{v}=#{instance_variable_get(v).inspect}" }.join(', ')
      "<#{self.class}: #{vars}>"
    end

    def close_connection
      @connection.reset
    end
    #schools
      #show school
      def show_school(id)
        run(:get, "/schools/#{id}", [200])
      end
      #create school
      def create_school(params = {})
        run(:post, "/schools/wizard", [201,422], JSON.dump(params))
      end
      #update school
      def update_school(id, params = {})
        run(:put, "/schools/#{id}", [200,422], JSON.dump(params))
      end

    #courses
      #list courses
      def courses
        run(:get,"/courses", [200])
      end
      #show course
      def show_course(id)
        run(:get, "/courses/#{id}", [200])
      end
      #create course
      def create_course(params = {})
        run(:post, "/courses", [201,422], JSON.dump(params))
      end

      #update course
      def update_course(id, params = {})
        run(:put, "/courses/#{id}", [200,422], JSON.dump(params))
      end

      #destroy course
      def destroy_course(id)
        run(:put, "/courses/#{id}", [204,404])
      end
    #products
      #TODO error not rerturn products
      #list products
      def products
        run(:get,"/school_products", [200])
      end

      #create products
      def create_product(school_id, params = {})
        run(:post, "/schools/#{school_id}/school_products", [201,422], JSON.dump(params))
      end

    #studantes
      #studants
      def studants
        run(:get,"/studants", [200])
      end

      #create studants and invitation
      def create_and_invitation_studant(params = {})
        run(:post, "/invitations", [201,422], JSON.dump(params))
      end
      #show studant
      def show_studant(id)
        run(:get, "/studants/#{id}", [200,404])
      end

      #create studants
      def create_studant(params = {})
        run(:post, "/studants/", [201,422], JSON.dump(params))
      end


      #update studants
      def update_studant(id, params = {})
        run(:put, "/studants/#{id}", [200,422], JSON.dump(params))
      end

      #destroy studant
      def destroy_studant(id)
        run(:delete, "/studants/#{id}", [204,404])
      end


    protected

    def run(verb, path, expected_status_codes, params = {}, idempotent = true)
      run!(verb, path, expected_status_codes, params, idempotent)
    rescue Error => e
      if @raise_errors
        raise e
      else
        false
      end
    end


    def run!(verb, path, expected_status_codes, params_or_body = nil, idempotent = true)
      packet = {
          idempotent: idempotent,
          expects: expected_status_codes,
          method: verb,
          path: path,
          read_timeout: @read_timeout,
          write_timeout: @write_timeout,
          retry_limit: @retries,
          headers: {
              'Content-Type' => 'application/json',
              'Accept' => 'application/vnd.edools.core.v1+json'
          }
      }
      if params_or_body.is_a?(Hash)
        packet.merge!(query: params_or_body)
      else
        packet.merge!(body: params_or_body)
      end

      if !@access_token.nil? && @access_token != ''
        packet[:headers].merge!('Authorization' => 'Token token="' + @access_token +'"')
      end

      response = @connection.request(packet)
      @response_body = response.body
      ::JSON.load(@response_body)

    rescue Excon::Errors::NotFound => exception
      raise(ResourceNotFound, "Error: #{exception.message}")
    rescue Excon::Errors::BadRequest => exception
      raise(BadRequest, "Error: #{exception.message}")
    rescue Excon::Errors::Forbidden => exception
      raise(InsufficientClientScopeError, "Error: #{exception.message}")
    rescue Excon::Errors::Unauthorized => exception
      raise(AuthenticationError, "Error: #{exception.message}")
    rescue Excon::Errors::Error => exception
      raise(HTTPError, "Error: #{exception.message}")
    end


  end
end
