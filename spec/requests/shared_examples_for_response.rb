RSpec.shared_examples "successful response" do
  it "returns a OK response" do
    subject 
    expect(response).to have_http_status :ok
  end
end

RSpec.shared_examples "redirect response" do 
  it "returns a redirect response" do 
    subject 
    expect(response).to have_http_status :found
  end
end

RSpec.shared_examples "unauthorized redirect response" do 
  it "returns a redirect response" do
    subject 
    expect(response).to have_http_status :found
  end

  it "redirects to homepage" do 
    subject 
    expect(response).to redirect_to root_path
  end
end

