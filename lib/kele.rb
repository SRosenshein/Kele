require_relative "kele/version"
require_relative "kele/roadmap"
# dir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'httparty'
module Kele
    class Kele
        require 'json'
        include HTTParty
        include Roadmap
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
            
            parser(response.body)
        end
        
        def get_mentor_availability(m_id)
            response = self.class.get(
                "/mentors/#{m_id}/student_availability",
                headers: {"authorization" => @auth_token}
            )
            
            mentor_availability = parser(response.body)
            #Array of time slot hashes
            mentor_availability.map {|time_slot| time_slot if time_slot["booked"] == nil} #ignore booked time slots
        end
        
        def get_messages(*page)#option of retreiving a page or all messages(no specific page)
            raise ArgumentError if page.length > 1
            response = self.class.get(
                "/message_threads",
                headers: {"authorization" => @auth_token},
                #body: {page: (page.count>0 ? page[0] : nil)}
            )
            parser(response.body)
        end
        
        def create_message(user_id, recipient_id, options={})
            message_data = {user_id: user_id, recipient_id: recipient_id, subject: options[:subject], "stripped-text" => options[:body]}
            message_data[:token] = options[:token] if options[:token]
            
            post_response = self.class.post(
                "/messages",
                {headers: {"authorization" => @auth_token},
                body: message_data}
            ) 
            parser(post_response.body)
        end
        
        def create_submission(e_id, c_id, options={})
            submission_data = {enrollment_id: e_id, checkpoint_id: c_id, assignment_branch: options[:branch], assignment_commit_link: options[:link], comment: options[:comment]}
            
            post_response = self.class.post(
                "/checkpoint_submissions",
                {headers: {"authorization" => @auth_token}, body: submission_data}
            )
            parser(post_response.body)
        end
        
        private
        
        def parser(data)
            JSON.parse(data)
        end
    end
end