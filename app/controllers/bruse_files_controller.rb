class BruseFilesController < ApplicationController
	before_action :set_order , only: [:show, :edit]

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
      @bruse_file.tags.append(Tag.create(:name => t)) 
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

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_order
	  @bruse_file = BruseFile.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
    def bruse_file_params
      params.require(:bruse_file).permit(:name, :filetype, :meta, :foreign_ref, :identity_id, :tagname)
    end

end
