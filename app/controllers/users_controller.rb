class UsersController < ApplicationController

  before_filter :authenticate_user, :only => [:download, :upload, :deletefile]

  def new
    if current_user
      @user = current_user
      render "first"
    else
      @user = User.new
      render "new"
    end
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
    if params[:ufile] && !params[:ufile].blank?
      uploaded_io = params[:ufile]
      puts @user[:userid]
      puts uploaded_io.original_filename
      File.open(Rails.root.join('private', @user[:userid], uploaded_io.original_filename), 'wb') do |file|
        file.write(uploaded_io.read)
      end
      redirect_to root_url, :notice => "File uploaded successfully!"
    else
      redirect_to root_url, :notice => "Invalid action!"
    end
  end

  def download
    puts params
    if params[:dfile] && !params[:dfile].blank?
      send_file(Rails.root.join('private', @user[:userid], params[:dfile]), disposition: 'attachment', type: 'application/octet-stream')
    else
      redirect_to root_url, :notice => "download file failed!"
    end
  end

  def deletefile
    if params[:dfile] && !params[:dfile].blank?
      File.delete(Rails.root.join('private', @user[:userid], params[:dfile]))
      redirect_to root_url, :notice => "file deleted!"
    else
      redirect_to root_url, :notice => "delete file failed!"
    end
  end

  private
      def user_params
        params.require(:user).permit(:userid, :password, :password_confirmation)
      end
end
