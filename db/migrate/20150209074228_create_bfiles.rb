class CreateBfiles < ActiveRecord::Migration
  def change
    create_table :bfiles do |t|

      t.timestamps null: false
    end
  end
end
