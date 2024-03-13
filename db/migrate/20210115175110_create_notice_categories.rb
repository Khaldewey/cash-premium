class CreateNoticeCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :notice_categories do |t|
      t.string :name
      t.string :slug

      t.timestamps
    end
  end
end
