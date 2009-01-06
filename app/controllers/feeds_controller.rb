class FeedsController < ApplicationController
  before_filter :login_required

  # GET /feeds
  # GET /feeds.xml
  def index
    @feeds = current_user.feeds

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @feeds }
    end
  end

  # GET /feeds/1
  # GET /feeds/1.xml
  def show
    @feed = current_user.feeds.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @feed }
    end
  end

  # GET /feeds/new
  # GET /feeds/new.xml
  def new
    @feed = current_user.feeds.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @feed }
    end
  end

  # GET /feeds/1/edit
  def edit
    @feed = current_user.feeds.find(params[:id])
  end

  # POST /feeds
  # POST /feeds.xml
  def create
    @feed = current_user.feeds.build(params[:feed])

    respond_to do |format|
      if @feed.save
        flash[:notice] = 'Feed was successfully created.'
        format.html { redirect_to reader_feed_path(@feed) }
        format.xml  { render :xml => @feed, :status => :created, :location => @feed }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @feed.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /feeds/1
  # PUT /feeds/1.xml
  def update
    @feed = current_user.feeds.find(params[:id])

    respond_to do |format|
      if @feed.update_attributes(params[:feed])
        flash[:notice] = 'Feed was successfully updated.'
        format.html { redirect_to reader_feed_path(@feed) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @feed.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /feeds/1
  # DELETE /feeds/1.xml
  def destroy
    @feed = current_user.feeds.find(params[:id])
    @feed.destroy

    respond_to do |format|
      format.html { redirect_to reader_feeds_path }
      format.xml  { head :ok }
    end
  end
end
