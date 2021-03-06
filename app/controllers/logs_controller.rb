#TODO delete logs instance +db +schema + controller, model, view (?)

class LogsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_log, only: [:show, :edit, :update, :destroy]

  # GET /logs
  # GET /logs.json
  def index
    #@logs = Log.where(ok: false).order('created_at DESC')
    @logs = Log.all.order('created_at DESC')
  end

  def raw
    @logs = Log.all.order('created_at DESC')
  end

  # GET /logs/1
  # GET /logs/1.json
  def show
  end

  # GET /logs/new
  def new
    @log = Log.new
  end

  # GET /logs/1/edit
  def edit
  end

  def clear_log
    Log.destroy_all
    redirect_to logs_path
  end

  # POST /logs
  # POST /logs.json
  def create
    @log = Log.new(log_params)

    respond_to do |format|
      if @log.save
        format.html { redirect_to @log, notice: 'Log was successfully created.' }
        format.json { render action: 'show', status: :created, location: @log }
      else
        format.html { render action: 'new' }
        format.json { render json: @log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /logs/1
  # PATCH/PUT /logs/1.json
  def update
    respond_to do |format|
      if @log.update(log_params)
        format.html { redirect_to @log, notice: 'Log was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /logs/1
  # DELETE /logs/1.json
  def destroy
    url = @log.url
    url.logs.destroy_all
    url.destroy

    respond_to do |format|
      format.html { redirect_to logs_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_log
      @log = Log.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def log_params
      params.require(:log).permit(:message, :price_found, :name_found, :type, :ok, :ok_all)
    end
end
