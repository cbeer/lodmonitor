class Check::ContentNegotiable < Check

  RSpec.shared_examples "a content-negotiable service" do
    let(:conn) do
      Faraday.new(url: subject.url) do |b|
        b.use FaradayMiddleware::FollowRedirects
        b.adapter :net_http
      end
    end

    it "has an HTML description of the resource" do
      resp = conn.get do |req|
        req.headers['Accept'] = "application/xhtml+xml,text/html"
      end

      expect(resp.headers['Content-Type']).to include "html"
      expect(resp.body).to match /<html/
    end

    it "has an RDF description in a common serialization" do
      resp = conn.get do |req|
        req.headers['Accept'] = "application/n-triples, application/n-quads, text/x-nquads, application/ld+json, application/x-ld+json, application/rdf+json, text/n3, text/rdf+n3, application/rdf+n3, application/rdf+xml, application/trig, application/x-trig, application/trix, text/turtle, text/rdf+turtle, application/turtle, application/x-turtle"
      end

      expect(resp.headers['Content-Type']).not_to include "html"
      expect(resp.body).not_to match /<html/
    end

    it "supports q-values in content negotiation, so e.g a RDF serialization is prefered over text/html;q=0.5" do
      resp = conn.get do |req|
        req.headers['Accept'] = "application/n-triples, text/plain;q=0.5, application/n-quads, text/x-nquads, application/ld+json, application/x-ld+json, application/rdf+json, text/html;q=0.5, application/xhtml+xml, image/svg+xml, text/n3, text/rdf+n3, application/rdf+n3, application/rdf+xml, application/trig, application/x-trig, application/trix, text/turtle, text/rdf+turtle, application/turtle, application/x-turtle, */*;q=0.1"
      end

      expect(resp.headers['Content-Type']).not_to include "html"
      expect(resp.body).not_to match /<html/
    end
  end

  def group
    describe_resource do
      include_examples "a content-negotiable service"
    end
  end
end