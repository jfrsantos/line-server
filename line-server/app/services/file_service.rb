class FileService
  def get_line_text(line)
    file = Rails.application.assets["sample.txt"].filename
    
    File.open(file).each_with_index do |file_line_text, index|
      if index + 1 == line
        return file_line_text
      end
    end

    raise LoadError
  end
end