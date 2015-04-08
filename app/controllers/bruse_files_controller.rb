class BruseFilesController < ApplicationController
	before_action :set_file , only: [:show, :edit, :destroy]

  def index
   @bruse_files = BruseFile.all
  end

  def show
  end

  def edit
  end

  def new
  end

  def destroy
    @bruse_file.destroy
    respond_to do |format|
      format.html { redirect_to bruse_files_url, notice: 'File was successfully destroyed.' }
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