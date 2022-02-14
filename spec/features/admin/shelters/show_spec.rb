require 'rails_helper'

RSpec.describe 'the admin/shelter/:id' do
  it '/admin/shelters/:id - shows only name and city' do
    shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: true, rank: 9)

    visit "/admin/shelters/#{shelter_1.id}"

    expect(page).to have_content(shelter_1.name)
    expect(page).to have_content(shelter_1.city)
    expect(page).to_not have_content(shelter_1.rank)
  end
end
