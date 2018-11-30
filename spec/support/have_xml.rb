# Pasted from https://github.com/salesking/sepa_king/blob/fdfef53c3a686a76a32c4b540c72a5220e21e6d0/spec/support/custom_matcher.rb#L18
RSpec::Matchers.define :have_xml do |xpath, text|
  match do |actual|
    doc = Nokogiri::XML(actual)
    doc.remove_namespaces! # so we can use shorter xpath's without any namespace

    nodes = doc.xpath(xpath)
    expect(nodes).not_to be_empty
    if text
      nodes.each do |node|
        if text.is_a?(Regexp)
          expect(node.content).to match(text)
        else
          expect(node.content).to eq(text)
        end
      end
    end
    true
  end
end