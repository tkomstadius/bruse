class TagsController < ApplicationController
	before_action :set_tag , only: [:show]

  def index
    @tag = Tag.search(params[:search])
  end

  def edit
      @tag = Tag.find(params[:id])
  end

	def show
  end

  def update
  @tag = Tag.find(params[:id])
 
  if @tag.update(tag_params)
    redirect_to @tag
  else
    render 'edit'
  end
end

  private

  def set_tag
	  @tag = Tag.find(params[:id])
	end

	def tag_params
      params.require(:tag).permit(:name)
  end

end
