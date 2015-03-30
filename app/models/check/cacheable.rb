class Check::Cacheable < Check

  RSpec.shared_examples "a cacheable service" do
    let(:conn) { Faraday.new(url: subject.url) }

    let(:headers) { conn.get.headers }

    it "has a cache-control header" do
      expect(headers).to include "cache-control"
    end
    
    it "has either an etag or last-modified header" do
      if headers["etag"]
        expect(headers).to include "etag"
      elsif headers["last-modified"]
        expect(headers).to include "last-modified"
      else
        expect(headers).to include "etag", "last-modified"
      end
    end
  end

  def group
    describe_resource do
      it_behaves_like "a cacheable service"
    end
  end
end