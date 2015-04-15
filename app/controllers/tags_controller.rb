class TagsController < ApplicationController
	before_action :set_tag , only: [:show]
  skip_before_action :verify_authenticity_token, only: :create

  def index

  end

	def show

  end

  def new
    @tag = Tag.new
    @file = BruseFile.find(params[:file_id])

  end

  def create
    @file = BruseFile.find_by(:id => params[:file_id])

    if current_user.id == @file.identity.user_id
      params[:tags].each do |tag|
        @tag = Tag.find_or_create_by(:name => tag)
        @tag.bruse_files << @file
      end
    end

     respond_to do |format|
        if @tag.save
          format.html { redirect_to bruse_files_path, notice: 'Tag was successfully created.' }
          format.json { render json: {:success => true}, status: :ok }
        else
          format.html { render :new, notice: 'Something went wrong' }
          format.json { render json: {:errors => @tag.errors, :success => false}, status: :unprocessable_entity }
        end
     end
  end


  def destroy

    @file = BruseFile.find(params[:file_id])

    @tag = @file.tags.find(params[:id])


     if @tag
          @file.tags.delete(@tag)
     end

    respond_to do |format|
      format.html { redirect_to bruse_files_url, notice: 'Deleted tag: ' + @tag.name.to_s}
      format.json { head :no_content }
    end
  end


private

  def set_tag
	  @tag = Tag.find(params[:id])
	end

	def tag_params
      params.require(:tag).permit(:name, :file_id)
  end

end
