#encoding: utf-8
class CreatePages < ActiveRecord::Migration[5.2]
  def change
    create_table :pages do |t|
      t.string      :title
      t.string      :abstract
      t.text        :content
      t.string      :slug

      t.timestamps
    end

    add_index :pages, :title, :unique => true
    add_index :pages, :slug, :unique => true
  end
end
