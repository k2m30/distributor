class SettingsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_setting, only: [:show, :edit, :update, :destroy]

  # GET /settings
  # GET /settings.json
  def index

    @settings = current_user.settings
    if @settings.nil?
      @settings = Settings.new
      @settings.user = current_user
      @settings.save
    end
  end

  # GET /settings/1
  # GET /settings/1.json
  def show
  end

  # GET /settings/new
  def new
    @setting = Settings.new
  end

  # GET /settings/1/edit
  def edit
  end

  # POST /settings
  # POST /settings.json
  def create
    @setting = Settings.new(setting_params)

    respond_to do |format|
      if @setting.save
        format.html { redirect_to @setting, notice: 'Settings was successfully created.' }
        format.json { render action: 'show', status: :created, location: @setting }
      else
        format.html { render action: 'new' }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/1
  # PATCH/PUT /settings/1.json
  def update
    respond_to do |format|
      if @setting.update(setting_params)
        format.html { redirect_to @setting, notice: 'Settings was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/1
  # DELETE /settings/1.json
  def destroy
    @setting.destroy
    respond_to do |format|
      format.html { redirect_to settings_index_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_setting
      @setting = Settings.find(params[:id])

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def setting_params
      params.require(:settings).permit(:ban_time, :last_updated, :allowed_error, :update_time)
    end
end
