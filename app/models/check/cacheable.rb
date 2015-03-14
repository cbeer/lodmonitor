class Check::Cacheable < Check

  RSpec.shared_examples "a cache-prepared service" do
    let(:conn) { Faraday.new(url: subject.url) }

    let(:headers) { conn.get.headers }

    it "should have cache control headers" do
      expect(headers).to include "cache-control"
    end
    
    it "should have etag or last-modified headers" do
      if headers["etag"]
        expect(headers).to include "etag"
      elsif headers["last-modified"]
        expect(headers).to include "last-modified"
      else
        expect(headers).to include "etag", "last-modified"
      end
    end

    it "should have last-modified headers" do
    end
  end

  def group
    describe_resource do
      it_behaves_like "a cache-prepared service"
    end
  end
end