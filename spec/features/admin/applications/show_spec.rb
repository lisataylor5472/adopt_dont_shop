require 'rails_helper'

RSpec.describe 'admin show page' do
  before :each do
    @shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: true, rank: 9)
    @pet_1 = Pet.create!(adoptable: true, age: 2, breed: 'domestic short hair', name: 'Mundungous', shelter_id: @shelter_1.id)
    @pet_2 = Pet.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Captain Pants', shelter_id: @shelter_1.id)
    @pet_3 = Pet.create!(adoptable: true, age: 1, breed: 'domestic short hair', name: 'Billy', shelter_id: @shelter_1.id)

    @application_1 = Application.create!(name: "Holden Caulfield", street_address: "123 Main St", city: "Denver", state: "CO", zipcode: 80216, description: "I wouldn't be a good pet owner", status: "Pending")

    @pet_app_1 = PetApplication.create!(pet: @pet_1, application: @application_1)
    @pet_app_2 = PetApplication.create!(pet: @pet_2, application: @application_1)
    @pet_app_3 = PetApplication.create!(pet: @pet_3, application: @application_1)
  end

  it 'lists all pet applications' do
    visit "/admin/applications/#{@application_1.id}"

    expect(page).to have_content(@pet_1.name)
    expect(page).to have_content(@pet_2.name)
    expect(page).to have_content(@pet_3.name)
  end

  it 'has an approve / reject button next to all pending pet apps' do
    visit "/admin/applications/#{@application_1.id}"

    within("#pet_apps-#{@pet_app_1.id}") do
      expect(page).to have_button("Approve")
      expect(page).to have_button("Reject")
    end
  end

  xit 'approve / reject buttons update status' do
    visit "/admin/applications/#{@application_1.id}"

    within("#pet_apps-#{@pet_app_1.id}") do
      expect(@pet_app_1.application.status).to eq("Pending")
      click_button "Approve"
      expect(current_path).to eq("/admin/applications/#{@application_1.id}")
      expect(PetApplication.find(@pet_app_1.id).status).to eq("Approved")
      expect(page).to_not have_button("Approve")
      expect(page).to have_content("Approved")
    end

    within("div.pet_#{@pet_app_2.id}") do
      expect(@pet_app_2.status).to eq("Pending")
      click_button "Reject"
      expect(current_path).to eq("/admin/applications/#{@application_1.id}")
      expect(PetApplication.find(@pet_app_2.id).status).to eq("Rejected")
      expect(page).to_not have_button("Reject")
      expect(page).to have_content("Rejected")
    end
  end
end
