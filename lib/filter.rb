module Filter
  def input_check(params, controller, conn)
    params.each {
      |key, value|
      problem = false
      
      if key == :commit
        unless value == "Add" or value == "Remove" or value == "Submit"
          redirect_to(:controller => controller, :action => "index") and return
          problem = true
        end # if Add, Remove, Submit
      end # if commit
      
      if key == :portal_id
        if filter(value)
          unless check_user(conn, value)
            problem = true
          end # if user
        else
          problem = true
        end # if filter
      end # if portal_id
      
      if key == :source_id
        if filter(value)
          
        else
          problem = true
        end # if filter
      end # if source_id
    } # params.each
  end # input_check
end # module Filter