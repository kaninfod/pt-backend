# class UsersController < Clearance::UsersController
#
#
#
#   def index
#     @users = User.all
#   end
#
#   def show
#     @user = User.find(params[:id])
#   end
#
#   def edit
#     @user = current_user
#   end
#
#   def update
#     data = params.require(:user).permit(:name, :email, :avatar)
#     if current_user.update(data)
#       redirect_to "/photos"
#     end
#   end
#
#   private
#
#   def user_from_params
#     email = user_params.delete(:email)
#     password = user_params.delete(:password)
#     name = user_params.delete(:name)
#
#     Clearance.configuration.user_model.new(user_params).tap do |user|
#       user.email = email
#       user.password = password
#       user.name = name
#     end
#   end
#
# end
