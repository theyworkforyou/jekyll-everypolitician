require 'test_helper'

class Jekyll::EverypoliticianTest < Minitest::Test
  def site
    @site ||= Jekyll::Site.new(Jekyll.configuration).tap do |s|
      s.config['everypolitician_url'] = 'test/fixtures/ep-popolo-v1.0.json'
    end
  end

  def setup
    Jekyll::Everypolitician::Generator.new.generate(site)
  end

  def test_that_it_has_a_version_number
    refute_nil ::Jekyll::Everypolitician::VERSION
  end

  def test_it_creates_collections_from_popolo
    assert_equal 50, site.collections['persons'].docs.size
    assert_equal 16, site.collections['organizations'].docs.size
    assert_equal 3, site.collections['events'].docs.size
    assert_equal 0, site.collections['areas'].docs.size
  end
end
