class TagsController < ApplicationController
	before_action :set_tag , only: [:show]

  def index

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
    tag_params[:name].split.each do |tag|
      @tag = Tag.find_or_create_by(:name => tag)
      @tag.bruse_files.append( @file )
    end

 
     respond_to do |format|
        if @tag.save
          format.html { redirect_to bruse_files_path, notice: 'Tag was successfully created.' }
          format.json { render :show, status: :ok, location:  @tag.bruse_files }
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
