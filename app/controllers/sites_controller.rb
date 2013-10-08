require 'rubyXL'
require 'axlsx'

class SitesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_site, only: [:show, :edit, :update, :destroy]
  # caches_page :index, :stop_list
  # GET /sites
  # GET /sites.json
  def index
    @sites = Site.all.order("name")
    expire_fragment(controller: 'sites', action: 'stop_list', action_suffix: 'all')

  end

  # GET /sites/1
  # GET /sites/1.json
  def show
    # @standard_site = Site.where(standard: true).first
    @violating_urls = @site.urls.where(violator: true)
  end

  # GET /sites/new
  def new
    @site = Site.new
  end

  # GET /sites/1/edit
  def edit
  end

  # POST /sites
  # POST /sites.json
  def create
    @site = Site.new(site_params)

    respond_to do |format|
      if @site.save
        format.html { redirect_to @site, notice: 'Site was successfully created.' }
        format.json { render action: 'show', status: :created, location: @site }
      else
        format.html { render action: 'new' }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sites/1
  # PATCH/PUT /sites/1.json
  def update
    respond_to do |format|
      # p "-----"
 #      p site_params[:regexp]
 #      site_params[:regexp] = Regexp.new(site_params[:regexp])
 #      p site_params[:regexp]
      if @site.update(site_params)
        format.html { redirect_to @site, notice: 'Site was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sites/1
  # DELETE /sites/1.json
  def destroy
    @site.destroy
    respond_to do |format|
      format.html { redirect_to sites_url }
      format.json { head :no_content }
    end
  end

  def stop_list

    @groups = Group.where(name: "MTD")
    @sites = []
    @groups.each do |group|
      @sites += group.sites.where(:violator => true)
    end
  end

  def export
    groups = Group.all

    Axlsx::Package.new do |p|

      groups.each do |group|
        p.workbook.add_worksheet(:name => group.name) do |sheet|
          ok = sheet.styles.add_style :color => "#000000"
          repeat = sheet.styles.add_style :bg_color => "#FF000000"
          wrong = sheet.styles.add_style :bg_color => "#fbec5d00"
          first_row = []
          first_row << group.name
          first_row += generate_first_row(group.sites)
          sheet.add_row first_row
          group.items.each do |item|
            cells = []
            cells << item.name
            cells += generate_cells(item, group.sites)
            types = generate_types(item, group.sites, ok, repeat, wrong)
            sheet.add_row cells, :style => types
          end

          sheet.rows.each do |row|
            row.cells.each do |cell|
              #sheet.add_hyperlink :location => 'https://www.google.by/search?num=10&q='+row.cells[0].value+'+site:'+sheet.rows[0].cells[cell.index].value, :ref => cell, :target => :external
              sheet.add_hyperlink :location => cell.value, :ref => cell, :target => :external
            end
          end


        end
      end
      p.serialize('export.xlsx')
    end
    redirect_to sites_path, notice: "Данные выгружены"

  end

  def import
    a = 0
    p "Started"
    workbook = RubyXL::Parser.parse("import.xlsx")

    sheets = [workbook.worksheets[0]]
    sheets.each do |sheet|
      group = Group.where(name: sheet[0][0].value).first
      data = sheet.extract_data
      data[1..data.size].each_with_index do |row, i|
        row[1..row.size].each_with_index do |col, j|
          site = group.sites.where(name: sheet[0][j+1].value).first
          # p "---" + sheet[0][j+1].value
          if site.nil?
            p "-" + sheet[0][j+1].value.to_s
          end

          item = Item.where(name: sheet[i+1][0].value).first #item
          if item.nil?
            p sheet[i+1][0].value
          end

          cell_value = sheet[i+1][j+1].value
          url = (item.nil? || site.nil?) ? nil : get_url(item, site)

          if !url.nil?
            url.url = cell_value #url
            url.site = Site.where(name: site.name).first

            if !item.sites.include?(url.site)
              item.sites << url.site
              item.save
            end
            if !url.site.items.include?(item)
              url.site << item
              url.site.save
            end
            if !url.site.groups.include?(item.group)
              url.site.groups << item.group
              url.site.save
            end
            a += 1
            url.save


            if url.site.name == "ydachnik.by"
              puts "----"
              puts url.id, url.item.name, cell_value
              p url.site.urls.find(url.id).url
              p url.item.urls.find(url.id).url, url.url
              puts "----"
            end

            if url.url == "X" || url.url == "[]" || url.url.nil?
              site.urls -=[url]
              item.urls -=[url]
              url.delete
            end

          else

            if !(cell_value == "X" || cell_value == "[]" || cell_value.nil?)
              url = Url.new
              url.site = site
              url.item = item
              url.url = cell_value
              url.save
            end

          end

        end
      end

    end

    # Url.all.each do |url|
    #       if !url.site.groups.include?(url.item.group)
    #         url.site.groups << url.item.group
    #         url.site.save
    #       end
    #     end

    p a
    p "Finished"
    redirect_to sites_path, notice: "Импортировано"
  end

  def generate_first_row (sites)
    cells = []
    sites.each do |site|
      cells << site.name
    end
    return cells
  end

  def generate_cells(item, sites)
    cells = []
    sites.each do |site|
      url = (site.urls & item.urls).first
      new_cell = url.nil? ? [] : url.url
      cells << new_cell
    end
    return cells
  end

  def generate_types(item, sites, ok, repeat, wrong)
    types = []
    types << ok
    standard_site = sites[0].groups[0].sites.where(standard: true).first
    standard_price = get_price(item, standard_site)
    standard_url = get_url(item, standard_site)
    sites.each do |site|
      url = (site.urls & item.urls).first
      if !url.nil? && !url.price.nil? && !standard_price.nil?
        if (((standard_price - url.price)/standard_price).abs > 0.3)
          new_type = wrong
        else
          new_type = ok
        end
      else
        new_type = ok
      end

      types << new_type
    end
    return types
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_site
    @site = Site.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def site_params
    params.require(:site).permit!#(:name, :regexp, :standard, :company_name, :out_of_ban_time, :email, urls: :url, :items)
  end
end
