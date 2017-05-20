# class SessionsController < Clearance::SessionsController
#   def create
#     puts "fuck off"
#     @user = authenticate(params)
#     sign_in(@user) do |status|
#       respond_to do |format|
#         if status.success?
#           format.html { redirect_back_or url_after_create }
#           format.json { render json: @user, status: :ok }
#         else
#           format.html do
#             flash.now.notice = status.failure_message
#             render template: 'sessions/new', status: :unauthorized
#           end
#           format.json { render json: [errors: status.failure_message], status: :unauthorized }
#         end
#       end
#     end
#   end
#
# end
