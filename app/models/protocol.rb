class Protocol < ApplicationRecord
  searchkick highlight: [:title, :abstract, :materials_and_methods]

  def highlights
    self.search_highlights if self.respond_to? :search_highlights
  end
end
