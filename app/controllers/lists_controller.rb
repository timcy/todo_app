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

  def calendar_view
    @lists_by_date = List.all.group_by{|i| i.created_at.to_date}
    # @lists_by_date = List.group(:created_at).pluck(:heading, :created_at)
    puts "*" * 80
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    respond_modal_with @lists_by_date, layout: :modal
    # respond_to do |format|
    #   format.html {}
    #   format.js {}
    # end    
  end

  def show
    @list = List.find(params[:id])
    respond_modal_with @list, layout: :modal
        # respond_to do |format|
    #   format.html {}
    #   format.js {}
    # end      
  end

  def edit
    @list = List.find(params[:id])
  end

  def update
    @list = List.find(params[:id])
    @list.update(list_params)
    respond_to do |format|
      format.html { }
      format.js {}
    end
  end

  def destroy
    @list = List.find(params[:id])
    if @list.destroy
      respond_to do |format|
        format.html { }
        format.js { }
      end
    end
  end

  private

  def list_params
    params.require(:list).permit(:heading, tasks_attributes: [:id, :description, :_destroy, :is_complete])
  end
end
