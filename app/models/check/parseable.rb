class Check::Parseable < Check
  XHTML_STYLESHEET = RDF::Resource.new("http://www.w3.org/1999/xhtml/vocab#stylesheet")

  RSpec.shared_examples "a parseable graph" do
    let(:graph) { RDF::Graph.load(subject.url) }

    it "should be an rdf graph" do
      expect(graph).to be_a_kind_of(RDF::Graph)
    end

    it "should not contain (X)HTML predicates" do
      expect(graph).not_to have_predicate XHTML_STYLESHEET
      expect(graph).not_to have_predicate RDF::XHTML.stylesheet
    end
  end

  def group
    RSpec.describe resource do
      it_behaves_like "a parseable graph"
    end
  end
end