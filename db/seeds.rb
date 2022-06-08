# frozen_string_literal: true

User.create!(
  first_name: 'Test',
  last_name: 'UserOne',
  email: 'test@email.com',
  password: 'Test1234*',
  password_confirmation: 'Test1234*',
  phone: '+8801312345678'
)

User.create!(
  first_name: 'User',
  last_name: 'Two',
  email: 'test1@email.com',
  password: 'Test1234*',
  password_confirmation: 'Test1234*',
  phone: '+8801312345679'
)
