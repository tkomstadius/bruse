class TagsController < ApplicationController
	before_action :set_tag , only: [:show]

  def index
    @tag = Tag.search(params[:search])
  end

  def edit
    @tag = Tag.find(tag_params[:id])
  end

	def show
  end

  def new
    @tag = Tag.new
    @file = BruseFile.find(params[:file_id])
  end

  def create
    @file = BruseFile.find_by(:id => tag_params[:file_id])
    @tag = Tag.find_or_create_by(:name => tag_params[:name])
    @tag.bruse_files.append( @file )

     respond_to do |format|
        if @tag.save
          format.html { redirect_to @tag, notice: 'Order was successfully created.' }
          format.json { render :show, status: :ok, location: @tag }
        else
          format.html { render :new }
          format.json { render json: @tag.errors, status: :unprocessable_entity }
        end
    end
  end


  

  def update
    @tag = Tag.find(params[:id])
   
    if @tag.update(tag_params)
      redirect_to @tag
    else
      render 'edit'
    end
  end

  def destroy
   #@tag = Tag.find(params[:id])

   #@file = @tag.bruse_files.find(tag_params[:file_id])

   #if category
   #     post.categories.delete(category)
   #  end

  # if bruse_file
  #    @file.bruse_files.delete(@tag)
  # end
  @tag = Tag.find(params[:id])
  @file = @tag.bruse_files.find(tag_params[:id])
  #file = BruseFile.find_by(:id => tag_params[:file_id])
  #@file = BruseFile.find(params[:file_id])
  #@tag.delete 

   #@file.bruse_file.delete(@tag)
  
    #@tag= Tag.find(params[:id])
    #@tag = @file.tags.find(params[:id])
   # @file.tags.delete(params[:id])#(remove_tag_from_file)

    #redirect_to bruse_files_path(@file)
    respond_to do |format|
      format.html { redirect_to bruse_files_url, notice: 'tags controller.' }
      format.json { head :no_content }
    end
  end




def remove_tag_from_file
     #@file = BruseFile.find(params[:file_id])
    # @tag = @file.tags.find(params[:id])

   #if bruse_file
   #   @file.bruse_files.delete(@tag)
   #end

end


private

  def set_tag
	  @tag = Tag.find(params[:id])
	end

	def tag_params
      params.require(:tag).permit(:name, :file_id)
  end

end
