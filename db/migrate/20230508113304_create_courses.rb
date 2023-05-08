class CreateCourses < ActiveRecord::Migration[7.0]
  def change
    create_table :courses do |t|
      t.string :name
      t.string :description
      t.binary :material
      t.belongs_to :school, null: false, foreign_key: true
      t.boolean :status

      t.timestamps
    end
  end
end
