class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_url, :notice => "Signed up successfully!"
    else
      render "new"
    end
  end

  def first
    if current_user
      @user = current_user
    else
      @user = User.new
      render "new"
    end
  end

  def upload
    first
    uploaded_io = params[:ufile]
    puts @user[:userid]
    puts uploaded_io.original_filename
    File.open(Rails.root.join('public', 'share', @user[:userid], uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
    end
    redirect_to root_url, :notice => "File uploaded successfully!"
  end

  private
      def user_params
        params.require(:user).permit(:userid, :password, :password_confirmation)
      end
end
