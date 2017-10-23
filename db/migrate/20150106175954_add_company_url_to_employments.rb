class AddCompanyUrlToEmployments < ActiveRecord::Migration
  def change
    add_column :employments, :company_url, :string
    add_column :employments, :public_description, :string
    add_column :employments, :date_placed, :date
    add_column :employments, :yearly_salary, :integer
  end
end
