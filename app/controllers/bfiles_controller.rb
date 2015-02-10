class BfilesController < ApplicationController

  def new
    puts "In the new method"
  end

  def index
  end

  def create
    puts "Params: #{params[:bfile]}"
    post = Bfile.save(params[:bfile])
    render :text => "File has been uploaded successfully"
  end

end
