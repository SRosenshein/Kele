
require_relative "kele/version"
# dir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'httparty'
module Kele
    class Kele
        require 'json'
        include HTTParty
        base_uri "https://www.bloc.io/api/v1"
        
        def initialize(email, password)
            @auth = {email: email, password: password}
            
            post_response = self.class.post(
                "/sessions",
                body: @auth
            )
            #puts post_response.inspect
            
            @auth_token = post_response["auth_token"]
            
            raise "Invalid Credentials" if (!@auth_token)
        end
        
        def get_me
            response = self.class.get(
                "/users/me",
                headers: {"authorization" => @auth_token}
            )
            parse_user_data(response.body)
        end
        
        private
        
        def parse_user_data(resp)
            user_hash = JSON.parse(resp)
        end
    end
end