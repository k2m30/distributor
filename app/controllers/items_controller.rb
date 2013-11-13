class ItemsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  # GET /items
  # GET /items.json
  def index
    @items = Item.all
    @sites_stripped = []
    @items.each do |item|
      item.urls.each do |url|

        @sites_stripped << url.site
      end
    end

    @sites = @sites_stripped.uniq

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
		items = Item.all
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
    @item = Item.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def item_params
    params.require(:item).permit!#(:name, :group_id, urls_attributes: [:url, :id, :_destroy, :sites])
  end


end
