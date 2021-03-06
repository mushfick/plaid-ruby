require 'hashie'

module Plaid
  module Models
    # Internal: Base model for all other models.
    class BaseModel < Hashie::Dash
      include Hashie::Extensions::Dash::IndifferentAccess
      include Hashie::Extensions::Dash::Coercion

      # Internal: Be strict or forgiving depending on Plaid.relaxed_models
      # value.
      def assert_property_exists!(property)
        super unless Plaid.relaxed_models?
      end
    end

    # Internal: Base API response.
    class BaseResponse < BaseModel
      ##
      # :attr_reader:
      # Public: The String request ID assigned by the API.
      property :request_id
    end

    # Public: A representation of an error.
    class Error < BaseModel
      ##
      # :attr_reader:
      # Public: The String broad categorization of the error. One of:
      # 'INVALID_REQUEST', 'INVALID_INPUT', 'RATE_LIMIT_EXCEEDED', 'API_ERROR',
      # or 'ITEM_ERROR'.
      property :error_type

      ##
      # :attr_reader:
      # Public: The particular String error code. Each error_type has a
      # specific set of error_codes.
      property :error_code

      ##
      # :attr_reader:
      # Public: A developer-friendly representation of the error message.
      property :error_message

      ##
      # :attr_reader:
      # Public: A user-friendly representation of the error message. nil if the
      # error is not related to user action.
      property :display_message
    end

    # Public: A representation of an item.
    class Item < BaseModel
      ##
      # :attr_reader:
      # Public: The Array with String products available for this item
      # (e.g. ["balance", "auth"]).
      property :available_products

      ##
      # :attr_reader:
      # Public: The Array with String products billed for this item
      # (e.g. ["identity", "transactions"]).
      property :billed_products

      ##
      # :attr_reader:
      # Public: The String error related to
      property :error, coerce: Error

      ##
      # :attr_reader:
      # Public: The String institution ID for this item.
      property :institution_id

      ##
      # :attr_reader:
      # Public: The String item ID.
      property :item_id

      ##
      # :attr_reader:
      # Public: The String webhook URL.
      property :webhook
    end

    # Public: A representation of account balances.
    class Balances < BaseModel
      ##
      # :attr_reader:
      # Public: The Numeric available balance (or nil).
      property :available

      ##
      # :attr_reader:
      # Public: The Numeric current balance (or nil).
      property :current

      ##
      # :attr_reader:
      # Public: The Numeric limit (or nil).
      property :limit
    end

    # Public: A representation of an account.
    class Account < BaseModel
      ##
      # :attr_reader:
      # Public: The String account ID, e.g.
      # "QKKzevvp33HxPWpoqn6rI13BxW4awNSjnw4xv".
      property :account_id

      ##
      # :attr_reader:
      # Public: Balances for this account.
      property :balances, coerce: Balances

      ##
      # :attr_reader:
      # Public: The String mask, e.g. "0000".
      property :mask

      ##
      # :attr_reader:
      # Public: The String account name, e.g. "Plaid Checking".
      property :name

      ##
      # :attr_reader:
      # Public: The String official account name, e.g. "Plaid Gold Checking".
      property :official_name

      ##
      # :attr_reader:
      # Public: The String type, e.g. "depository".
      property :type

      ##
      # :attr_reader:
      # Public: The String subtype, e.g. "checking".
      property :subtype
    end

    # Public: A representation of an account number.
    class Number < BaseModel
      ##
      # :attr_reader:
      # Public: The String account number. E.g. "1111222233330000".
      property :account

      ##
      # :attr_reader:
      # Public: The String account ID. E.g.
      # "vzeNDwK7KQIm4yEog683uElbp9GRLEFXGK98D".
      property :account_id

      ##
      # :attr_reader:
      # Public: The String routing number. E.g. "011401533".
      property :routing

      ##
      # :attr_reader:
      # Public: The String wire routing number. E.g. "021000021".
      property :wire_routing
    end

    # Public: A representation of a transaction category.
    class Category < BaseModel
      ##
      # :attr_reader:
      # Public: The String category ID. E.g. "10000000".
      property :category_id

      ##
      # :attr_reader:
      # Public: The Array of Strings category hierarchy.
      # E.g. ["Recreation", "Arts & Entertainment", "Circuses and Carnivals"].
      property :hierarchy

      ##
      # :attr_reader:
      # Public: The String category group. E.g. "place".
      property :group
    end

    # Public: A representation of a single Credit Details APR.
    class CreditDetailsAPR < BaseModel
      ##
      # :attr_reader:
      # Public: The Numeric APR (e.g. 0.125).
      property :apr

      ##
      # :attr_reader:
      # Public: The Numeric balance subject to APR (e.g. 1200).
      property :balance_subject_to_apr

      ##
      # :attr_reader:
      # Public: The Numeric interest charge amount (e.g. 150).
      property :interest_charge_amount
    end

    # Public: A representation of Credit Details APRs data.
    class CreditDetailsAPRs < BaseModel
      ##
      # :attr_reader:
      # Public: Balance transfers APR
      property :balance_transfers, coerce: CreditDetailsAPR

      ##
      # :attr_reader:
      # Public: Cash advances APR
      property :cash_advances, coerce: CreditDetailsAPR

      ##
      # :attr_reader:
      # Public: Purchases APR
      property :purchases, coerce: CreditDetailsAPR
    end

    # Public: A representation of Credit Details data.
    class CreditDetails < BaseModel
      ##
      # :attr_reader:
      # Public: The String account ID. E.g.
      # "vzeNDwK7KQIm4yEog683uElbp9GRLEFXGK98D".
      property :account_id

      ##
      # :attr_reader:
      # Public: The APRs.
      property :aprs, coerce: CreditDetailsAPRs

      ##
      # :attr_reader:
      # Public: The Numeric last payment amount (e.g. 875).
      property :last_payment_amount

      ##
      # :attr_reader:
      # Public: The String last payment date. E.g. "2016-09-13T00:00:00Z".
      property :last_payment_date

      ##
      # :attr_reader:
      # Public: The Numeric last statement balance (e.g. 3450).
      property :last_statement_balance

      ##
      # :attr_reader:
      # Public: The String last statement date. E.g. "2016-10-01T00:00:00Z".
      property :last_statement_date

      ##
      # :attr_reader:
      # Public: The Numeric minimum payment amount (e.g. 800).
      property :minimum_payment_amount

      ##
      # :attr_reader:
      # Public: The String next bill due date. E.g. "2016-10-15T00:00:00Z".
      property :next_bill_due_date
    end

    # Public: A representation of Identity address details.
    class IdentityAddressData < BaseModel
      ##
      # :attr_reader:
      # Public: The String street name.
      property :street

      ##
      # :attr_reader:
      # Public: The String name.
      property :city

      ##
      # :attr_reader:
      # Public: The String state name.
      property :state

      ##
      # :attr_reader:
      # Public: The String ZIP code.
      property :zip
    end

    # Public: A representation of Identity address data.
    class IdentityAddress < BaseModel
      ##
      # :attr_reader:
      # Public: The Array of String accounts, associated with this address.
      # E.g. ["Plaid Credit Card 3333"].
      property :accounts

      ##
      # :attr_reader:
      # Public: The Boolean primary flag (true if it's the primary address).
      property :primary

      ##
      # :attr_reader:
      # Public: The address data.
      property :data, coerce: IdentityAddressData
    end

    # Public: A representation of Identity email data.
    class IdentityEmail < BaseModel
      ##
      # :attr_reader:
      # Public: The String data, i.e. the address itself. E.g.
      # "accountholder0@example.com".
      property :data

      ##
      # :attr_reader:
      # Public: The Boolean primary flag.
      property :primary

      ##
      # :attr_reader:
      # Public: The String type. E.g. "primary", or "secondary", or "other".
      property :type
    end

    # Public: A representation of Identity phone number data.
    class IdentityPhoneNumber < BaseModel
      ##
      # :attr_reader:
      # Public: The String data, i.e. the number itself. E.g.
      # "4673956022".
      property :data

      ##
      # :attr_reader:
      # Public: The Boolean primary flag.
      property :primary

      ##
      # :attr_reader:
      # Public: The String type. E.g. "home", or "work", or "mobile1".
      property :type
    end

    # Public: A representation of Identity data.
    class Identity < BaseModel
      ##
      # :attr_reader:
      # Public: Addresses: Array of IdentityAddress.
      property :addresses, coerce: Array[IdentityAddress]

      ##
      # :attr_reader:
      # Public: Emails: Array of IdentityEmail.
      property :emails, coerce: Array[IdentityEmail]

      ##
      # :attr_reader:
      # Public: The Array of String names. E.g. ["John Doe", "Ronald McDonald"].
      property :names

      ##
      # :attr_reader:
      # Public: Phone numbers: Array of IdentityPhoneNumber.
      property :phone_numbers, coerce: Array[IdentityPhoneNumber]
    end

    # Public: A representation of Income Stream data.
    class IncomeStream < BaseModel
      ##
      # :attr_reader:
      # Public: The Numeric monthly income associated with the income stream.
      property :monthly_income

      ##
      # :attr_reader:
      # Public: The Numeric representation of our confidence in the income data
      # associated with this particular income stream, with 0 being the lowest
      # confidence and 1 being the highest.
      property :confidence

      ##
      # :attr_reader:
      # Public: The Numeric extent of data found for this income stream.
      property :days

      ##
      # :attr_reader:
      # Public: The String name of the entity associated with this income
      # stream.
      property :name
    end

    # Public: A representation of Income data.
    class Income < BaseModel
      ##
      # :attr_reader:
      # Public: An Array of IncomeStream with detailed information.
      property :income_streams, coerce: Array[IncomeStream]

      ##
      # :attr_reader:
      # Public: The Numeric last year income, i.e. the sum of the Item's
      # income over the past 365 days. If Plaid has less than 365 days of data
      # this will be less than a full year's income.
      property :last_year_income

      ##
      # :attr_reader:
      # Public: The Numeric last_year_income interpolated to value before
      # taxes. This is the minimum pre-tax salary that assumes a filing status
      # of single with zero dependents.
      property :last_year_income_before_tax

      ##
      # :attr_reader:
      # Public: The Numeric income extrapolated over a year based on current,
      # active income streams. Income streams become inactive if they have not
      # recurred for more than two cycles. For example, if a weekly paycheck
      # hasn't been seen for the past two weeks, it is no longer active.
      property :projected_yearly_income

      ##
      # :attr_reader:
      # Public: The Numeric projected_yearly_income interpolated to value
      # before taxes. This is the minimum pre-tax salary that assumes a filing
      # status of single with zero dependents.
      property :projected_yearly_income_before_tax

      ##
      # :attr_reader:
      # Public: The Numeric max number of income streams present at the same
      # time over the past 365 days.
      property :max_number_of_overlapping_income_streams

      ##
      # :attr_reader:
      # Public: The Numeric total number of distinct income streams received
      # over the past 365 days.
      property :number_of_income_streams
    end

    # Public: A representation of an institution login credential.
    class InstitutionCredential < BaseModel
      ##
      # :attr_reader:
      # Public: The String label. E.g. "User ID".
      property :label

      ##
      # :attr_reader:
      # Public: The String name. E.g. "username".
      property :name

      ##
      # :attr_reader:
      # Public: The String type. E.g. "text", or "password".
      property :type
    end

    # Public: A representation of Institution.
    class Institution < BaseModel
      ##
      # :attr_reader:
      # Public: The Array of InstitutionCredential, presenting information on
      # login credentials used for the institution.
      property :credentials, coerce: Array[InstitutionCredential]

      ##
      # :attr_reader:
      # Public: The Boolean flag indicating if the institution uses MFA.
      property :has_mfa

      ##
      # :attr_reader:
      # Public: The String institution ID (e.g. "ins_109512").
      property :institution_id

      ##
      # :attr_reader:
      # Public: The String institution name (e.g. "Houndstooth Bank").
      property :name

      ##
      # :attr_reader:
      # Public: The Array of String MFA types.
      # E.g. ["code", "list", "questions", "selections"].
      property :mfa

      ##
      # :attr_reader:
      # Public: The Array of String product names supported by this institution.
      # E.g. ["auth", "balance", "identity", "transactions"].
      property :products
    end

    module MFA
      # Public: A representation of an MFA device.
      class Device < BaseModel
        ##
        # :attr_reader:
        # Public: The String message related to sending code to the device.
        property :display_message
      end

      # Public: A representation of a single element in a device list.
      class DeviceListElement < BaseModel
        ##
        # :attr_reader:
        # Public: The String device ID.
        property :device_id

        ##
        # :attr_reader:
        # Public: The String device mask.
        property :mask

        ##
        # :attr_reader:
        # Public: The String device type.
        property :type
      end

      # Public: A representation of MFA selection.
      class Selection < BaseModel
        ##
        # :attr_reader:
        # Public: The String question.
        property :question

        ##
        # :attr_reader:
        # Public: The Array of String answers.
        property :answers
      end
    end

    # Public: A representation of Transaction location.
    class TransactionLocation < BaseModel
      ##
      # :attr_reader:
      # Public: The String address (or nil).
      property :address

      ##
      # :attr_reader:
      # Public: The String city name (or nil).
      property :city

      ##
      # :attr_reader:
      # Public: The Numeric latitude of the place (or nil).
      property :lat

      ##
      # :attr_reader:
      # Public: The Numeric longitude of the place (or nil).
      property :lon

      ##
      # :attr_reader:
      # Public: The String state name (or nil).
      property :state

      ##
      # :attr_reader:
      # Public: The String store number (or nil).
      property :store_number

      ##
      # :attr_reader:
      # Public: The String ZIP code (or nil).
      property :zip
    end

    # Public: A representation of Transaction Payment meta information.
    class TransactionPaymentMeta < BaseModel
      ##
      # :attr_reader:
      property :by_order_of
      ##
      # :attr_reader:
      property :ppd_id
      ##
      # :attr_reader:
      property :payee
      ##
      # :attr_reader:
      property :payer
      ##
      # :attr_reader:
      property :payment_method
      ##
      # :attr_reader:
      property :payment_processor
      ##
      # :attr_reader:
      property :reason
      ##
      # :attr_reader:
      property :reference_number
    end

    # Public: A representation of Transaction.
    class Transaction < BaseModel
      ##
      # :attr_reader:
      # Public: The String transaction ID.
      property :transaction_id

      ##
      # :attr_reader:
      # Public: The String account ID.
      property :account_id

      ##
      # :attr_reader:
      # Public: The String account owner (or nil).
      property :account_owner

      ##
      # :attr_reader:
      # Public: The Numeric amount (or nil).
      property :amount

      ##
      # :attr_reader:
      # Public: The Array of String category (or nil).
      # E.g. ["Payment", "Credit Card"].
      property :category

      ##
      # :attr_reader:
      # Public: The String category_id (or nil).
      # E.g. "16001000".
      property :category_id

      ##
      # :attr_reader:
      # Public: The String transaction date. E.g. "2017-01-01".
      property :date

      ##
      # :attr_reader:
      # Public: The location where transaction occurred (TransactionLocation).
      property :location, coerce: TransactionLocation

      ##
      # :attr_reader:
      # Public: The String transaction name (or nil).
      # E.g. "CREDIT CARD 3333 PAYMENT *//".
      property :name

      ##
      # :attr_reader:
      # Public: The String original description (or nil).
      property :original_description

      ##
      # :attr_reader:
      # Public: The payment meta information (TransactionPaymentMeta).
      property :payment_meta, coerce: TransactionPaymentMeta

      ##
      # :attr_reader:
      # Public: The Boolean pending flag (or nil).
      property :pending

      ##
      # :attr_reader:
      # Public: The String pending transaction ID (or nil).
      property :pending_transaction_id

      ##
      # :attr_reader:
      # Public: The String transaction type (or nil). E.g. "special", or
      # "place".
      property :transaction_type
    end
  end
end
