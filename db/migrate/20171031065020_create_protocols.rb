class CreateProtocols < ActiveRecord::Migration[5.1]
  def change
    create_table :protocols do |t|
      t.string :title
      t.text :abstract
      t.text :materials_and_methods
      t.string :journal
      t.string :journal_id
      t.datetime :publication_date

      t.timestamps
    end
  end
end
