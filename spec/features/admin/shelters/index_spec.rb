require 'rails_helper'

RSpec.describe 'the admin/shelter index' do
  it '/admin/shelters index lists shelters in descending order' do
    shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: true, rank: 9)
    shelter_2 = Shelter.create!(name: 'Denver shelter', city: 'Denver, CO', foster_program: true, rank: 9)
    shelter_3 = Shelter.create!(name: 'Maxfund', city: 'Denver, CO', foster_program: true, rank: 9)

    visit "/admin/shelters"

    within('#shelter_name-0') do
      expect(page).to have_content(shelter_3.name)
    end
    within('#shelter_name-1') do
      expect(page).to have_content(shelter_2.name)
    end
    within('#shelter_name-2') do
      expect(page).to have_content(shelter_1.name)
    end
  end

  it '/admin/shelters index shows link and navigates to show page' do
    shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: true, rank: 9)
    shelter_2 = Shelter.create!(name: 'Denver shelter', city: 'Denver, CO', foster_program: true, rank: 9)
    shelter_3 = Shelter.create!(name: 'Maxfund', city: 'Denver, CO', foster_program: true, rank: 9)

    visit "/admin/shelters"

    within('#shelter_name-0') do
      click_link("#{shelter_3.name}")
      expect(current_path).to eq("/admin/shelters/#{shelter_3.id}")
    end
  end

  it "/admin/shelters has shelter's with pending apps section" do
    shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: true, rank: 9)
    shelter_2 = Shelter.create!(name: 'Denver shelter', city: 'Denver, CO', foster_program: true, rank: 9)
    shelter_3 = Shelter.create!(name: 'Maxfund', city: 'Denver, CO', foster_program: true, rank: 9)
    pet_1 = Pet.create!(adoptable: true, age: 2, breed: 'domestic short hair', name: 'Mundungous', shelter_id: shelter_1.id)
    pet_2 = Pet.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Captain Pants', shelter_id: shelter_2.id)
    pet_3 = Pet.create!(adoptable: true, age: 1, breed: 'domestic short hair', name: 'Billy', shelter_id: shelter_3.id)

    application_1 = Application.create!(name: "Holden Caulfield", street_address: "123 Main St", city: "Denver", state: "CO", zipcode: 80216, description: "I wouldn't be a good pet owner", status: "Pending")
    application_2 = Application.create!(name: "Hermione Granger", street_address: "987 Broadway", city: "Denver", state: "CO", zipcode: 80203, description: "I love animals.", status: "Pending")

    PetApplication.create!(pet: pet_1, application: application_1)
    PetApplication.create!(pet: pet_2, application: application_2)

    visit "/admin/shelters"

    within('#pending_apps') do
      expect(page).to have_content("#{shelter_1.name}")
      expect(page).to have_content("#{shelter_2.name}")
      expect(page).to_not have_content("#{shelter_3.name}")
    end
  end
end
