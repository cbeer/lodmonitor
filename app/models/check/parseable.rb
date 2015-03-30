class Check::Parseable < Check
  XHTML_STYLESHEET = RDF::Resource.new("http://www.w3.org/1999/xhtml/vocab#stylesheet")

  RSpec.shared_examples "an RDF resource graph" do
    let(:graph) { RDF::Graph.load(subject.url) }

    it "has a RDF graph" do
      expect(graph).to be_a_kind_of(RDF::Graph)
      expect(graph).not_to be_blank
    end

    it "does not contain (X)HTML predicates (possibly indicating bad content negotiation)" do
      expect(graph).not_to have_predicate XHTML_STYLESHEET
      expect(graph).not_to have_predicate RDF::XHTML.stylesheet
    end
  end

  def group
    describe_resource do
      it_behaves_like "an RDF resource"
    end
  end
end