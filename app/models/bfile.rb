class Bfile < ActiveRecord::Base
  
  def self.save(fil)
    puts "In save method"
    puts fil
    name =  fil[:upload].original_filename
    directory = "public/share/"
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(fil[:upload].read) }
  end
end
