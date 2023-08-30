class Api::GeospatialController < ActionController::API
  before_action :authenticate_request, only: :create

  def create
    json_data = JSON.parse(request.body.read)

    # Extract the necessary attributes from the JSON
    ticket_attributes = extract_ticket_attributes(json_data)
    excavator_attributes = extract_excavator_attributes(json_data)

    begin
      ticket = Ticket.create(ticket_attributes)
    rescue StandardError => e
      render json: { status: 'error', message: 'Failed to create Ticket', response: e.message }, status: :unprocessable_entity
      return
    end

    begin
      excavator = Excavator.create(excavator_attributes.merge!(ticket_id: ticket.id))
    rescue StandardError => e
      render json: { status: 'error', message: 'Failed to create Excavator', response: e.message }, status: :unprocessable_entity
      return
    end

    render json: { message: "Data successfully created for Ticket and Excavator" }
  end

  private

  def authenticate_request
    token = request.headers['Authorization']
    render_unauthorized unless valid_token?(token)
  end

  def valid_token?(token)
    token == ENV['API_TOKEN']
  end

  def render_unauthorized
    render json: { error: 'You are Unauthorized to access this endpoint' }, status: :unauthorized
  end

  def extract_ticket_attributes(json_data)
    {
      request_number: json_data["RequestNumber"],
      sequence_number: json_data["SequenceNumber"],
      request_type: json_data["RequestType"],
      request_action: json_data["RequestAction"],
      response_due_date: json_data["DateTimes"]["ResponseDueDateTime"],
      primary_service_area_code: json_data["ServiceArea"]["PrimaryServiceAreaCode"]["SACode"],
      additional_service_area_codes: json_data["ServiceArea"]["AdditionalServiceAreaCodes"]["SACode"],
      digsite_info: json_data["ExcavationInfo"]["DigsiteInfo"]["WellKnownText"]
    }
  end

  def extract_excavator_attributes(json_data)
    excavator_data = json_data["Excavator"]
    {
      company_name: excavator_data["CompanyName"],
      contact_name: excavator_data["Contact"]["Name"],
      phone_no: excavator_data["Contact"]["Phone"],
      email: excavator_data["Contact"]["Email"],
      address: excavator_data["Address"],
      city: excavator_data["City"],
      state: excavator_data["State"],
      zip: excavator_data["Zip"],
      crew_on_site: excavator_data["CrewOnsite"]
    }
  end

end
