require 'jekyll/everypolitician/version'

require 'json'
require 'open-uri'

require 'jekyll'

module Jekyll
  module Everypolitician
    class PopoloFetcher
      COLLECTION_MAPPING = {
        'persons' => 'people'
      }

      attr_reader :site

      def initialize(site)
        @site = site
      end

      def read!
        return unless site.config.key?('everypolitician')
        sources = site.config['everypolitician']['sources']
        if sources.is_a?(Array)
          generate_collections(sources.first)
        elsif sources.is_a?(Hash)
          sources.each do |prefix, source|
            generate_collections(source, prefix)
          end
        end
      end

      def generate_collections(source, prefix = nil)
        popolo = JSON.parse(open(source).read)
        memberships = popolo['memberships']
        popolo.each do |type, records|
          next unless records.is_a?(Array)
          collection_name = collection_name_for(type, prefix)
          collection = Collection.new(site, collection_name)
          records.each do |item|
            next unless item['id']
            path = File.join(site.source, "_#{collection_name}", "#{Jekyll::Utils.slugify(item['id'])}.md")
            doc = Document.new(path, collection: collection, site: site)
            doc.merge_data!(item)
            doc.merge_data!(
              'title' => item['name'],
              'memberships' => memberships_for(item, type, memberships)
            )
            if site.layouts.key?(collection_name)
              doc.merge_data!('layout' => collection_name)
            elsif site.layouts.key?(collection_name_for(type))
              doc.merge_data!('layout' => collection_name_for(type))
            end
            collection.docs << doc
          end
          site.collections[collection_name] = collection
        end

        membership_mapping = [
          { key: 'person', kind: 'persons', id: 'person_id' },
          { key: 'area', kind: 'areas', id: 'area_id' },
          { key: 'legislative_period', kind: 'events', id: 'legislative_period_id' },
          { key: 'organization', kind: 'organizations', id: 'organization_id' },
          { key: 'party', kind: 'organizations', id: 'on_behalf_of_id' }
        ]
        memberships.each do |membership|
          membership_mapping.each do |mapping|
            collection = site.collections[collection_name_for(mapping[:kind], prefix)]
            membership[mapping[:key]] = collection.docs.find do |doc|
              doc.data['id'] == membership[mapping[:id]]
            end
          end
        end
      end

      def collection_name_for(type, prefix = nil)
        name = COLLECTION_MAPPING[type] || type
        if prefix
          [prefix, name].join('_')
        else
          name
        end
      end

      def memberships_for(item, type, memberships)
        map = {
          'areas' => 'area_id',
          'persons' => 'person_id',
          'events' => 'legislative_period_id',
          'organizations' => 'on_behalf_of_id'
        }
        memberships.find_all { |m| m[map[type]] == item['id'] }
      end
    end
  end
end

Jekyll::Hooks.register :site, :post_read do |site|
  Jekyll::Everypolitician::PopoloFetcher.new(site).read!
end
