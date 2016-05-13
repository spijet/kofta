class DatatypesController < ApplicationController
  before_action :set_datatype, only: [:show, :edit, :update, :destroy]

  # GET /datatypes
  # GET /datatypes.json
  def index
    @datatypes = Datatype.all
  end

  # GET /datatypes/1
  # GET /datatypes/1.json
  def show
    respond_to do |format|
      format.html { render layout: !request.xhr? }
    end
  end

  # GET /datatypes/new
  def new
    @datatype = Datatype.new
  end

  # GET /datatypes/1/edit
  def edit
  end

  # POST /datatypes
  # POST /datatypes.json
  def create
    @datatype = Datatype.new(datatype_params)

    respond_to do |format|
      if @datatype.save
        format.html { redirect_to @datatype, notice: 'Datatype was successfully created.' }
        format.json { render :show, status: :created, location: @datatype }
      else
        format.html { render :new }
        format.json { render json: @datatype.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /datatypes/1
  # PATCH/PUT /datatypes/1.json
  def update
    respond_to do |format|
      if @datatype.update(datatype_params)
        format.html { redirect_to @datatype, notice: 'Datatype was successfully updated.' }
        format.json { render :show, status: :ok, location: @datatype }
      else
        format.html { render :edit }
        format.json { render json: @datatype.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /datatypes/1
  # DELETE /datatypes/1.json
  def destroy
    @datatype.destroy
    respond_to do |format|
      format.html { redirect_to datatypes_url, notice: 'Datatype was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_datatype
      @datatype = Datatype.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def datatype_params
      params.require(:datatype).permit(:name, :oid, :metric_type, :excludes, :table, :index_oid)
    end
end
