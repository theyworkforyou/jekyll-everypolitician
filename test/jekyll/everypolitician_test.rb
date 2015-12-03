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

  def generate_with_source_hash
    site.config['everypolitician'] = {
      'sources' => {
        'assembly' => 'test/fixtures/ep-popolo-v1.0.json'
      }
    }
    Jekyll::Everypolitician::Generator.new(site.config).generate(site)
  end

  def test_it_creates_collections_from_popolo
    generate_with_single_source
    assert_equal 50, site.collections['people'].docs.size
    assert_equal 16, site.collections['organizations'].docs.size
    assert_equal 3, site.collections['events'].docs.size
    assert_equal 0, site.collections['areas'].docs.size
  end

  def test_it_uses_default_layout
    generate_with_single_source
    person = site.collections['people'].docs.first
    assert_nil person.data['layout']
  end

  def test_collection_name_layout_used_if_available
    site.layouts['people'] = Jekyll::Layout.new(site, 'people.html', '_layouts')
    generate_with_single_source
    person = site.collections['people'].docs.first
    assert_equal 'people', person.data['layout']
  end

  def test_missing_configuration
    Jekyll::Everypolitician::Generator.new(site.config).generate(site)
    assert_nil site.collections['people']
  end

  def test_sources_hash
    generate_with_source_hash
    assert_equal 50, site.collections['assembly_people'].docs.size
    assert_equal 16, site.collections['assembly_organizations'].docs.size
    assert_equal 3, site.collections['assembly_events'].docs.size
    assert_equal 0, site.collections['assembly_areas'].docs.size
  end

  def test_data_is_added_to_each_doc
    generate_with_single_source
    person = site.collections['people'].docs.first
    assert_equal 'Alain FICINI', person['name']
    assert_equal 'a.ficini@conseil-national.mc', person['email']
  end

  def test_name_is_copied_to_title
    generate_with_single_source
    person = site.collections['people'].docs.first
    assert_equal person['name'], person['title']
  end

  def test_memberships_are_copied_to_items
    generate_with_single_source
    person = site.collections['people'].docs.first
    assert_equal 1, person['memberships'].size
    membership = person['memberships'].first
    assert_equal person['id'], membership['person_id']
    assert_equal person, membership['person']
  end

  def test_generator_has_high_priority
    assert_equal :high, Jekyll::Everypolitician::Generator.priority
  end

  def test_falls_back_to_collection_name_layout
    site.layouts['people'] = Jekyll::Layout.new(site, 'people.html', '_layouts')
    generate_with_source_hash
    person = site.collections['assembly_people'].docs.first
    assert_equal 'people', person.data['layout']
  end
end
