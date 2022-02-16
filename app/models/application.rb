class Application < ApplicationRecord
  validates :name, presence: true
  validates :street_address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zipcode, presence: true, numericality: true
  has_many :pet_applications
  has_many :pets, through: :pet_applications

  def check_status
   if pet_applications.exists?(status: "Pending")
     "Pending"
   elsif pet_applications.exists?(status: "Rejected")
     "Rejected"
   else
     "Approved"
   end
 end

 def approve
   update(status: "Approved")
   pets.each do |pet|
     pet.update(adoptable: false)
   end
 end

 def reject
   update(status: "Rejected")
 end

 def update_status
   if status != check_status
     if check_status == "Approved"
       approve
     else
       reject
     end
   end
 end
end
