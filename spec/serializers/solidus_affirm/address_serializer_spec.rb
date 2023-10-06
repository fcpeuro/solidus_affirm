require 'spec_helper'

RSpec.describe SolidusAffirm::AddressSerializer do
  let(:address) { create(:address, firstname: "John", lastname: "Do", zipcode: "58451") }
  let(:serializer) { SolidusAffirm::AddressSerializer.new(address, root: false) }
  subject { JSON.parse(serializer.to_json) }

  describe "name" do
    it "will be a composition with first -and lastname" do
      name_json = { "first" => "John", "last" => "Do" }
      expect(subject["name"]).to eql name_json
    end
  end

  describe "address" do
    it "will be a composition with the address fields" do
      address_json = {
        "line1" => "10 Lovely Street",
        "line2" => "Northwest",
        "city" => "Herndon",
        "state" => "AL",
        "zipcode" => "58451",
        "country" => "USA"
      }
      expect(subject["address"]).to eql address_json
    end
  end

  context "with apostrophes in first or lastname" do
    let(:address) { create(:address, firstname: "John's", lastname: "D'o", zipcode: "58451") }
    it "will serialize correctly" do
      name_json = { "first" => "John's", "last" => "D'o" }
      expect(subject["name"]).to eql name_json
    end
  end

  # This is a regression test that was added because previously the address
  # serializer would error when the state was nil.
  context "the country doesn't have states" do
    let(:country) { create(:country, iso3: "VAT", states_required: false) }
    let(:address) { create(:address, country: country, state: nil, zipcode: 10001) }

    it "serializes the address" do
      address_json = {
        "line1" => "10 Lovely Street",
        "line2" => "Northwest",
        "city" => "Herndon",
        "state" => nil,
        "zipcode" => "10001",
        "country" => "VAT"
      }
      expect(subject["address"]).to eql address_json
    end
  end
end
