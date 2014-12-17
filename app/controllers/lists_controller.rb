class ListsController < ApplicationController

  respond_to :html, :json

  def new
    @list = List.new
    # respond_modal_with @list
  end

  def create
    @list = List.new(list_params)
      if @list.save
        redirect_to lists_path
      else
        render :new
      end
  end

  def index
    @lists = List.all.order(:created_at => :desc)
  end

  def show
    @list = List.find(params[:id])
  end

  def edit
    @list = List.find(params[:id])
  end

  def update
    @list = List.find(params[:id])
    # puts "*" * 80
    # puts @list.tasks
    # puts params
    # puts "*" * 80
    @list.update(list_params)
    respond_to do |format|
      format.html { } #redirect_to @list }
      format.js {}
    end
  end

  def destroy
    @list = List.find(params[:id])
    if @list.destroy
      respond_to do |format|
        format.html { } #redirect_to lists_path }
        format.js { }
      end
    end
  end

  private

  def list_params
    params.require(:list).permit(:heading, tasks_attributes: [:id, :description, :_destroy, :is_complete])
  end
end
