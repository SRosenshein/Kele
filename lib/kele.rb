
require_relative "kele/version"
# dir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'httparty'
module Kele
    class Kele
        include HTTParty
        base_uri "https://www.bloc.io/api/v1"
        
        def initialize(email, password)
            @auth = {email: email, password: password}
            
            post_response = self.class.post(
                "/sessions",
                body: @auth
            )
            #puts post_response.inspect
            
            @auth_token = post_response.body["auth_token"]
            
            raise "Invalid Credentials" if (!@auth_token)
        end
    end
end