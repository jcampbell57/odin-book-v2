# Preview all emails at http://localhost:3000/rails/mailers/welcome_mailer
class WelcomeMailerPreview < ActionMailer::Preview
  def welcome_email
    # Set up a temporary user for the preview
    user = User.all.first

    WelcomeMailer.with(user:).welcome_email
  end
end
