class TagsController < ApplicationController
	before_action :set_tag , only: [:show]

  def index
    @tag = Tag.search(params[:search])
    # if params[:q].present?
    #   @tags = Tag.search(params[:q], page: params[:page])
    # else
    #   @tags = Tag.all.page params[:page]
    # end
  end

  def autocomplete
    render json: Tag.search(params[:query], autocomplete: true, limit: 10).map(&:name)
  end

	def show
  end

  private

  def set_tag
	  @tag = Tag.find(params[:id])
	end

	def bruse_file_params
      params.require(:tag).permit(:name)
  end

end
