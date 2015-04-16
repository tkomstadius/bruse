class Files::DownloadController < Files::FilesController
  skip_before_filter :set_identity
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
      @filepath = "get/#{@file.download_hash}/#{@file.name}"
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
      send_data file.identity.get_file(file.foreign_ref), name: file.name, type: file.filetype
    end
  end
end
