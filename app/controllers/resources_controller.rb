class ResourcesController < ApplicationController
  before_action :set_resource, except: [:create, :show]

  def check
    @resource.check!
    redirect_to @resource.host
  end

  # GET /resources/1/edit
  def edit
  end

  # GET /resources?resource[url]=http... | POST /resources
  def show
    @resource = Resource.new(resource_params)

    respond_to do |format|
      if @resource.save
        @resource.check!
        format.html { render :show }
      else
        format.html { redirect_to root_url, notice: "Unable to check resource" }
      end
    end
  end
  
  alias_method :create, :show

  # PATCH/PUT /resources/1
  # PATCH/PUT /resources/1.json
  def update
    respond_to do |format|
      if @resource.update(resource_params)
        format.html { redirect_to @resource.host, notice: 'Resource was successfully updated.' }
        format.json { render :show, status: :ok, location: @resource.host }
      else
        format.html { render :edit }
        format.json { render json: @resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /resources/1
  # DELETE /resources/1.json
  def destroy
    @resource.destroy
    respond_to do |format|
      format.html { redirect_to @resource.host, notice: 'Resource was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resource
      @resource = Resource.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def resource_params
      params.require(:resource).permit(:url, :checks)
    end
end
