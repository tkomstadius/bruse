class TagsController < ApplicationController
  before_action :set_tag, only: [:show]
  before_action :set_file, only: [:new, :create, :destroy]
  skip_before_action :verify_authenticity_token, only: :create

  def index
  end

  def show
  end

  def new
    @tag = Tag.new
  end

  def create
    tags = []
    params[:tags].each do |tag|
      tags << Tag.find_or_create_by(name: tag)
    end
    @file.tags.replace(tags)

    respond_to do |format|
      format.html { redirect_to bruse_files_path, notice: 'Tag was successfully created.' }
      format.json { render :create, status: :ok }
    end
  end

  def destroy
    @tag = @file.tags.find(params[:id])

    if @tag
      @file.tags.delete(@tag)
    end

    respond_to do |format|
      format.html { redirect_to bruse_files_url, notice: 'Deleted tag: ' + @tag.name.to_s }
      format.json { head :no_content }
    end
  end

  private

    def set_tag
      @tag = Tag.find(params[:id])
    end

    def set_file
      @file = BruseFile.find(params[:file_id])
      unless current_user.id == @file.identity.user_id
        flash[:alert] = 'Access denied'
        redirect_to root
      end
    end

    def tag_params
      params.require(:tag).permit(:name, :file_id)
    end
end
