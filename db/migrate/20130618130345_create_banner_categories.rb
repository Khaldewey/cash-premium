#encoding: utf-8
class CreateBannerCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :banner_categories do |t|
      t.string :name
      t.boolean :is_active, default: true
    end

    add_index :banner_categories, :name, :unique => true
    add_index :banner_categories, :is_active
  end
end
