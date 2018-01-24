class DevicesController < ApplicationController
  before_action :set_device, only: [:show, :edit, :update, :destroy]

  # GET /devices
  # GET /devices.json
  def index
    @devices = Device.all
  end

  # GET /devices/1
  # GET /devices/1.json
  def show
    respond_to do |format|
      format.html { render layout: !request.xhr? }
    end
  end

  # GET /devices/new
  def new
    @device = Device.new
  end

  # GET /devices/1/edit
  def edit
    @device = Device.preload(:datatypes).find(params[:id])
  end

  # POST /devices
  # POST /devices.json
  def create
    @device = Device.new(device_params)

    respond_to do |format|
      if @device.save
        $query_scheduler.every( "#{@device.query_interval}s", tag: @device.id ) do
          Rails.logger.info "Hello, it's #{Time.now}"
          Rails.logger.info "I'm gonna go and query #{@device.address}, if you don't mind."
          Rails.logger.flush
          SnmpWorkerJob.perform_later(@device)
        end

        format.html { redirect_to @device, notice: 'Device was successfully created.' }
        format.json { render :show, status: :created, location: @device }
      else
        format.html { render :new }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /devices/1
  # PATCH/PUT /devices/1.json
  def update
    respond_to do |format|
      if @device.update(device_params)
        $query_scheduler.jobs(tag: @device.id).each do |job|
          Rails.logger.info "Updated device with ID: #{@device.id}, killing query job #{job.id}..."
          Rails.logger.flush
          job.unschedule
          Rails.logger.info 'Job killed, now off to rescheduling~'
          Rails.logger.flush
        end
        $query_scheduler.every( "#{@device.query_interval}s", tag: @device.id ) do
          Rails.logger.info "#{Time.now}: Querying #{@device.address}..."
          Rails.logger.flush
          SnmpWorkerJob.perform_later(@device)
        end

        format.html { redirect_to @device, notice: 'Device was successfully updated.' }
        format.json { render :show, status: :ok, location: @device }
      else
        format.html { render :edit }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /devices/1
  # DELETE /devices/1.json
  def destroy
    $query_scheduler.jobs(tag: @device.id).each do |job|
      Rails.logger.info "Destroyed device with ID: #{@device.id}."
      Rails.logger.info "Killing query job with ID: #{job.id}."
      job.unschedule
      Rails.logger.info 'Job killed, RIP~'
    end
    @device.destroy
    respond_to do |format|
      format.html { redirect_to devices_url, notice: 'Device was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_device
      @device = Device.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def device_params
      params.require(:device).permit(:devname, :city, :contact, :group, :address, :snmp_community, :query_interval, :datatype_ids)
    end
end
