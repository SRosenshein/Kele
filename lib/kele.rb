require "kele/version"
dir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
require File.join(dir, 'httparty')

class Kele
    include HTTParty
    base_uri "https://www.bloc.io/api/v1"
    
    def initialize(email, password)
        @auth = {e: email, p: password}
        
        post_response = self.class.post(
            "https://www.bloc.io/api/v1/sessions",
            {basic_auth: @auth}
        )
          
        @auth_token = post_response.body["auth_token"]
      
    end
end
