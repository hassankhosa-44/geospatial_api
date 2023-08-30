require 'test_helper'

class Api::GeospatialControllerTest < ActionDispatch::IntegrationTest
  TOKEN = ENV['API_TOKEN']
  test "should create ticket and excavator" do
    headers = {
      'Authorization' => TOKEN,
      'Content-Type' => 'application/json'
    }

    post '/api/sync', params: json_data.to_json, headers: headers


    assert_response :success
    assert_equal "Data successfully created for Ticket and Excavator", response.parsed_body["message"]

    ticket = Ticket.last
    excavator = Excavator.last

    assert_equal "09252012-00001", ticket.request_number
    assert_equal "2421", ticket.sequence_number
    assert_equal "Normal", ticket.request_type
    assert_equal "Restake", ticket.request_action
    assert_equal "ZZGL103", ticket.primary_service_area_code
    assert_equal "POLYGON((-81.13390268058475 32.07206917625161,-81.14660562247929 32.04064386441295,-81.08858407706913 32.02259853170128,-81.05322183341679 32.02434500961698,-81.05047525138554 32.042681017283066,-81.0319358226746 32.06537765335268,-81.01202310294804 32.078469305179404,-81.02850259513554 32.07963291684719,-81.07759774894413 32.07090546831167,-81.12154306144413 32.08806865844325,-81.13390268058475 32.07206917625161))", ticket.digsite_info

    assert_equal "John Doe CONSTRUCTION", excavator.company_name
    assert_equal "Johnny Doe", excavator.contact_name
    assert_equal 1115552345, excavator.phone_no
    assert_equal "example@example.com", excavator.email
    assert_equal "555 Some RD", excavator.address
    assert_equal "SOME PARK", excavator.city
    assert_equal "ZZ", excavator.state
    assert_equal 55555, excavator.zip
    assert_equal true, excavator.crew_on_site
  end

  test "should render unauthorized error without valid token" do
    headers = {
      'Authorization' => 'invalid_token',
      'Content-Type' => 'application/json'
    }

    post '/api/sync', params: json_data.to_json, headers: headers

    assert_response :unauthorized
    assert_equal "You are Unauthorized to access this endpoint", response.parsed_body["error"]
  end

  test "should render error when creating ticket fails" do
    headers = {
      'Authorization' => TOKEN,
      'Content-Type' => 'application/json'
    }

    Ticket.stub(:create, -> (_) { raise StandardError.new("Failed to create Ticket") }) do
      post '/api/sync', params: json_data.to_json, headers: headers

      assert_response :unprocessable_entity
      assert_equal "Failed to create Ticket", response.parsed_body["message"]
    end
  end

  test "should render error when creating excavator fails" do
    excavator = excavators(:one)
    # Send an email that is already present so that it fails
    data = json_data(excavator.email)
    headers = {
      'Authorization' => TOKEN,
      'Content-Type' => 'application/json'
    }

    post '/api/sync', params: data.to_json, headers: headers

    assert_response :unprocessable_entity

    assert_equal "Failed to create Excavator", response.parsed_body["message"]
  end

	def json_data(email = "example@example.com")
 		{
      "RequestNumber": "09252012-00001",
      "SequenceNumber": "2421",
      "RequestType": "Normal",
      "RequestAction": "Restake",
      "DateTimes": {
        "ResponseDueDateTime": "2011/07/13 23:59:59"
      },
      "ServiceArea": {
        "PrimaryServiceAreaCode": {
          "SACode": "ZZGL103"
        },
        "AdditionalServiceAreaCodes": {
          "SACode": [
            "ZZL01",
            "ZZL02",
            "ZZL03"
          ]
        }
      },
      "ExcavationInfo": {
        "DigsiteInfo": {
          "WellKnownText": "POLYGON((-81.13390268058475 32.07206917625161,-81.14660562247929 32.04064386441295,-81.08858407706913 32.02259853170128,-81.05322183341679 32.02434500961698,-81.05047525138554 32.042681017283066,-81.0319358226746 32.06537765335268,-81.01202310294804 32.078469305179404,-81.02850259513554 32.07963291684719,-81.07759774894413 32.07090546831167,-81.12154306144413 32.08806865844325,-81.13390268058475 32.07206917625161))"
        }
      },
      "Excavator": {
        "CompanyName": "John Doe CONSTRUCTION",
        "Contact": {
          "Name": "Johnny Doe",
          "Phone": "1115552345",
          "Email": email
        },
        "Address": "555 Some RD",
        "City": "SOME PARK",
        "State": "ZZ",
        "Zip": "55555",
        "CrewOnsite": "true"
      }
    }		
	end  
end
