class Files::DownloadController < Files::FilesController
  skip_before_filter :set_identity
  before_filter :set_file, except: :download

  def preview
    if @file.identity.user == current_user
      # save preview file name
      filename = Rails.root.join('tmp', 'bruse-previews', "prev-#{@file.id}")

      # check file if preview tmp folder exists
      unless File.directory?(Rails.root.join('tmp', 'bruse-previews'))
        Dir.mkdir(Rails.root.join('tmp', 'bruse-previews'))
      end

      # check if preview file exists, else download it
      if File.file?(filename)
        send_file filename,
                  filename: @file.name,
                  type: @file.filetype,
                  status: :not_modified
      else
        # save file data
        data = @file.identity.get_file(@file.foreign_ref)
        File.open(filename, 'wb') do |file|
          file.write(data)
        end
        # IO.write(filename, data)
        # send the file to the user
        send_data data,
                  disposition: 'inline',
                  filename: @file.name,
                  type: @file.filetype
      end
    end
  end

  # Public: generates a secure download url only accessable for
  # the owner.
  #
  # identity_id - gets owner of file
  # file_id - specified file
  #
  # Examples
  #   {identity_id: 1, file_id: 1} --> download_url
  #   # => @filepath # a secure unique url
  #
  def download_url
    if @file.identity.user == current_user
      @file.generate_download_hash
      @filepath = "get/#{@file.download_hash}"
    end
  end

  # Public: Sends requested file to user if the user has
  # the rights to download
  #
  # download_hash - unique hash for a file
  # name - name of the requested file
  # format - format of the file thats being downloaded
  #
  # Examples
  #   Get /get/lkajdflakjsdflhb/file.m
  #     # => downloads file.m
  #
  def download
    file = BruseFile.find_by(:download_hash => params[:download_hash])
    if file.identity.user == current_user
      # send the file to the user
      send_data file.identity.get_file(file.foreign_ref), filename: file.name, type: file.filetype
    end
  end
end
