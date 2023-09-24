class CreatePessoas < ActiveRecord::Migration[7.0]
  def change
    create_table :pessoas, id: :uuid do |t|
      t.string :apelido, null: false, unique: true, limit: 32
      t.string :nome, null: false, limit: 100
      t.date :nascimento, null: false
      t.string :stack, array: true

      t.timestamps
    end
  end
end
