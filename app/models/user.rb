class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,  :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:username]
  has_many :groups
  def get_all_items_json
    Item.order(:name).pluck(:name).to_json
  end
end
