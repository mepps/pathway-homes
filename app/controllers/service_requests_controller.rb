class ServiceRequestsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @service_requests = ServiceRequest.all
  end

  def new
  end

  def edit
  end

  def create
    @service_request = ServiceRequest.new(service_request_params)
    @service_request.creator = current_user

    respond_to do |format|
      if @service_request.save
        format.json { render action: "show", status: :created }
      else
        format.json { render json: @service_request.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @service_request = ServiceRequest.find(params[:id])
    respond_to do |format|
      if @service_request.update(service_request_params)
        format.json { render action: "show" }
      else
        format.json { render json: @service_request.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @service_request = ServiceRequest.find(params[:id])
  end


  def export
    start_date = params[:start_date] || Date.new(2013)
    end_date = params[:end_date] || Date.today
    service_requests = ServiceRequest.includes(:notes, :request_type)
                        .where('created_at >= ? AND created_at <= ?', start_date, end_date)

    send_data(service_requests.to_csv, :type => 'text/csv', :filename => 'service_requests.csv')
  end


  private
  def service_request_params
    params.require(:service_request).permit(
      :community_name, :apt_number, :work_desc, :special_instructions, :alarm,
      :community_street_address, :community_zip_code, :pet,
      :authorized_to_enter, :request_type_id
    )
  end
end
