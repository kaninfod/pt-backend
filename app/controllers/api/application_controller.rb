module Api
  class ApplicationController < ActionController::API
    before_action :authenticate_request
    attr_reader :current_user


     protected
     def self.set_pagination_headers(name, options = {})
       after_action(options) do |controller|
         results = instance_variable_get("@#{name}")
         headers["X-Pagination"] = {
           total: results.total_entries,
           total_pages: results.total_pages,
           first_page: results.current_page == 1,
           last_page: results.next_page.blank?,
           previous_page: results.previous_page,
           next_page: results.next_page,
           out_of_bounds: results.out_of_bounds?,
           offset: results.offset
         }.to_json
       end
   end


     private
     def authenticate_request
       if params.has_key? :token
         request.headers["Authorization"] = params[:token]
       end
       @current_user = AuthorizeApiRequest.call(request.headers).result
       render json: { error: 'Not Authorized' }, status: 401 unless @current_user
     end




  end
end
