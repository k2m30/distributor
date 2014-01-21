class ItemsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  # GET /items
  # GET /items.json
  def index
    if current_user.admin?
      @items = Item.all.order(:id)
    else
      @items = Item.joins(:group => :user).where(groups: {user_id: current_user.id}).order(:id)
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render action: 'show', status: :created, location: @item }
      else
        format.html { render action: 'new' }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      # debugger
      if @item.update(item_params)
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url }
      format.json { head :no_content }
    end
  end
	
	def refine_items
		items = Item.joins(:group => :user).where(groups: {user_id: current_user.id})
		items.each do |item|
			name = item.name.gsub('Е', 'E').gsub('Н', 'H').gsub('О', 'O').gsub('Р', 'P').gsub('А', 'A').gsub('В', 'B').gsub('С', 'C').gsub('М', 'M').gsub('Т', 'T').gsub('К', 'K').gsub('Х', 'X').gsub('/', ' ').gsub('\\', ' ')
			item.name = name
			item.save
		end
		redirect_to items_path
	end
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_item
    if current_user.admin?
      @item = Item.find(params[:id])
    else
      @item = Item.joins(:group => :user).where(groups: {user_id: current_user.id}, id: params[:id]).first
    end
    redirect_to root_path, alert: 'Некорректный адрес.' if @item.nil?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def item_params
    params.require(:item).permit!#(:name, :group_id, urls_attributes: [:url, :id, :_destroy, :sites])
  end


end
