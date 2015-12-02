require 'test_helper'

class Jekyll::EverypoliticianTest < Minitest::Test
  def site
    @site ||= Jekyll::Site.new(Jekyll.configuration)
  end

  def test_that_it_has_a_version_number
    refute_nil ::Jekyll::Everypolitician::VERSION
  end

  def generate_with_single_source
    site.config['everypolitician'] = {
      'sources' => ['test/fixtures/ep-popolo-v1.0.json']
    }
    Jekyll::Everypolitician::Generator.new(site.config).generate(site)
  end

  def test_it_creates_collections_from_popolo
    generate_with_single_source
    assert_equal 50, site.collections['persons'].docs.size
    assert_equal 16, site.collections['organizations'].docs.size
    assert_equal 3, site.collections['events'].docs.size
    assert_equal 0, site.collections['areas'].docs.size
  end

  def test_it_uses_default_layout
    generate_with_single_source
    person = site.collections['persons'].docs.first
    assert_nil person.data['layout']
  end

  def test_collection_name_layout_used_if_available
    site.layouts['persons'] = Jekyll::Layout.new(site, 'persons.html', '_layouts')
    generate_with_single_source
    person = site.collections['persons'].docs.first
    assert_equal 'persons', person.data['layout']
  end

  def test_missing_configuration
    Jekyll::Everypolitician::Generator.new(site.config).generate(site)
    assert_nil site.collections['persons']
  end
end
