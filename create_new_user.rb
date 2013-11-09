require "mechanize"

agent = Mechanize.new
page = agent.get("http://localhost:3000/users/sign_up")
form = page.forms.first
form.field("user[username]").value = "k2m30"
form.field("user[email]").value = "1m@tut.by"
form.field("user[password]").value = "mustdie"
form.field("user[password_confirmation]").value = "mustdie"
form.submit
p form
