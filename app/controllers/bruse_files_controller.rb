class BruseFilesController < ApplicationController
	before_action :set_file , only: [:show, :edit, :destroy]

  def index
   @bruse_files = BruseFile.all
   
    
  end
  

  def show
  end

  # GET /orders/1/edit
  def edit
    
  end

  # GET /orders/new
  def new
    @bruse_file = BruseFile.new
  end

  def create
    tag = bruse_file_params[:tagname].split
    bruse_file_params.delete :tagname
    @bruse_file = BruseFile.new(bruse_file_params)
    

    tag.each do |t|
      tag = Tag.find_by(:name => t)
      if tag.nil? 
        tag = Tag.create(:name => t)
      end
      @bruse_file.tags.append(tag) 
    end

    respond_to do |format|
      if @bruse_file.save
        format.html { redirect_to @bruse_file, notice: 'Order was successfully created.' }
        format.json { render :show, status: :ok, location: @bruse_file }
      else
        format.html { render :new }
        format.json { render json: @bruse_file.errors, status: :unprocessable_entity }
      end
    end
  end
  def destroy
    @bruse_file.destroy
    respond_to do |format|
      format.html { redirect_to bruse_files_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_file
	  @bruse_file = BruseFile.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
    def bruse_file_params
      params.require(:bruse_file).permit(:name, :filetype, :meta, :foreign_ref, :identity_id, :tagname)
    end

end
