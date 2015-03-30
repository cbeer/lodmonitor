class Check::ContentNegotiable < Check

  RSpec.shared_examples "a content-negotiable service" do
    let(:conn) { Faraday.new(url: subject.url) }

    it "has an HTML description of the resource" do
      resp = conn.get do |req|
        req.headers['Accept'] = "application/xhtml+xml,text/html"
      end

      expect(resp.headers['Content-Type']).to include "html"
      expect(resp.body).to match /<html/
    end
  end

  def group
    describe_resource do
      it_behaves_like "a content-negotiable service"
    end
  end
end