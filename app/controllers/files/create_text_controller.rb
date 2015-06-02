class Files::CreateTextController < Files::CreateController
  skip_before_action :verify_authenticity_token, only: :create_from_text
  skip_before_filter :set_identity

  # Public: Create a file from a text string
  def create_from_text
    # check that current user has a local identity
    if current_user.local_identity
      # create the brusefile
      @file = create_file(text_params["content"])

      # insert our file on the users local identity
      if current_user.local_identity.bruse_files << @file
        # send response that everything is ok!
        render status: :created
      else
        render status: :internal_server_error
      end
    else
      # no file! not working!
      @file = nil
      render status :not_acceptable
    end
  end

  private
    def text_params
      params.require(:text).permit(:content)
    end

    # Private: Create a text or url file containing content
    #
    # content   - the file content
    #
    # Returns a new BruseFile
    def create_file(content)
      if is_url?(content)
        # return file name from url func
        create_url_file(extract_url(content))
      else
        # return file name from text func
        create_text_file content
      end
    end

    # Private: Create a text file containing content
    #
    # content   - the file content
    #
    # Returns a new BruseFile
    def create_text_file(content)
      # generate file name
      fileref = SecureRandom.uuid
      local_file_name = Rails.root.join('usercontent', fileref)
      # write to file
      IO.write(local_file_name, content)
      # create pritty file name
      name = content[0..10].downcase.gsub(/[^a-z0-9_\.]/, '_') + ".txt"
      # return new BruseFile
      BruseFile.new(name: name,
                    foreign_ref: fileref,
                    filetype: "text/plain")
    end

    # Private: Create a url (bookmark) file with the url url
    #
    # target  - the file name
    # url     - the url
    #
    # Returns a new BruseFile
    def create_url_file(url)
      # name from domain name+tld
      name = url.gsub(/(https?|s?ftp):\/\//, "").gsub(/(\/.*)*/, "")
      BruseFile.new(name: name,
                    foreign_ref: url,
                    filetype: "bruse/url")
    end

    # Private: check if string is url
    #
    # Returns boolean
    def is_url?(s)
      url = extract_url(s)
      s == url
    end

    # Private: Extract url from s
    #
    # Returns an url from s, if any
    def extract_url(s)
      s[/(https?|s?ftp):\/\/[\w-]*(\.[\w-]*)+([\w.,@?^=%&amp;:\/~+#-]*[\w@?^=%&amp;\/~+#-])?/]
    end
end
