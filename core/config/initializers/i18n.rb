# We want I18n error to raise in development and test.
# However, the option config.i18n.fallbacks = false doesn't seem to work (2014-03-19), so we need to manually raise on errors.

#see http://stackoverflow.com/questions/8551029/how-to-enable-rails-i18n-translation-errors-in-views or http://guides.rubyonrails.org/i18n.html#using-different-exception-handlers

if Rails.env.development? || Rails.env.test?
  module I18n
    class JustRaiseExceptionHandler < ExceptionHandler
      def call(exception, locale, key, options)
          raise exception.to_exception
      end
    end
  end

  I18n.exception_handler = I18n::JustRaiseExceptionHandler.new
end
