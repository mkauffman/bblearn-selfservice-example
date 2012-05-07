class CourseModelsController < ApplicationController
  # GET /course_models
  # GET /course_models.xml
  def index
    @course_models = CourseModel.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @course_models }
    end
  end

  # GET /course_models/1
  # GET /course_models/1.xml
  def show
    @course_model = CourseModel.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @course_model }
    end
  end

  # GET /course_models/new
  # GET /course_models/new.xml
  def new
    @course_model = CourseModel.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @course_model }
    end
  end

  # GET /course_models/1/edit
  def edit
    @course_model = CourseModel.find(params[:id])
  end

  # POST /course_models
  # POST /course_models.xml
  def create
    @course_model = CourseModel.new(params[:course_model])

    respond_to do |format|
      if @course_model.save
        format.html { redirect_to(@course_model, :notice => 'CourseModel was successfully created.') }
        format.xml  { render :xml => @course_model, :status => :created, :location => @course_model }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @course_model.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /course_models/1
  # PUT /course_models/1.xml
  def update
    @course_model = CourseModel.find(params[:id])

    respond_to do |format|
      if @course_model.update_attributes(params[:course_model])
        format.html { redirect_to(@course_model, :notice => 'CourseModel was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @course_model.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /course_models/1
  # DELETE /course_models/1.xml
  def destroy
    @course_model = CourseModel.find(params[:id])
    @course_model.destroy

    respond_to do |format|
      format.html { redirect_to(course_models_url) }
      format.xml  { head :ok }
    end
  end
end
