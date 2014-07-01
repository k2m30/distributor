class GroupsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_group, only: [:show]

  # GET /groups/1
  # GET /groups/1.json
  def show
    @sites = @group.sites.order(:name)
    #@sites = Site.where(id: [4, 7, 8, 15, 22, 24])#
  end

  private
  def set_group
    if current_user.admin?
      @group = Group.find(params[:id])
    else
      @group = current_user.groups.find(params[:id])
    end
    redirect_to root_path, alert: 'Некорректный адрес.' if @group.nil?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def group_params
    params.require(:group).permit(:name)
  end
end
