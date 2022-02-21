# frozen_string_literal: true

require File.expand_path('lib/prawn/swiss_qr_bill/version', __dir__)

Gem::Specification.new do |spec|
  spec.name = 'prawn-swiss_qr_bill'
  spec.version = Prawn::SwissQRBill::VERSION
  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 2.5.0'
  spec.summary = 'Swiss QR-Bill PDFs in Ruby with Prawn'
  spec.description = 'Ruby library for creating Swiss QR-Bills as PDF with Prawn'
  spec.homepage = 'https://github.com/mitosch/prawn-swiss_qr_bill'
  spec.license = 'MIT'
  spec.authors = ['Mischa Schindowski']
  spec.email = ['mschindowski@gmail.com']

  spec.files = Dir['lib/**/**/*.rb',
                   'lib/prawn/swiss_qr_bill/specs.yml',
                   'assets/images/*', 'assets/fonts/inter/*',
                   'config/locales/*.yml',
                   'prawn-swiss_qr_bill.gemspec',
                   'Gemfile', 'README.md', 'CHANGELOG.mg'
                  ]

  spec.add_dependency 'i18n', '~> 1.8'
  spec.add_dependency 'prawn', '~> 2.0'
  spec.add_dependency 'rqrcode', '~> 2.0'

  spec.add_development_dependency 'pdf-reader', '~> 2.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 1.0'
  spec.add_development_dependency 'rubocop-performance', '~> 1.5'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.8'
  spec.add_development_dependency 'simplecov', '~> 0.16'
  spec.add_development_dependency 'simplecov-cobertura', '~> 2.0'

  spec.metadata = {
    'rubygems_mfa_required' => 'true'
  }
end
