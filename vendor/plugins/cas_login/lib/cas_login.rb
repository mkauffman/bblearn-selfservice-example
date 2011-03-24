# == Synopsis
# CasLogin - Provides simple means for authenticating users against campus directory
# == Author 
# Scott Jungling
# == Version
# 1.1
# == Acknowledgements
# Based on the works of Matt Walker James Smith from Texas A&M
# == Usage
# 

# Use HTTPS for connecting to CAS 
require 'net/https'

class ActionController::Base # :nodoc:
  public :redirect_to
end 


module CasLogin
 
    # The URL of the CAS server to authenticate against.
    CAS_SERVER_URL = 'cas.csuchico.edu'

    # The port the CAS server is running on.
    PORT = 443
    
    # Temp Valid User
    @authenticatedUserID = nil

    
    # === Returns 
    # [string] validated UserID
    def get_authenticated_user_id
      return @authenticatedUserID
    end

    protected
    # - If no ticket is present; they will be redirected to CAS' login screen
    # - If they do have a ticket, this will try to verify the validity of the ticket
    # === Returns 
    # [boolean] on success or failure of validating a ticket
    def is_authenticated? #:doc:
      # debugger
      # Get the URL the user is trying to access
      @service = request.url.gsub(/\?(.*)/,"")
      logger.info "TRYING TO ACCESS: #{@service}"
      
      # If there's a ticket try to validate
      unless params[:ticket].nil?
        logger.info "validate ticket w/ url #{@service}"
        if is_valid_ticket(@service,params[:ticket])
          return true
        else
          logger.info "Sorry. Your ticket is no longer valid"
          return false
        end
      else
        redirect_to "https://#{CAS_SERVER_URL}/cas/login?service=#{@service}"
        return false
      end
      
      # Default Response
      return false
    end
    
    private
    # Validates a CAS ticket with the server.
    #
    # === Variables:
    # [service] The URL of the calling service.
    # [ticket] The CAS ticket returned by the server in the URL.
    #
    # === Returns 
    # [boolean]
    def is_valid_ticket(service,ticket) #:doc:
        http = Net::HTTP.new(CAS_SERVER_URL, PORT)
        http.use_ssl = true
        url = "/cas/validate?ticket=#{ticket}&service=#{service}"
        logger.info "URL: #{url}"
        logger.info "SERVICE: #{service}"
        response = http.get2(url)
        answer, name = response.body.chomp.split("\n")
        if answer == "yes"
          @authenticatedUserID = name
          return true
        else
          return false
        end
    end
end