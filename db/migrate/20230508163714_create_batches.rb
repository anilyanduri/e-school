class CreateBatches < ActiveRecord::Migration[7.0]
  def change
    create_table :batches do |t|
      t.string :name
      t.belongs_to :course, null: false, foreign_key: true
      t.belongs_to :school, null: false, foreign_key: true
      t.boolean :status

      t.timestamps
    end
  end
end
