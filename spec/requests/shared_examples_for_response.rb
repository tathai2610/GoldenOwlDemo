RSpec.shared_examples "successful response" do
  it "returns a 200 response" do
    subject 
    expect(response).to have_http_status "200"
  end
end

RSpec.shared_examples "redirect response" do 
  it "returns a 302 response" do 
    subject 
    expect(response).to have_http_status "302"
  end
end

RSpec.shared_examples "unauthenticated response" do 
  it "returns a 302 response" do 
    subject 
    expect(response).to have_http_status "302"
  end

  it "redirects to login page" do 
    subject 
    expect(response).to redirect_to "/users/sign_in"
  end
end

