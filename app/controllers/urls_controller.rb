#coding: utf-8
require 'open-uri'

class UrlsController < ApplicationController
  before_action :set_url, only: [:show, :edit, :update, :destroy]

  # GET /urls
  # GET /urls.json
  def index
    @urls = Url.all
  end

  # GET /urls/1
  # GET /urls/1.json
  def show
  end

  # GET /urls/new
  def new
    @url = Url.new
  end

  # GET /urls/1/edit
  def edit
  end

  # POST /urls
  # POST /urls.json
  def create
    @url = Url.new(url_params)

    respond_to do |format|
      if @url.save
        format.html { redirect_to @url, notice: 'Url was successfully created.' }
        format.json { render action: 'show', status: :created, location: @url }
      else
        format.html { render action: 'new' }
        format.json { render json: @url.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /urls/1
  # PATCH/PUT /urls/1.json
  def update
    respond_to do |format|
      if @url.update(url_params)
        format.html { redirect_to @url, notice: 'Url was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @url.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /urls/1
  # DELETE /urls/1.json
  def destroy
    @url.destroy
    respond_to do |format|
      format.html { redirect_to urls_url }
      format.json { head :no_content }
    end
  end

  def update_prices
    urls = Url.all
    urls.each do |url|
      #logger.error(url.id)
      #if url.id == 1584
      regexp = url.site.regexp
      text = open(url.url).read.encode('UTF-8', {:invalid => :replace, :undef => :replace, :replace => '-'})
      refined_regexp = refine (regexp)

      res = text.scan(refined_regexp)
      if !res.empty?
        #debugger
        result = res.first.first.gsub("&nbsp;", "").gsub(" ", "").to_i
        url.price = result
        url.save
      end
      logger.error (url.url)
      logger.error(regexp)
      logger.error(res)
      logger.error("\n")
    end
    update_violators
    redirect_to urls_path
  end

  def test_regexp
    @url = Url.where(:id => params[:url_id]).first
    @regexp = @url.site.regexp

    url = @url.url
    page = open(url)
    text = page.read.encode("utf-8")

    @refined_regexp = refine (@regexp).encode("utf-8")

    @res = text.scan(@refined_regexp)
    # debugger
    if !res.nil?
      @result = @res.first.first.gsub(" ", "").to_f
      @url.price = @result
      @url.save
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.

  def update_violators

  end

  def refine (regexp)
    # debugger
    return Regexp.new (regexp.encode("utf-8").gsub("\\", ""))
  end


  def set_url
    @url = Url.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def url_params
    params.require(:url).permit(:url, :price)
  end


end
