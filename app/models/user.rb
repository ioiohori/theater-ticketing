class User < ApplicationRecord

  has_paper_trail ignore: %i(sign_in_count current_sign_in_at last_sign_in_at)

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { user: 0, vip: 1, admin: 2 }

  has_many :tickets
  has_many :subscriptions

  attr_accessor :cellphone_number

  def tickets_in_cart
    tickets.waiting.all.to_a
  end

  def subscriptions_in_cart
    subscriptions.waiting.all.to_a
  end
end
