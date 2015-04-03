module EmailHelpers
  def have_i18n_subject_for(email_name)
    have_subject(I18n.translate!("notifier.#{email_name}.subject"))
  end
end

RSpec.configure do |config|
  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)
  config.include(EmailHelpers)
end
