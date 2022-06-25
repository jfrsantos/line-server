class FileService
  def get_line_text(line)
    filename = Rails.application.assets[Rails.configuration.x.served_file].filename
    
    # read file line by line to limit memory usage
    File.open(filename).each_with_index do |file_line_text, index|
      if index + 1 == line
        return file_line_text
      end
    end

    raise LoadError
  end
end