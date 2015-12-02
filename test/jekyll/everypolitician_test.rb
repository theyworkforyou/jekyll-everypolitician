require 'test_helper'

class Jekyll::EverypoliticianTest < Minitest::Test
  def site
    @site ||= Jekyll::Site.new(Jekyll.configuration)
  end

  def test_that_it_has_a_version_number
    refute_nil ::Jekyll::Everypolitician::VERSION
  end

  def test_it_creates_collections_from_popolo
    site.config['everypolitician_url'] = 'test/fixtures/ep-popolo-v1.0.json'
    Jekyll::Everypolitician::Generator.new(site.config).generate(site)
    assert_equal 50, site.collections['persons'].docs.size
    assert_equal 16, site.collections['organizations'].docs.size
    assert_equal 3, site.collections['events'].docs.size
    assert_equal 0, site.collections['areas'].docs.size
  end

  def test_it_uses_default_layout
    site.config['everypolitician_url'] = 'test/fixtures/ep-popolo-v1.0.json'
    Jekyll::Everypolitician::Generator.new(site.config).generate(site)
    person = site.collections['persons'].docs.first
    assert_nil person.data['layout']
  end

  def test_collection_name_layout_used_if_available
    site.config['everypolitician_url'] = 'test/fixtures/ep-popolo-v1.0.json'
    site.layouts['persons'] = Jekyll::Layout.new(site, 'persons.html', '_layouts')
    Jekyll::Everypolitician::Generator.new(site.config).generate(site)
    person = site.collections['persons'].docs.first
    assert_equal 'persons', person.data['layout']
  end
end
