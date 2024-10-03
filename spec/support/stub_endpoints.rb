def stub_list_endpoint(endpoint, api_key, query_string = "")
  stub_request(:get, "https://api.breathehr.com/v1/#{endpoint}#{query_string}")
    .to_return(
      body: JSON.parse(File.read(File.join("spec", "fixtures", "#{endpoint}.json"))).to_json,
      headers: {
        "Content-Type" => "application/json",
        "X-Api-Key" => api_key,
        "Link" => "<https://api.breathehr.com/v1/#{endpoint}?page=1>; rel=\"first\", <https://api.breathehr.com/v1/#{endpoint}?page=1>; rel=\"prev\", <https://api.breathehr.com/v1/#{endpoint}?page=22>; rel=\"last\", <https://api.breathehr.com/v1/#{endpoint}?page=2>; rel=\"next\""
      }
    )
end

def stub_get_endpoint(endpoint, api_key, id)
  stub_request(:get, "https://api.breathehr.com/v1/#{endpoint}/#{id}")
    .to_return(
      body: JSON.parse(File.read(File.join("spec", "fixtures", "#{endpoint}.json"))).to_json,
      headers: {
        "Content-Type" => "application/json",
        "X-Api-Key" => api_key
      }
    )
end
