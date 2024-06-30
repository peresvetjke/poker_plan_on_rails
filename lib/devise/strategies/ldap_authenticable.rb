# frozen_string_literal: true

require 'net/ldap'
require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class LdapAuthenticatable < Authenticatable
      LDAP_HOST = 'ldcro.rambler.ramblermedia.com'
      LDAP_PORT = 389
      LDAP_USER = 'CN=ldap.mate,OU=LdapAuth,OU=Users-Service,OU=RIH,DC=rambler,DC=ramblermedia,DC=com'

      def authenticate!
        user = authenticate_user
        return fail(:invalid_login) unless user # rubocop:disable Style/SignalException

        success! user
      end

      private

      def authenticate_user
        return unless required_params_present?

        ldap.host = LDAP_HOST
        ldap.port = LDAP_PORT
        ldap.auth LDAP_USER, ENV.fetch('LDAP_PASSWORD')
        return unless ldap_response

        User.where(email: ldap_email).first_or_create!(attrs)
      end

      def ldap
        @ldap ||= Net::LDAP.new
      end

      def ldap_response
        @ldap_response ||= ldap_response_company.first || ldap_response_external.first
      end

      def ldap_response_company
        @ldap_response_company ||= ldap.bind_as(
          base: 'ou=company,dc=rambler,dc=ramblermedia,dc=com',
          filter: ldap_filter(email),
          password:
        ) || []
      end

      def ldap_response_external
        @ldap_response_external ||= ldap.bind_as(
          base: 'ou=UsersExternal,ou=RIH,dc=rambler,dc=ramblermedia,dc=com',
          filter: ldap_filter(email),
          password:
        ) || []
      end

      def ldap_filter(email)
        username = email.split('@').first
        "(&(objectcategory=person)(objectclass=user)(|(samaccountname=#{username})(mail=#{email})))"
      end

      def ldap_email
        ldap_response[:mail].first.downcase
      end

      def attrs
        {
          password:,
          last_name: ldap_response['SN'].first,
          first_name: ldap_response['GivenName'].first
        }
      end

      def required_params_present?
        [email, password].all?(&:present?)
      end

      def email
        params.dig(:user, :email)
      end

      def password
        params.dig(:user, :password)
      end
    end
  end
end
