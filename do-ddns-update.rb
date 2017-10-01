#!/usr/bin/env ruby

require 'droplet_kit'
require 'nokogiri'
require 'open-uri'
require 'pp'

TOKEN = '<token>'
DOMAIN = '<domain>'
RECORD = '<record>'
RECORD_TYPE  = '<record type>'

class DDNSClient
    attr_accessor :token
    attr_accessor :domain
    attr_accessor :record
    attr_accessor :record_name
    attr_accessor :record_type
    attr_accessor :doclient
    attr_accessor :check_ip_url
    attr_accessor :current_external_ip

    def initialize(token, domain, record_name, record_type)
        @check_ip_url = "http://checkip.dyndns.org:8245/"
        @current_external_ip = self.get_external_ip()

        @token = token
        @client = DropletKit::Client.new(access_token: @token)

        @domain =  domain
        @record_name =  record_name
        @record_type  = record_type.upcase()

        @record = self.get_record()
    end

    def get_external_ip()
        return @current_external_ip =  ((Nokogiri::HTML(open(@check_ip_url))).css('body').text).match(/\d.+/).to_s
    end

    def get_record()
        # Return a list of all records in a specific domain
        all_records = @client.domain_records.all(for_domain: @domain)
        # Loop through until we find a record that meets the requirements
        all_records.entries.each do |r|
            if r.type == @record_type && r.name == @record_name then
                return @record = r
            end
        end
        puts "Could not find a(n) #{@record_type} record: #{record_name} in the #{domain} domain"
        return nil
    end

    def update_record()
        updated_record = @record
        updated_record.data = self.current_external_ip
        @client.domain_records.update(updated_record, for_domain: @domain, id: @record.id)
    end
end

if __FILE__ == $0
    ddns = DDNSClient.new(TOKEN, DOMAIN, RECORD, RECORD_TYPE)
    if ddns.get_external_ip() != ddns.get_record()
        ddns.update_record()
    end
end
