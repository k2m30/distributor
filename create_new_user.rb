require 'mechanize'

agent = Mechanize.new
page = agent.get('http://localhost:3000/users/sign_up')
form = page.forms.first
form.field('user[username]').value = 'ydachnik'
form.field('user[email]').value = 'office@ydachnik.by
form.field('user[password]').value = '123QWEasd'
form.field('user[password_confirmation]').value = '123QWEasd'
form.submit
p form.body
