class CreateSocialNetworks < ActiveRecord::Migration[5.2]
  def change
    create_table :social_networks do |t|
      t.string   :name
      t.string   :slug
      t.string   :url

      t.timestamps
    end
  end
end
